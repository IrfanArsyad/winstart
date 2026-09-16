# WinStart - Main Interactive Menu Hub (Windows)
# Run PowerShell as Administrator

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$scriptDir = $PSScriptRoot

while ($true) {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "          WINSTART - SYSTEM SETUP HUB             " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    
    if (-not (Test-IsAdmin)) {
        Write-Host "[!] WARNING: Tidak berjalan sebagai Administrator!" -ForegroundColor Red
        Write-Host "    Beberapa setup memerlukan hak akses Administrator.`n" -ForegroundColor Red
    }

    Write-Host " [1] Tailscale Auto-Start & Service Manager" -ForegroundColor White
    Write-Host " [0] Keluar" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    
    $choice = Read-Host "Pilih modul setup [0-1]"

    switch ($choice) {
        "1" {
            $path = Join-Path $scriptDir "windows\tailscale-autostart.ps1"
            if (Test-Path $path) {
                & $path
            } else {
                Write-Host "[!] File script '$path' tidak ditemukan." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
        "0" {
            Write-Host "`nSampai jumpa!" -ForegroundColor Green
            exit 0
        }
        default {
            Write-Host "[!] Pilihan tidak valid." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
