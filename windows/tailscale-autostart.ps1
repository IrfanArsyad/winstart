# Tailscale Manager & Auto-Start Setup CLI
# Run PowerShell as Administrator

param (
    [switch]$AutoSetup
)

$ErrorActionPreference = "Continue"

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Check-TailscaleInstalled {
    $cmd = Get-Command tailscale.exe -ErrorAction SilentlyContinue
    if (-not $cmd) {
        Write-Host "[!] Tailscale executable tidak ditemukan di PATH." -ForegroundColor Red
        Write-Host "    Silakan install Tailscale terlebih dahulu." -ForegroundColor Yellow
        return $false
    }
    return $true
}

function Enable-AutoStart {
    Write-Host "`n=== Setting up Tailscale Auto-Start ===" -ForegroundColor Cyan
    
    if (-not (Check-TailscaleInstalled)) { return }

    if (-not (Test-IsAdmin)) {
        Write-Host "[!] Warning: Script harus dijalankan sebagai Administrator untuk mengubah Windows Service." -ForegroundColor Red
        return
    }

    $service = Get-Service -Name "Tailscale" -ErrorAction SilentlyContinue
    if (-not $service) {
        Write-Host "[!] Windows service 'Tailscale' tidak ditemukan." -ForegroundColor Red
        return
    }

    try {
        Set-Service -Name "Tailscale" -StartupType Automatic
        Write-Host "[+] Startup Type diubah ke: Automatic" -ForegroundColor Green

        if ($service.Status -ne "Running") {
            Start-Service -Name "Tailscale"
            Write-Host "[+] Service Tailscale berhasil dijalankan." -ForegroundColor Green
        } else {
            Write-Host "[i] Service Tailscale sudah berjalan." -ForegroundColor Green
        }
    } catch {
        Write-Host "[!] Gagal mengubah service status: $_" -ForegroundColor Red
    }

    try {
        & tailscale set --unattended=true
        Write-Host "[+] Unattended mode berhasil diaktifkan." -ForegroundColor Green
    } catch {
        Write-Host "[!] Gagal mengaktifkan unattended mode." -ForegroundColor Yellow
    }

    Show-Status
}

function Disable-AutoStart {
    Write-Host "`n=== Disabling Tailscale Auto-Start ===" -ForegroundColor Cyan
    
    if (-not (Test-IsAdmin)) {
        Write-Host "[!] Perlu hak akses Administrator." -ForegroundColor Red
        return
    }

    try {
        Set-Service -Name "Tailscale" -StartupType Manual
        Write-Host "[+] Startup Type diubah ke: Manual" -ForegroundColor Yellow
    } catch {
        Write-Host "[!] Gagal mengubah service: $_" -ForegroundColor Red
    }
}

function Restart-TailscaleService {
    Write-Host "`n=== Restarting Tailscale Service ===" -ForegroundColor Cyan
    
    if (-not (Test-IsAdmin)) {
        Write-Host "[!] Perlu hak akses Administrator." -ForegroundColor Red
        return
    }

    try {
        Restart-Service -Name "Tailscale"
        Write-Host "[+] Tailscale service berhasil di-restart." -ForegroundColor Green
    } catch {
        Write-Host "[!] Gagal me-restart service: $_" -ForegroundColor Red
    }
}

function Show-Status {
    Write-Host "`n=== Status Service Tailscale ===" -ForegroundColor Cyan
    $service = Get-Service -Name "Tailscale" -ErrorAction SilentlyContinue
    if ($service) {
        $service | Select-Object Status, Name, StartType | Format-Table -AutoSize
    } else {
        Write-Host "[!] Service Tailscale tidak ditemukan." -ForegroundColor Red
    }

    Write-Host "`n=== Status Jaringan Tailscale ===" -ForegroundColor Cyan
    if (Check-TailscaleInstalled) {
        & tailscale status
    }
}

# If -AutoSetup flag is specified
if ($AutoSetup) {
    Enable-AutoStart
    exit 0
}

# Interactive CLI Menu
while ($true) {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "          TAILSCALE AUTOMATION CLI MENU           " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    
    if (-not (Test-IsAdmin)) {
        Write-Host "[!] WARNING: Tidak berjalan sebagai Administrator!" -ForegroundColor Red
        Write-Host "    Beberapa fitur (Service) memerlukan Administrator.`n" -ForegroundColor Red
    }

    Write-Host " [1] Pasang Auto-Start (Automatic Service & Unattended Mode)" -ForegroundColor White
    Write-Host " [2] Cek Status Service & Jaringan Tailscale" -ForegroundColor White
    Write-Host " [3] Restart Service Tailscale" -ForegroundColor White
    Write-Host " [4] Matikan Auto-Start (Ubah ke Manual)" -ForegroundColor White
    Write-Host " [0] Keluar" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    
    $choice = Read-Host "Pilih menu [0-4]"

    switch ($choice) {
        "1" {
            Enable-AutoStart
            Read-Host "`nTekan Enter untuk kembali ke menu..."
        }
        "2" {
            Show-Status
            Read-Host "`nTekan Enter untuk kembali ke menu..."
        }
        "3" {
            Restart-TailscaleService
            Read-Host "`nTekan Enter untuk kembali ke menu..."
        }
        "4" {
            Disable-AutoStart
            Read-Host "`nTekan Enter untuk kembali ke menu..."
        }
        "0" {
            Write-Host "`nTerima kasih!" -ForegroundColor Green
            exit 0
        }
        default {
            Write-Host "[!] Pilihan tidak valid." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
