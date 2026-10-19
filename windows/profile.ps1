<#
  profile.ps1 — Perfil de PowerShell 7.
  install.ps1 lo enlaza a Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#>

<#
.SYNOPSIS
  Exporta un Markdown a PDF con pandoc + XeLaTeX.
.DESCRIPTION
  Los metadatos (título, autor, fecha) se leen del YAML del propio .md;
  los parámetros solo los sobrescriben u ocultan. Por defecto NO se imprime
  fecha: usa -WithDate para la del YAML o -Date para una explícita.
  El idioma es español salvo que el YAML indique otro "lang".
  Los bloques ```mermaid se convierten en diagramas (requiere mmdc).

  Uso: md2pdf <input.md> [-o salida.pdf] [-a autor] [-d fecha] [-t título]
              [-NoAuthor] [-WithDate] [-NoPages] [-Toc] [-Numbered]
              [-m margen] [-f tamaño_pt]
.EXAMPLE
  md2pdf apuntes.md
.EXAMPLE
  md2pdf apuntes.md -o entrega.pdf -a "Oscar" -Toc -Numbered -m 2cm -f 11
#>
function md2pdf {
    param(
        [Parameter(Position = 0)] [string]$Path,
        [Alias('o')] [string]$Output,
        [Alias('a')] [string]$Author,
        [Alias('d')] [string]$Date,
        [Alias('t')] [string]$Title,
        [Alias('m')] [string]$Margin,
        [Alias('f')] [int]$FontSize,
        [switch]$NoAuthor,
        [switch]$WithDate,
        [switch]$NoPages,
        [switch]$Toc,
        [switch]$Numbered,
        [Alias('h')] [switch]$Help
    )

    if ($Help) { Get-Help md2pdf -Detailed; return }

    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-Error "md2pdf: indica un fichero .md existente (md2pdf -h)"
        return
    }
    if (-not (Get-Command pandoc -ErrorAction SilentlyContinue) -or
        -not (Get-Command xelatex -ErrorAction SilentlyContinue)) {
        Write-Error "md2pdf: faltan pandoc y/o xelatex (winget install JohnMacFarlane.Pandoc MiKTeX.MiKTeX)"
        return
    }
    if (-not $Output) { $Output = [IO.Path]::ChangeExtension($Path, 'pdf') }

    $tmp = Join-Path ([IO.Path]::GetTempPath()) "md2pdf-$([guid]::NewGuid())"
    $header = "$tmp.tex"
    # Idioma por defecto ("Índice" en vez de "Contents", guionado...). Va en un
    # fichero de metadatos y no con -M para que el "lang" del YAML del .md mande.
    $defaults = "$tmp.yaml"
    $pandocArgs = @()
    $tex = @(
        # Envuelve líneas largas en bloques de código (comandos, etc.) en vez de
        # cortarlas por el margen: la plantilla por defecto de pandoc no activa
        # "breaklines" en el entorno Highlighting.
        '\usepackage{fvextra}'
        '\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,breakanywhere,commandchars=\\\{\}}'
        # Bloques de código sin lenguaje (``` a secas) usan el entorno "verbatim"
        # normal en vez de "Highlighting", y necesitan su propio arreglo.
        '\renewenvironment{verbatim}{\VerbatimEnvironment\begin{Verbatim}[breaklines=true,breakanywhere=true]}{\end{Verbatim}}'
    )

    # Por defecto sin fecha: \date{} evita que LaTeX imprima \today.
    if ($Date) {
        $pandocArgs += '-M', "date=$Date"
    } elseif (-not $WithDate) {
        $tex += '\date{}'
        $pandocArgs += '-M', 'date='
    }
    if ($NoAuthor) { $pandocArgs += '-M', 'author=' }
    if ($Author)   { $pandocArgs += '-M', "author=$Author" }
    if ($Title)    { $pandocArgs += '-M', "title=$Title" }
    if ($NoPages)  { $tex += '\pagestyle{empty}' }
    if ($Toc)      { $pandocArgs += '--toc' }
    if ($Numbered) { $pandocArgs += '--number-sections' }
    if ($Margin)   { $pandocArgs += '-V', "geometry:margin=$Margin" }
    if ($FontSize) { $pandocArgs += '-V', "fontsize=${FontSize}pt" }

    try {
        # Bloques ```mermaid: mmdc genera una copia del .md con cada bloque
        # sustituido por un PDF vectorial. Todo va al directorio temporal.
        $source = $Path
        if (Select-String -LiteralPath $Path -Pattern '^\s*```mermaid' -Quiet) {
            if (-not (Get-Command mmdc -ErrorAction SilentlyContinue)) {
                Write-Error "md2pdf: el documento tiene diagramas Mermaid y falta mmdc (npm install -g --allow-scripts=puppeteer @mermaid-js/mermaid-cli)"
                return
            }
            $source = "$tmp.md"
            $log = mmdc -i $Path -o $source -e pdf -f 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "md2pdf: mmdc no pudo generar los diagramas:`n$($log -join "`n")"
                return
            }
            # mmdc pone "diagram" como texto alternativo y pandoc lo imprimiría
            # como pie de figura.
            (Get-Content -LiteralPath $source -Raw) -replace '!\[diagram\]\(\./md2pdf-', '![](./md2pdf-' |
                Set-Content -LiteralPath $source -NoNewline
            $pandocArgs += '--resource-path', ('.', [IO.Path]::GetTempPath() -join [IO.Path]::PathSeparator)
        }

        # ASCII: un BOM al principio del .tex rompería la compilación.
        Set-Content -LiteralPath $header -Value $tex -Encoding ascii
        Set-Content -LiteralPath $defaults -Value 'lang: es' -Encoding ascii
        pandoc $source -o $Output --pdf-engine=xelatex -H $header --metadata-file $defaults @pandocArgs
        if ($LASTEXITCODE -eq 0) { Write-Host "PDF generado: $Output" }
    } finally {
        Remove-Item -Path "$tmp*" -ErrorAction SilentlyContinue
    }
}
