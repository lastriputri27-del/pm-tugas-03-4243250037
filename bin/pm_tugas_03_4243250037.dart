
import 'dart:io';

// Class untuk menyimpan data mata kuliah
class MataKuliah {
  String nama;
  int sks;
  String nilai;

  MataKuliah(this.nama, this.sks, this.nilai);
}

// 1. Fungsi mengubah nilai huruf menjadi bobot angka
int bobot(String huruf) {
  switch (huruf.toUpperCase()) {
    case 'A':
      return 4;
    case 'B':
      return 3;
    case 'C':
      return 2;
    case 'D':
      return 1;
    case 'E':
      return 0;
    default:
      throw FormatException('Nilai huruf tidak valid!');
  }
}

// 2. Fungsi validasi data mata kuliah
MataKuliah validasiData(String nama, String inputSks, String nilai) {
  int? sks = int.tryParse(inputSks);

  if (sks == null || sks < 1 || sks > 6) {
    throw FormatException(
      'SKS harus berupa angka antara 1 sampai 6!',
    );
  }

  bobot(nilai);

  return MataKuliah(nama, sks, nilai.toUpperCase());
}

// 3. Fungsi menghitung IP menggunakan fold
double hitungIp(List<MataKuliah> data) {
  if (data.isEmpty) {
    return 0.0;
  }

  double totalMutu = data.fold(
    0.0,
    (total, mk) => total + (mk.sks * bobot(mk.nilai)),
  );

  int totalSks = data.fold(
    0,
    (total, mk) => total + mk.sks,
  );

  return totalMutu / totalSks;
}

// 4. Fungsi menentukan predikat IP
String predikat(double ip) {
  if (ip >= 3.50) {
    return 'Dengan Pujian';
  } else if (ip >= 3.00) {
    return 'Sangat Memuaskan';
  } else if (ip >= 2.00) {
    return 'Memuaskan';
  } else {
    return 'Kurang Memuaskan';
  }
}

// 5. Fungsi pembanding nilai untuk pengurutan
int bandingNilai(MataKuliah a, MataKuliah b) {
  return bobot(b.nilai).compareTo(bobot(a.nilai));
}

// 6. Fungsi mencetak KHS dengan named parameter
void cetakKhs(List<MataKuliah> data, {bool urutkan = false}) {
  List<MataKuliah> daftar = [...data];

  if (urutkan) {
    daftar.sort(bandingNilai);
  }

  print('\n========================================================');
  print('                   KARTU HASIL STUDI');
  print('========================================================');

  print(
    '${'Mata Kuliah'.padRight(45)}'
    '${'SKS'.padRight(6)}'
    'Nilai',
  );

  print('--------------------------------------------------------');

  for (var mk in daftar) {
    print(
      '${mk.nama.padRight(45)}'
      '${mk.sks.toString().padRight(6)}'
      '${mk.nilai}',
    );
  }

  // Menghitung total SKS
  int totalSks = data.fold(
    0,
    (total, mk) => total + mk.sks,
  );

  double ip = hitungIp(data);

  print('--------------------------------------------------------');
  print('Total SKS : $totalSks');
  print('IP        : ${ip.toStringAsFixed(2)}');
  print('Predikat  : ${predikat(ip)}');

  // Menampilkan mata kuliah dengan bobot di bawah 2
  print('\nMata Kuliah yang Perlu Ditingkatkan:');

  var perluDitingkatkan = data.where(
    (mk) => bobot(mk.nilai) < 2,
  );

  if (perluDitingkatkan.isEmpty) {
    print('Tidak ada.');
  } else {
    for (var mk in perluDitingkatkan) {
      print('- ${mk.nama} (Nilai ${mk.nilai})');
    }
  }

  print('========================================================');
}

// Fungsi utama program
void main() {
  List<MataKuliah> daftarMataKuliah = [];

  print('========================================================');
  print('                KALKULATOR IP SEMESTER');
  print('========================================================');

  // Perulangan input mata kuliah
  while (true) {
    stdout.write('\nNama Mata Kuliah (kosong untuk selesai): ');
    String nama = stdin.readLineSync()?.trim() ?? '';

    if (nama.isEmpty) {
      break;
    }

    stdout.write('Jumlah SKS: ');
    String sks = stdin.readLineSync()?.trim() ?? '';

    stdout.write('Nilai Huruf (A/B/C/D/E): ');
    String nilai = stdin.readLineSync()?.trim() ?? '';

    try {
      MataKuliah mk = validasiData(nama, sks, nilai);

      daftarMataKuliah.add(mk);

      print('Data mata kuliah berhasil ditambahkan!');
    } on FormatException catch (e) {
      print('Input tidak valid: ${e.message}');
      print('Data mata kuliah tidak ditambahkan.');
    }
  }

  // Pilihan pengurutan KHS
  stdout.write('\nUrutkan nilai tertinggi terlebih dahulu? (y/n): ');
  String pilihan =
      stdin.readLineSync()?.trim().toLowerCase() ?? 'n';

  cetakKhs(
    daftarMataKuliah,
    urutkan: pilihan == 'y',
  );
}
