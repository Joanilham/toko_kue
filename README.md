# Toko Sahabat

Aplikasi e-commerce sederhana ini dibangun menggunakan Flutter. Aplikasi ini dirancang sebagai contoh implementasi fitur-fitur dasar pada aplikasi mobile, seperti autentikasi pengguna, manajemen data produk, dan proses transaksi. Dan juga aplikasi ini menggunakan database SQLite lokal untuk menyimpan semua data.

## Fitur

- **Autentikasi Pengguna**: Sistem login dan registrasi untuk pengguna baru.
- **Dua Peran Pengguna**:
    - **Admin**: Dapat mengelola (menambah, mengubah, melihat) data barang dan melihat seluruh riwayat transaksi.
    - **Pembeli (Buyer)**: Dapat melihat daftar barang, menambahkan barang ke keranjang, melakukan checkout, dan melihat riwayat transaksi pribadi.
- **Manajemen Barang**: Admin dapat mengelola inventaris produk yang tersedia di toko.
- **Keranjang Belanja**: Pengguna dapat menambahkan dan mengurangi jumlah barang di dalam keranjang.
- **Checkout**: Proses konfirmasi pesanan dengan validasi lokasi GPS. Tombol konfirmasi akan nonaktif jika lokasi tidak dapat diakses.
- **Riwayat Transaksi**: Pengguna dapat melihat riwayat transaksi yang pernah dilakukan.
- **Penyimpanan Lokal**: Menggunakan `sqflite` untuk menyimpan data pengguna, barang, dan transaksi secara lokal di perangkat.

## Teknologi yang Digunakan

- **Framework**: Flutter
- **Bahasa**: Dart
- **Database**: SQLite (`sqflite`)
- **Manajemen State**: `StatefulWidget`
- **Dependensi Utama**:
  - `sqflite`: Untuk interaksi dengan database SQLite.
  - `path_provider`: Untuk mendapatkan path direktori lokal.
  - `geolocator`: Untuk mendapatkan lokasi GPS pengguna.
  - `permission_handler`: Untuk mengelola perizinan lokasi.
  - `intl`: Untuk format mata uang.
  - `crypto`: Untuk hashing password.

## Memulai

1.  **Clone repositori ini:**
    ```bash
    git clone <URL_REPOSITORI_ANDA>
    ```
2.  **Masuk ke direktori proyek:**
    ```bash
    cd "Toko Sahabat"
    ```
3.  **Install dependensi:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```
## Struktur Proyek

```text
lib/
├── auth/
│   ├── login_screen.dart           # UI & logika layar login
│   └── register_screen.dart        # UI & logika layar registrasi
├── db/
│   ├── app_db.dart                 # Inisialisasi & konfigurasi SQLite
│   └── repository.dart             # Operasi CRUD ke database
├── menu/
│   ├── admin_home_screen.dart      # Layar utama untuk admin
│   ├── buyer_home_screen.dart      # Layar utama untuk pembeli
│   ├── edit_item_screen.dart       # Admin tambah/ubah produk
│   └── total_screen.dart           # (opsional) ringkasan/total
├── models/
│   ├── item.dart                   # Model produk
│   ├── txn.dart                    # Model transaksi
│   └── user.dart                   # Model pengguna
├── screen/
│   └── splash_screen.dart          # Layar pembuka aplikasi
├── transactions/
│   ├── checkout_screen.dart        # Proses checkout
│   ├── receipt_screen.dart         # Struk/bukti transaksi
│   ├── transaction_history_screen.dart  # Riwayat transaksi pembeli
│   └── txn_detail_screen.dart      # Detail transaksi tertentu
├── utils/
│   └── format.dart                 # Fungsi utilitas (format mata uang, dll)
└── main.dart                       # Titik masuk aplikasi, routing

pubspec.yaml                        # File konfigurasi Flutter & dependensi
README.md                           # Dokumentasi proyek ini
