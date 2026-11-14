# myportofolio_mobile

Aplikasi mobile Flutter untuk portofolio pribadi **Iqbal Virdiansyah** (NPM 2506656816, PBP C). Proyek ini merupakan perluasan ekosistem portofolio ke ranah mobile dan dikembangkan bertahap setiap minggu mengikuti Tutorial & Individual Assignment PBP.

## Setup

```bash
flutter pub get
flutter run
flutter analyze
```

## Progres Mingguan

- **Tugas 7**: halaman menu utama (`lib/menu.dart`) dengan 3 `InfoCard` (NPM, Name, Class) dan 3 `ItemCard` berwarna unik (Lihat Proyek - biru, Tambah Proyek - hijau, Logout - merah) yang menampilkan `SnackBar` saat ditekan. Warna ditentukan lewat atribut `color` pada model `ItemHomepage`, sehingga tidak perlu percabangan `if-else`.

## AI Disclosure

- **Tools**: Claude Code (model Claude Sonnet).
- **Strategi prompting**: saya memberikan teks lengkap instruksi tugas, lalu meminta AI mengeksplorasi kode yang ada, menyusun rencana, dan menerapkannya dalam commit bertahap.
- **Bagian yang dibantu AI**: penambahan atribut `color` pada `ItemHomepage`, pewarnaan `ItemCard`, serta penyusunan draf jawaban pertanyaan reflektif dan README ini.
- **Keterbatasan & perbaikan manual**: AI tidak mengetahui identitas saya, sehingga NPM, nama, dan kelas saya berikan sendiri. Hasil akhir diverifikasi dengan `flutter analyze` (No issues found) dan saya meninjau jawaban reflektif agar sesuai pemahaman saya.

### Tugas 7

1. **Widget tree** adalah struktur hierarki seluruh widget yang membentuk UI Flutter. Setiap widget (parent) dapat memiliki satu atau banyak widget anak (child) yang ditentukan lewat properti seperti `child`/`children`. Parent memberikan constraint (ukuran) dan konteks (mis. tema) ke child, sedangkan child menentukan ukurannya dalam batas constraint tersebut dan melaporkannya ke parent. Perubahan pada suatu node menyebabkan subtree-nya dibangun ulang.

2. Widget yang digunakan:
   - `MaterialApp`: root aplikasi yang menyediakan tema, navigasi, dan konfigurasi Material.
   - `Scaffold`: kerangka dasar halaman (AppBar, body, SnackBar).
   - `AppBar`: bar judul di bagian atas halaman.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column`: menyusun widget secara vertikal.
   - `Row`: menyusun widget secara horizontal (3 `InfoCard`).
   - `Center`: memusatkan child.
   - `SizedBox`: pemberi jarak/ukuran tetap.
   - `GridView.count`: menampilkan tombol menu dalam kisi 3 kolom.
   - `Card`: kartu dengan bayangan untuk `InfoCard`.
   - `Container`: pembungkus dengan lebar, padding, dan dekorasi.
   - `Material`: permukaan Material berwarna dan berborder radius untuk `ItemCard`.
   - `InkWell`: area yang dapat ditekan dengan efek ripple.
   - `Icon`: menampilkan ikon.
   - `SnackBar` dan `ScaffoldMessenger`: menampilkan pesan singkat di bagian bawah layar saat tombol ditekan.
   - `InfoCard` dan `ItemCard` (custom) serta `MyApp` dan `MyHomePage` (`StatelessWidget`).

3. `MaterialApp` membungkus aplikasi dengan fitur Material Design: tema (`ThemeData`), `home`/routes untuk navigasi, `Navigator`, lokalisasi, dan `ScaffoldMessenger`. Widget ini dijadikan root karena hampir semua widget Material (Scaffold, AppBar, SnackBar, `Theme.of(context)`) membutuhkan ancestor tersebut agar berfungsi dan tampil konsisten.

4. `StatelessWidget` tidak memiliki state yang berubah; tampilannya hanya bergantung pada konfigurasi/properti yang diberikan. `StatefulWidget` memiliki objek `State` yang dapat berubah dan memanggil `setState()` untuk membangun ulang UI. Gunakan `StatelessWidget` untuk UI statis (seperti halaman menu ini), dan `StatefulWidget` bila UI perlu berubah terhadap interaksi atau waktu (input form, counter, animasi, data async).

5. `BuildContext` adalah handle yang merepresentasikan lokasi sebuah widget di widget tree. Dengan context, widget dapat mencari ancestor/data di atasnya, misalnya `Theme.of(context)`, `MediaQuery.of(context)`, dan `ScaffoldMessenger.of(context)`. Di metode `build(BuildContext context)`, context diberikan oleh framework dan dipakai untuk mengakses tema, ukuran layar, atau menampilkan SnackBar sesuai posisi widget tersebut.

6. **Hot reload** menyuntikkan kode yang berubah ke Dart VM yang sedang berjalan dan membangun ulang widget tree tanpa menghilangkan state aplikasi. **Hot restart** memuat ulang seluruh kode dan mengatur ulang state ke awal, namun tidak perlu build ulang dari nol. Hot reload tidak cukup untuk perubahan `main()`, nilai variabel global/`static` dan initializer state, perubahan enum/jenis class, atau perubahan struktur generik; gunakan hot restart. Untuk perubahan native (`pubspec.yaml` dependensi/asset baru, konfigurasi Android/iOS, plugin, permission), perlu full restart (stop lalu `flutter run` ulang).
