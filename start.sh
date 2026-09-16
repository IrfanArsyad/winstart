#!/bin/bash
# WinStart - Main Interactive Menu Hub (Linux)
# Run as root or with sudo

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" 2>/dev/null && pwd )"
BASE_URL="https://raw.githubusercontent.com/IrfanArsyad/winstart/main"

while true; do
    clear
    echo -e "\033[36m==================================================\033[0m"
    echo -e "\033[33m          WINSTART - SYSTEM SETUP HUB (LINUX)     \033[0m"
    echo -e "\033[36m==================================================\033[0m"
    echo " [1] Tailscale Auto-Start & Service Manager"
    echo " [0] Keluar"
    echo -e "\033[36m==================================================\033[0m"
    
    read -p "Pilih modul setup [0-1]: " choice

    case $choice in
        1)
            if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/linux/tailscale-autostart.sh" ]; then
                bash "$SCRIPT_DIR/linux/tailscale-autostart.sh"
            else
                echo -e "\033[36m[i] Mengunduh & menjalankan modul Tailscale secara remote...\033[0m"
                curl -fsSL "$BASE_URL/linux/tailscale-autostart.sh" | bash
            fi
            ;;
        0)
            echo -e "\nSampai jumpa!"
            exit 0
            ;;
        *)
            echo -e "\033[31m[!] Pilihan tidak valid.\033[0m"
            sleep 1
            ;;
    esac
done
