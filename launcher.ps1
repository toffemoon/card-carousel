# Card carousel demo launcher: open browser if already running, else start vite first
# NOTE: keep this file ASCII-only - PowerShell 5.1 misreads UTF-8 without BOM.
$port = 5174
$root = $PSScriptRoot

$listening = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if (-not $listening) {
    $viteJs = Join-Path $root "node_modules\vite\bin\vite.js"
    Start-Process -FilePath "node" -ArgumentList ('"' + $viteJs + '" --port ' + $port + ' --strictPort') -WorkingDirectory $root -WindowStyle Hidden
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Milliseconds 500
        if (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) { break }
    }
}

Start-Process ("http://localhost:" + $port)
