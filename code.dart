import 'dart:collection'; // Import untuk struktur data Queue
import 'dart:io'; // Import untuk input/output terminal

// ===================== Kelas Pulsa =====================
// Kelas untuk merepresentasikan data pulsa
class Pulsa {
  String operator; // Nama operator pulsa (misal: Telkomsel, XL)
  int nominal;     // Nominal pulsa (misal: 10000, 50000)
  int stok;        // Stok pulsa yang tersedia

  // Konstruktor untuk inisialisasi objek Pulsa
  Pulsa(this.operator, this.nominal, this.stok);
}

// ===================== Kelas ManajemenPulsa =====================
// Kelas untuk mengelola stok pulsa, operator, dan log transaksi
class ManajemenPulsa {
  Map<String, Pulsa> daftarPulsa = {}; // Menyimpan data pulsa, key: "operator-nominal"
  Queue<String> riwayatTransaksi = Queue<String>(); // Menyimpan riwayat transaksi (FIFO)
  Set<String> daftarOperator = {}; // Menyimpan daftar operator unik
  List<String> logHarian = []; // Menyimpan log harian transaksi

  // Fungsi untuk menambah stok pulsa
  void tambahStok(String operator, int nominal, int jumlah) {
    String key = '$operator-$nominal'; // Key unik untuk setiap kombinasi operator-nominal
    String log = 'Tambah: $operator $nominal x$jumlah'; // Log harian
    logHarian.add(log); // Simpan log harian

    if (daftarPulsa.containsKey(key)) { // Jika pulsa sudah ada
      daftarPulsa[key]!.stok += jumlah; // Tambah stok
      riwayatTransaksi.add('Menambah stok $jumlah untuk $operator $nominal'); // Log transaksi
    } else { // Jika pulsa belum ada
      daftarPulsa[key] = Pulsa(operator, nominal, jumlah); // Tambah data pulsa baru
      daftarOperator.add(operator); // Tambah operator ke set
      riwayatTransaksi.add('Menambahkan pulsa baru: $operator $nominal sebanyak $jumlah'); // Log transaksi
    }
  }

  // Fungsi untuk menjual pulsa
  void jualPulsa(String operator, int nominal, int jumlah) {
    String key = '$operator-$nominal'; // Key unik
    if (daftarPulsa.containsKey(key)) { // Jika pulsa ditemukan
      if (daftarPulsa[key]!.stok >= jumlah) { // Jika stok cukup
        daftarPulsa[key]!.stok -= jumlah; // Kurangi stok
        riwayatTransaksi.add('Menjual $jumlah dari $operator $nominal'); // Log transaksi
        logHarian.add('Jual: $operator $nominal x$jumlah'); // Log harian
        print('Penjualan berhasil.');
      } else {
        print('Stok tidak mencukupi.'); // Jika stok kurang
      }
    } else {
      print('Pulsa tidak ditemukan.'); // Jika pulsa tidak ditemukan
    }
  }

  // Fungsi untuk menampilkan stok pulsa dan daftar operator
  void tampilkanStokDanOperator() {
    if (daftarPulsa.isEmpty) { // Jika belum ada data pulsa
      print('Belum ada data pulsa.');
    } else {
      print('Stok Pulsa:');
      daftarPulsa.forEach((key, pulsa) {
        print('${pulsa.operator} ${pulsa.nominal} : ${pulsa.stok}');
      });

      print('\nOperator yang tersedia: ${daftarOperator.join(', ')}');
    }
  }

  // Fungsi untuk menampilkan log transaksi dan log harian
  void tampilkanLogTransaksi() {
    if (riwayatTransaksi.isEmpty && logHarian.isEmpty) { // Jika belum ada log
      print('Belum ada log transaksi.');
    } else {
      print('Riwayat Transaksi:');
      for (var transaksi in riwayatTransaksi) {
        print(transaksi);
      }

      print('\nLog Harian:');
      for (var log in logHarian) {
        print(log);
      }
    }
  }
}

// ===================== Fungsi Utama Program =====================
void main() {
  var manajemen = ManajemenPulsa(); // Membuat objek manajemen pulsa

  while (true) { // Loop menu utama
    print('\nMenu:');
    print('1. Tambah Stok Pulsa');
    print('2. Jual Pulsa');
    print('3. Lihat Stok & Operator');
    print('4. Lihat Log Transaksi');
    print('0. Keluar');

    stdout.write('Pilih menu: ');
    String? input = stdin.readLineSync(); // Baca input menu dari user

    switch (input) {
      case '1': // Menu tambah stok pulsa
        stdout.write('Operator: ');
        String? operator = stdin.readLineSync(); // Input operator

        stdout.write('Nominal: ');
        int nominal = int.parse(stdin.readLineSync()!); // Input nominal pulsa

        stdout.write('Jumlah: ');
        int jumlah = int.parse(stdin.readLineSync()!); // Input jumlah stok

        if (operator != null && operator.isNotEmpty) { // Validasi input operator
          manajemen.tambahStok(operator, nominal, jumlah); // Tambah stok pulsa
          print('Stok berhasil ditambahkan.');
        } else {
          print('Operator tidak boleh kosong.');
        }
        break;

      case '2': // Menu jual pulsa
        stdout.write('Operator: ');
        String? operator = stdin.readLineSync(); // Input operator

        stdout.write('Nominal: ');
        int nominal = int.parse(stdin.readLineSync()!); // Input nominal pulsa

        stdout.write('Jumlah: ');
        int jumlah = int.parse(stdin.readLineSync()!); // Input jumlah yang dijual

        if (operator != null && operator.isNotEmpty) { // Validasi input operator
          manajemen.jualPulsa(operator, nominal, jumlah); // Proses penjualan pulsa
        } else {
          print('Operator tidak boleh kosong.');
        }
        break;

      case '3': // Menu lihat stok dan operator
        manajemen.tampilkanStokDanOperator();
        break;

      case '4': // Menu lihat log transaksi
        manajemen.tampilkanLogTransaksi();
        break;

      case '0': // Keluar dari program
        print('Terima kasih.');
        return;

      default: // Jika input tidak valid
        print('Pilihan tidak valid.');
    }
  }
}