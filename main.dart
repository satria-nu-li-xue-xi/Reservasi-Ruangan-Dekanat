import 'dart:io';
import 'package:intl/intl.dart';

List<Ruang> ruangan = [
  Ruang(1.1, 'Kelas', false),
  Ruang(1.2, 'Kelas', false),
  Ruang(1.3, 'Kelas', false),
  Ruang(1.4, 'Kelas', false),
  Ruang(2.1, 'Kelas', false),
  Ruang(2.2, 'Kelas', false),
  Ruang(2.3, 'Kelas', false),
  Ruang(2.4, 'Kelas', false),
  Ruang(2.5, 'Kelas', false),
  Ruang(3.1, 'Kelas', false),
  Ruang(3.2, 'Kelas', false),
  Ruang(1, 'Laboratorium', false),
  Ruang(2, 'Laboratorium', false),
];

List<Reservasi> reservasi = [];

class Ruang{
  final num nomorRuang;
  final String tipeRuang;
  bool tlahDiReservasi;

  Ruang(this.nomorRuang, this.tipeRuang, this.tlahDiReservasi);
}

class Reservasi{
  final num nomorRuangReservasi;
  final String reservator;
  final DateTime waktuReservasi;
  final DateTime waktuBerakhir;
  final String password;

  Reservasi(this.nomorRuangReservasi, this.reservator, this.waktuReservasi, this.waktuBerakhir, this.password);
}
void main(){
  bool continueLoop = true;

  while(continueLoop){
    print('Reservasi Dekanat FMIPA');
    print('=======================');
    print('Selamat Datang di Reservasi Dekanat FMIPA!\n');
        print('1. Cek Status Ruangan Dekanat');
        print('2. Reservasi Ruangan Dekanat FMIPA Udayana');
        print('3. Batalkan Reservasi Ruangan');
        print('4. Keluar');
          stdout.write('\nApa yang Hendak Anda Lakukan? Masukkan (1-4); ');
          int opsi = int.parse(stdin.readLineSync()!);

    switch(opsi){
      case 1:
        print('\nSelamat Datang di Menu Cek Status Ruangan Dekanat');
        print('===================================================');
          cekStatusRuangan();
          break;
      case 2:
        print('\nSelamat Datang di Menu Reservasi Ruangan Dekanat!');
          lihatDaftarRuangan();
          stdout.write('Masukkan Nomor Ruangan yang Hendak Anda Reservasi: ');
          num nomorRuang = num.parse(stdin.readLineSync()!);
          stdout.write('Masukkan Nama Reservator: ');
          String reservator = stdin.readLineSync()!;
          stdout.write('Masukkan Kata Sandi: ');
          String password = stdin.readLineSync()!;
          DateTime waktuReservasi = inputWaktuReservasi();
          DateTime waktuBerakhir = inputWaktuBerakhir();
          reservasiRuang(nomorRuang, reservator, waktuReservasi, waktuBerakhir, password);
          break;
      case 3:
        print('\nSelamat Datang di Menu Pembatalan Reservasi Ruangan Dekanat!');
          stdout.write('Masukkan Nomor Ruangan yang Hendak Anda Batalkan Reservasinya: ');
          num nomorRuang = num.parse(stdin.readLineSync()!);
          stdout.write('Masukkan Kata Sandi: ');
          String password = stdin.readLineSync()!;
          batalkanReservasi(nomorRuang, password);
          break;
      case 4:
        print('\nTerima Kasih Telah Menggunakan Jasa Kami, Semoga Hari Anda Menyenangkan!');
        continueLoop = false;
          break;
      default:
        print('\nMaaf Pilihan Anda Tidak Tersedia.\n');
    }
  }
}

DateTime inputWaktuReservasi(){
  stdout.write('Masukkan Tanggal (yyyy-MM-dd): ');
  String tanggal = stdin.readLineSync()!;
  stdout.write('Masukkan Waktu Reservasi (HH:mm:ss): ');
  String waktu = stdin.readLineSync()!;
  String inputWaktuReservasi = '${tanggal}T${waktu}';
  DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");
  return format.parse(inputWaktuReservasi);
}

DateTime inputWaktuBerakhir(){
  stdout.write('Masukkan Waktu Berakhir (HH:mm:ss): ');
  String waktu = stdin.readLineSync()!;
  String inputWaktuBerakhir = '$waktu';
  DateFormat format = DateFormat("HH:mm:ss");
  return format.parse(inputWaktuBerakhir);
}

void lihatDaftarRuangan(){
  print('Daftar Ruangan: ');
  for (var ruang in ruangan){
    print('${ruang.tipeRuang} ${ruang.nomorRuang}');
  }
}

void cekStatusRuangan(){
  print('Daftar Ruangan Dekanat FMIPA dan Status Reservasinya: ');
  for (var ruang in ruangan){
    String status = ruang.tlahDiReservasi ? 'Telah Direservasi' : 'Belum Direservasi';
    print('${ruang.tipeRuang} ${ruang.nomorRuang}, Status: $status');
  }
  print('\n');
}

void reservasiRuang(num nomorRuangReservasi, String reservator, DateTime waktuReservasi, DateTime waktuBerakhir, String password){
  Ruang ruangDefault = Ruang(-1, 'Default', true);
  Ruang ruang = ruangan.firstWhere((ruang) => ruang.nomorRuang == nomorRuangReservasi && !ruang.tlahDiReservasi, orElse: () => ruangDefault);
  if (ruang != -1) {
    ruang.tlahDiReservasi = true;
    reservasi.add(Reservasi(nomorRuangReservasi, reservator, waktuReservasi, waktuBerakhir, password));
    print('Ruangan Berhasil di-Reservasi!');
  } else {
    print('Ruangan Tidak Tersedia, Mohon Memilih Ruangan Lain.');
  }
}

void batalkanReservasi(num nomorRuangReservasi, String password){
  Reservasi reservasiDefault = Reservasi(-1, 'Default', DateTime.now(), DateTime.now(), 'defaultPassword');
  Reservasi booking = reservasi.firstWhere((booking) => booking.nomorRuangReservasi == nomorRuangReservasi && booking.password == password, orElse: () => reservasiDefault);
  if (booking.nomorRuangReservasi != -1){
    Ruang ruangDefault = Ruang(-1, 'Default', true);
    Ruang ruang = ruangan.firstWhere((ruang) => ruang.nomorRuang == nomorRuangReservasi, orElse: () => ruangDefault);
    if (ruang != -1){
      ruang.tlahDiReservasi = false;
      reservasi.remove(booking);
      print('Reservasi Anda Berhasil Dibatalkan.');
    }
  } else {
    print('Reservasi Tidak Ditemukan.');
  }
}
