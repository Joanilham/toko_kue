# Toko Sahabat

Toko Sahabat adalah aplikasi e-commerce sederhana yang dibangun menggunakan Flutter. Aplikasi ini dirancang sebagai contoh implementasi fitur-fitur dasar pada aplikasi mobile, seperti autentikasi pengguna, manajemen data produk, dan proses transaksi. Aplikasi ini menggunakan database SQLite lokal untuk menyimpan semua data.

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
lib/
├── auth/
│   ├── login_screen.dart      # UI dan logika untuk layar login pengguna.
│   └── register_screen.dart   # UI dan logika untuk layar registrasi pengguna baru.
│
├── db/
│   ├── app_db.dart            # Inisialisasi dan konfigurasi database SQLite.
│   └── repository.dart        # Logika untuk operasi CRUD (Create, Read, Update, Delete) ke database.
│
├── menu/
│   ├── admin_home_screen.dart # Layar utama untuk admin, menampilkan menu manajemen.
│   ├── buyer_home_screen.dart # Layar utama untuk pembeli, menampilkan daftar produk.
│   ├── edit_item_screen.dart  # Layar untuk admin menambah atau mengubah data produk.
│   └── total_screen.dart      # (Kemungkinan) Layar untuk menampilkan total atau ringkasan.
│
├── models/
│   ├── item.dart              # Model data untuk merepresentasikan sebuah produk/item.
│   ├── txn.dart               # Model data untuk merepresentasikan sebuah transaksi.
│   └── user.dart              # Model data untuk merepresentasikan seorang pengguna.
│
├── screen/
│   └── splash_screen.dart     # Layar pembuka (splash screen) yang muncul saat aplikasi pertama kali dibuka.
│
├── transactions/
│   ├── checkout_screen.dart   # Layar proses checkout dan konfirmasi pembayaran.
│   ├── receipt_screen.dart    # Menampilkan struk atau bukti transaksi setelah checkout.
│   ├── transaction_history_screen.dart # Menampilkan riwayat transaksi khusus untuk pembeli.
│   └── txn_detail_screen.dart # Menampilkan detail dari satu transaksi tertentu.
│
├── utils/
│   └── format.dart            # Fungsi utilitas, seperti untuk memformat angka menjadi format mata uang.
│
└── main.dart                  # Titik masuk utama aplikasi Flutter, menginisialisasi aplikasi dan routing awal.