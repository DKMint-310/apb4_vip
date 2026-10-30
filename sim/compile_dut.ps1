param([string]$VivadoBin = '')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$outputDir = Join-Path $projectRoot 'results/dut_compile'
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
if ($VivadoBin) {
    $compiler = Join-Path $VivadoBin 'xvlog.bat'
    if (-not (Test-Path -LiteralPath $compiler)) { throw "Missing compiler: $compiler" }
} else {
    $compiler = (Get-Command xvlog -ErrorAction Stop).Source
}
$sources = @(Get-Content -LiteralPath (Join-Path $PSScriptRoot 'dut.f') |
    Where-Object { $_.Trim() -and -not $_.Trim().StartsWith('#') } |
    ForEach-Object { Join-Path $projectRoot $_.Trim() })
foreach ($source in $sources) {
    if (-not (Test-Path -LiteralPath $source)) { throw "Missing source: $source" }
}
$apbInclude = Join-Path $projectRoot 'third_party/apb/include'
$commonInclude = Join-Path $projectRoot 'third_party/common_cells/include'
Push-Location $outputDir
try {
    & $compiler -sv -i $apbInclude -i $commonInclude @sources -log compile.log
    if ($LASTEXITCODE -ne 0) { throw 'DUT source compilation failed; see results/dut_compile/compile.log' }
    Write-Host 'PASS: DUT source compilation only. No elaboration, UVM env or simulation run.'
} finally {
    Pop-Location
}
