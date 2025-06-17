import 'dart:collection';
import 'dart:io';

class Pulsa {
  String operator;
  int nominal;
  int stok;

  Pulsa(this.operator, this.nominal, this.stok);
}

class ManajemenPulsa {
  Map<String, Pulsa> daftarPulsa = {};
  Queue<String> riwayatTransaksi = Queue<String>();
  Set<String> daftarOperator = {};
  List<String> logHarian = [];

  void tambahStok(String operator, int nominal, int jumlah) {
    String key = '$operator-$nominal';
    String log = 'Tambah: $operator $nominal x$jumlah';
    logHarian.add(log);

    if (daftarPulsa.containsKey(key)) {
      daftarPulsa[key]!.stok += jumlah;
      riwayatTransaksi.add('Menambah stok $jumlah untuk $operator $nominal');
    } else {
      daftarPulsa[key] = Pulsa(operator, nominal, jumlah);
      daftarOperator.add(operator);
      riwayatTransaksi.add('Menambahkan pulsa baru: $operator $nominal sebanyak $jumlah');
    }
  }

  void jualPulsa(String operator, int nominal, int jumlah) {
    String key = '$operator-$nominal';
    if (daftarPulsa.containsKey(key)) {
      if (daftarPulsa[key]!.stok >= jumlah) {
        daftarPulsa[key]!.stok -= jumlah;
        riwayatTransaksi.add('Menjual $jumlah dari $operator $nominal');
        logHarian.add('Jual: $operator $nominal x$jumlah');
        print('Penjualan berhasil.');
      } else {
        print('Stok tidak mencukupi.');
      }
    } else {
      print('Pulsa tidak ditemukan.');
    }
  }

  void tampilkanStokDanOperator() {
    if (daftarPulsa.isEmpty) {
      print('Belum ada data pulsa.');
    } else {
      print('Stok Pulsa:');
      daftarPulsa.forEach((key, pulsa) {
        print('${pulsa.operator} ${pulsa.nominal} : ${pulsa.stok}');
      });

      print('\nOperator yang tersedia: ${daftarOperator.join(', ')}');
    }
  }

  void tampilkanLogTransaksi() {
    if (riwayatTransaksi.isEmpty && logHarian.isEmpty) {
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

void main() {
  var manajemen = ManajemenPulsa();

  while (true) {
    print('\nMenu:');
    print('1. Tambah Stok Pulsa');
    print('2. Jual Pulsa');
    print('3. Lihat Stok & Operator');
    print('4. Lihat Log Transaksi');
    print('0. Keluar');

    stdout.write('Pilih menu: ');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        stdout.write('Operator: ');
        String? operator = stdin.readLineSync();

        stdout.write('Nominal: ');
        int nominal = int.parse(stdin.readLineSync()!);

        stdout.write('Jumlah: ');
        int jumlah = int.parse(stdin.readLineSync()!);

        if (operator != null && operator.isNotEmpty) {
          manajemen.tambahStok(operator, nominal, jumlah);
          print('Stok berhasil ditambahkan.');
        } else {
          print('Operator tidak boleh kosong.');
        }
        break;

      case '2':
        stdout.write('Operator: ');
        String? operator = stdin.readLineSync();

        stdout.write('Nominal: ');
        int nominal = int.parse(stdin.readLineSync()!);

        stdout.write('Jumlah: ');
        int jumlah = int.parse(stdin.readLineSync()!);

        if (operator != null && operator.isNotEmpty) {
          manajemen.jualPulsa(operator, nominal, jumlah);
        } else {
          print('Operator tidak boleh kosong.');
        }
        break;

      case '3':
        manajemen.tampilkanStokDanOperator();
        break;

      case '4':
        manajemen.tampilkanLogTransaksi();
        break;

      case '0':
        print('Terima kasih.');
        return;

      default:
        print('Pilihan tidak valid.');
    }
  }
}

