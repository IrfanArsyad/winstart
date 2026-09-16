# WinStart - System Setup & Automation Hub

Kumpulan script dan aplikasi CLI terminal modular untuk otomatisasi konfigurasi sistem (Windows & Linux).

## Struktur Repositori

```text
.
├── start.ps1                  # Master Menu Launcher (Windows PowerShell)
├── start.sh                   # Master Menu Launcher (Linux Bash)
├── windows/
│   └── tailscale-autostart.ps1 # Modul Tailscale Manager & Auto-Start
├── linux/
│   └── tailscale-autostart.sh  # Modul Tailscale Manager & Auto-Start
└── README.md
```

---

## Cara Penggunaan

### 1. Eksekusi Remote (Tanpa Clone Repositori)

Jalankan langsung melalui terminal tanpa perlu mengunduh repositori terlebih dahulu:

#### Windows (Buka PowerShell sebagai Administrator)
- **Menu Utama (Hub)**:
  ```powershell
  irm https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/start.ps1 | iex
  ```
- **Pasang Tailscale Auto-Start Langsung (Otomatis)**:
  ```powershell
  irm https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/windows/tailscale-autostart.ps1 | iex
  ```

#### Linux (Terminal dengan Sudo / Root)
- **Menu Utama (Hub)**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/start.sh | bash
  ```
- **Pasang Tailscale Auto-Start Langsung (Otomatis)**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/linux/tailscale-autostart.sh | bash -s -- --auto
  ```

---

### 2. Eksekusi Lokal (Clone Repositori)

Unduh repositori dan jalankan script secara lokal:

```bash
git clone https://github.com/USERNAME/REPOSITORY.git winstart
cd winstart
```

#### Windows (PowerShell Administrator)
- **Jalankan Menu Utama**:
  ```powershell
  .\start.ps1
  ```
- **Jalankan Modul Tailscale Interaktif**:
  ```powershell
  .\windows\tailscale-autostart.ps1
  ```
- **Jalankan Tailscale Auto-Setup Langsung (Non-Interaktif)**:
  ```powershell
  .\windows\tailscale-autostart.ps1 -AutoSetup
  ```

#### Linux
- **Beri Izin Eksekusi & Jalankan Menu Utama**:
  ```bash
  chmod +x start.sh linux/*.sh
  ./start.sh
  ```
- **Jalankan Tailscale Auto-Setup Langsung**:
  ```bash
  ./linux/tailscale-autostart.sh --auto
  ```

---

## Verifikasi Hasil Setup

### Windows
1. **Status Windows Service**:
   ```powershell
   Get-Service Tailscale
   ```
   *Memastikan Status = `Running` dan StartType = `Automatic`.*

2. **Status Koneksi Tailscale**:
   ```powershell
   tailscale status
   ```

### Linux
1. **Status Service systemd**:
   ```bash
   systemctl status tailscaled
   ```
2. **Status Koneksi Tailscale**:
   ```bash
   tailscale status
   ```

---

## Menambahkan Modul Baru di Masa Depan

Repositori ini didesain secara modular. Untuk menambah script/fitur baru nanti:
1. Simpan script PowerShell baru di folder `windows/` (atau script Bash di `linux/`).
2. Tambahkan opsi pilihan baru pada menu `start.ps1` dan `start.sh`.

---

## Catatan Keamanan

Penggunaan remote execution (`irm ... | iex` / `curl ... | bash`) akan mengeksekusi script secara langsung. Pastikan Anda hanya menggunakan URL repositori yang Anda kontrol dan percayai.
