$ErrorActionPreference = 'Stop'
$env:ELECTRON_MIRROR = 'https://npmmirror.com/mirrors/electron/'
Write-Host "=========================================="
Write-Host "  DaFeiYu Desktop Pet Installer"
Write-Host "  Standalone mode, no DSH required"
Write-Host "=========================================="
Write-Host ""

# ---------- 1. Prepare Node.js ----------
$sysNode = Get-Command node -ErrorAction SilentlyContinue
if ($sysNode) {
    $ver = & node -v 2>$null
    Write-Host "[1/5] Node.js detected: $ver"
} else {
    Write-Host "[1/5] Node.js not found, downloading portable Node v24.19.0 from npmmirror (~35MB)..."
    $zip = "$env:TEMP\node-v24.19.0-win-x64.zip"
    curl.exe -L -o $zip "https://npmmirror.com/mirrors/node/v24.19.0/node-v24.19.0-win-x64.zip"
    if (-not (Test-Path $zip)) {
        Write-Host "Download Node failed, please check network and retry."
        Read-Host "Press Enter to exit"; exit 1
    }
    Write-Host "Extracting..."
    try { Expand-Archive -Path $zip -DestinationPath $env:LOCALAPPDATA -Force } catch {
        Write-Host "Extract failed: $($_.Exception.Message)"
        Read-Host "Press Enter to exit"; exit 1
    }
    if (-not (Test-Path "$env:LOCALAPPDATA\node-v24.19.0-win-x64\node.exe")) {
        Write-Host "Extract failed, please install Node.js manually and retry."
        Read-Host "Press Enter to exit"; exit 1
    }
    Write-Host "Portable Node ready"
}
$nodeDir = "$env:LOCALAPPDATA\node-v24.19.0-win-x64"
$env:PATH = "$nodeDir;$env:PATH"
$npmCmd = "$nodeDir\npm.cmd"
if (-not (Test-Path $npmCmd)) { $npmCmd = "npm.cmd" }

# ---------- 2. Configure npm (China mirrors + user dir, no admin) ----------
Write-Host "[2/5] Configuring China mirrors (npm + electron)"
& $npmCmd config set registry https://registry.npmmirror.com 2>$null
# Note: npm 11+ rejects custom config keys like electron_mirror (caused exit).
# Electron mirror is already set via $env:ELECTRON_MIRROR at the top of this script.
& $npmCmd config set prefix "$env:LOCALAPPDATA\npm" 2>$null
$env:PATH = "$env:LOCALAPPDATA\npm;$env:PATH"

# ---------- 3. Install dsh-pet (idempotent: reinstall only updates, skips downloads) ----------
Write-Host "[3/5] Installing dsh-pet (~62MB, China mirror; already installed will skip)"
& $npmCmd install -g dsh-pet
if ($LASTEXITCODE -ne 0) {
    Write-Host "Install failed, please check network and retry."
    Read-Host "Press Enter to exit"; exit 1
}

# ---------- 4. Create a desktop launcher so the pet can be started later ----------
Write-Host "[4/5] Creating desktop launcher..."
$desktop = [Environment]::GetFolderPath('Desktop')
$launcher = Join-Path $desktop ([char]0x542F + [char]0x52A8 + [char]0x5927 + [char]0x80A5 + [char]0x9C7C + '.bat')
$launcherContent = @('@echo off','title DaFeiYu Desktop Pet','set "PATH=%LOCALAPPDATA%\node-v24.19.0-win-x64;%LOCALAPPDATA%\npm;%PATH%"','"%LOCALAPPDATA%\npm\dsh-pet-standalone.cmd"','pause')
[System.IO.File]::WriteAllLines($launcher, $launcherContent, (New-Object System.Text.ASCIIEncoding))
Write-Host "Desktop launcher created."

# ---------- 5. Start the pet ----------
Write-Host "[5/5] First launch may download Electron runtime (~115MB from China mirror), please wait 1-3 min"
$already = Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue
if ($already) {
    Write-Host "A pet instance is already running (port 3080). Skip starting to avoid duplicates."
    Write-Host "If the pet is missing, close the old black window first, then double-click the desktop launcher."
} else {
    Write-Host "Starting the pet... (look for 'desktop helper started' in the log = success)"
    & "$env:LOCALAPPDATA\npm\dsh-pet-standalone.cmd"
    Write-Host ""
    Write-Host "The pet has exited (or failed to start)."
}
Write-Host "Tip: keep this window open while the pet runs; you may minimize it."
Write-Host "Next time: double-click the desktop launcher to start; no download needed."
Read-Host "Press Enter to exit"
