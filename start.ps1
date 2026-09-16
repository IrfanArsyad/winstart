# WinStart - Main Interactive Menu Hub (Windows)
# Run PowerShell as Administrator

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$baseUrl = "https://raw.githubusercontent.com/IrfanArsyad/winstart/main"

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
            $localPath = $null
            if ($PSScriptRoot) {
                $localPath = Join-Path $PSScriptRoot "windows\tailscale-autostart.ps1"
            }
            if ($localPath -and (Test-Path $localPath)) {
                & $localPath
            } else {
                Write-Host "`n[i] Mengunduh & menjalankan modul Tailscale secara remote..." -ForegroundColor Cyan
                irm "$baseUrl/windows/tailscale-autostart.ps1" | iex
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
