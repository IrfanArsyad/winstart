#!/bin/bash
# Tailscale Manager & Auto-Start Setup (Linux CLI)
# Run as root or with sudo

AUTO_SETUP=false

if [ "$1" = "-a" ] || [ "$1" = "--auto" ]; then
    AUTO_SETUP=true
fi

check_installed() {
    if ! command -v tailscale &> /dev/null; then
        echo -e "\033[31m[!] Tailscale belum terinstall. Silakan install Tailscale terlebih dahulu.\033[0m"
        return 1
    fi
    return 0
}

enable_autostart() {
    echo -e "\n\033[36m=== Memasang Tailscale Auto-Start (systemd) ===\033[0m"
    if ! check_installed; then return; fi

    echo "[+] Mengaktifkan dan menjalankan service tailscaled..."
    sudo systemctl enable --now tailscaled

    echo "[+] Mengaktifkan mode unattended..."
    sudo tailscale set --unattended=true 2>/dev/null || true

    show_status
}

disable_autostart() {
    echo -e "\n\033[36m=== Mematikan Tailscale Auto-Start ===\033[0m"
    sudo systemctl disable tailscaled
    echo "[+] Auto-start (systemd service) dimatikan."
}

restart_service() {
    echo -e "\n\033[36m=== Restart Service Tailscale ===\033[0m"
    sudo systemctl restart tailscaled
    echo "[+] Service tailscaled berhasil di-restart."
}

show_status() {
    echo -e "\n\033[36m=== Status Service systemd ===\033[0m"
    systemctl status tailscaled --no-pager || true

    echo -e "\n\033[36m=== Status Jaringan Tailscale ===\033[0m"
    if check_installed; then
        tailscale status || true
    fi
}

if [ "$AUTO_SETUP" = true ]; then
    enable_autostart
    exit 0
fi

while true; do
    clear
    echo -e "\033[36m==================================================\033[0m"
    echo -e "\033[33m          TAILSCALE AUTOMATION CLI MENU (LINUX)   \033[0m"
    echo -e "\033[36m==================================================\033[0m"
    echo " [1] Pasang Auto-Start (Enable Service & Unattended Mode)"
    echo " [2] Cek Status Service & Jaringan Tailscale"
    echo " [3] Restart Service Tailscale"
    echo " [4] Matikan Auto-Start (Disable Service)"
    echo " [0] Keluar"
    echo -e "\033[36m==================================================\033[0m"
    
    read -p "Pilih menu [0-4]: " choice

    case $choice in
        1)
            enable_autostart
            read -p "Tekan Enter untuk kembali ke menu..."
            ;;
        2)
            show_status
            read -p "Tekan Enter untuk kembali ke menu..."
            ;;
        3)
            restart_service
            read -p "Tekan Enter untuk kembali ke menu..."
            ;;
        4)
            disable_autostart
            read -p "Tekan Enter untuk kembali ke menu..."
            ;;
        0)
            echo -e "\nTerima kasih!"
            exit 0
            ;;
        *)
            echo -e "\033[31m[!] Pilihan tidak valid.\033[0m"
            sleep 1
            ;;
    esac
done
