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
- **Tutorial 09**: struktur `lib/screens/` dan `lib/widgets/`, `LeftDrawer` (Home, Add Project), serta formulir Tambah Proyek.
- **Tugas 8**: formulir Tambah Edukasi (`lib/screens/education_form.dart`) dengan input Institusi, Jenjang (dropdown), Bidang Studi, Tanggal Mulai, dan Tanggal Selesai (`showDatePicker()`). Setiap input divalidasi (wajib diisi, tidak boleh hanya spasi, maksimal 100 karakter, tanggal selesai tidak boleh sebelum tanggal mulai), lalu ringkasan isian ditampilkan dalam `AlertDialog`. Formulir dapat dibuka dari kartu **Tambah Edukasi** di halaman utama (`Navigator.push()`) dan dari opsi **Add Education** di drawer.

## AI Disclosure

- **Tools**: Claude Code (model Claude Sonnet).
- **Strategi prompting**: saya memberikan teks lengkap instruksi tugas, lalu meminta AI mengeksplorasi kode yang ada, menyusun rencana, dan menerapkannya dalam commit bertahap.
- **Bagian yang dibantu AI**: penambahan atribut `color` pada `ItemHomepage`, pewarnaan `ItemCard`, serta penyusunan draf jawaban pertanyaan reflektif dan README ini.
- **Keterbatasan & perbaikan manual**: AI tidak mengetahui identitas saya, sehingga NPM, nama, dan kelas saya berikan sendiri. Hasil akhir diverifikasi dengan `flutter analyze` (No issues found) dan saya meninjau jawaban reflektif agar sesuai pemahaman saya.
- **Tugas 8**: dengan Claude Code (model Claude Opus), saya meminta AI membaca kode Tutorial 09 terlebih dahulu dan menyusun rencana yang tidak berlebihan sebelum menulis kode, serta tidak melakukan commit sebelum saya meninjau hasilnya. AI membantu membuat `education_form.dart`, menambahkan kartu dan opsi drawer, menguji alur di Chrome pada lebar layar ponsel, dan menyusun draf jawaban reflektif. Keterbatasan: AI tidak mengetahui model Edukasi pada proyek web saya, sehingga saya yang memilih bagian Edukasi dan field serta batas validasinya perlu saya sesuaikan dengan model tersebut. Saya meninjau kode dan jawaban sebelum commit.

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

### Tugas 8

1. `Navigator.push()` menambahkan halaman baru di atas tumpukan (*stack*) rute, sehingga halaman sebelumnya tetap ada dan pengguna bisa kembali. `Navigator.pushReplacement()` mengganti halaman yang sedang tampil dengan halaman baru, sehingga halaman lama dihapus dari stack dan tombol kembali tidak membawa pengguna ke sana. `Navigator.pop()` menghapus halaman teratas dari stack dan kembali ke halaman di bawahnya; di formulir ini `pop()` juga dipakai untuk menutup `AlertDialog`. Kartu aksi **Tambah Edukasi** memakai `Navigator.push()`, sehingga setelah formulir terbuka pengguna dapat kembali ke halaman utama dengan tombol kembali bawaan perangkat (atau tombol back browser saat dijalankan di Chrome). Opsi **Home** di drawer memakai `Navigator.pushReplacement()` dengan `MyHomePage()`, sehingga halaman formulir diganti oleh halaman utama dan stack tidak terus bertambah setiap kali pengguna berpindah lewat drawer.

2. `Scaffold` memberi kerangka yang sama untuk setiap halaman: `appBar` di atas, `drawer` di samping, dan `body` di tengah. `AppBar` menampilkan judul halaman di posisi yang sama, sedangkan `Drawer` dibuat sekali sebagai widget `LeftDrawer` lalu dipasang di halaman utama, formulir proyek, dan formulir edukasi. Dengan begitu menu navigasi selalu sama dan perubahan cukup dilakukan di satu berkas. Contoh warna tema: `ColorScheme.fromSeed(seedColor: Colors.indigo)` di `main.dart` diambil lewat `Theme.of(context).colorScheme.primary` sebagai warna latar `AppBar` di halaman utama, lalu dipakai lagi untuk `AppBar` dan tombol **Simpan** di halaman formulir edukasi, sehingga keduanya tampil dengan warna indigo yang sama.

3. Formulir disusun sebagai satu kolom vertikal (`Column` dengan `CrossAxisAlignment.stretch`) agar setiap input memakai lebar penuh, mudah dibaca dari atas ke bawah, dan tetap rapi di layar ponsel yang sempit. `Padding` di sekitar setiap input memberi jarak yang konsisten sehingga kolom dan pesan kesalahannya tidak saling menempel. `SingleChildScrollView` membungkus seluruh kolom sehingga ketika ruang vertikal berkurang, misalnya saat papan ketik tampil atau ketika beberapa pesan kesalahan muncul sekaligus, isi formulir dapat digulir dan tidak terjadi *overflow*. Dengan begitu semua input dan tombol **Simpan** tetap dapat dijangkau.

4. `GlobalKey<FormState>` adalah kunci yang menghubungkan tombol **Simpan** dengan state widget `Form`, sehingga `_formKey.currentState` dapat diakses dari luar kolom input. Setiap `TextFormField` memiliki `validator` yang mengembalikan pesan kesalahan jika nilainya tidak valid atau `null` jika valid. Saat **Simpan** ditekan, `validate()` menjalankan semua validator, menampilkan pesan kesalahan di bawah kolom yang bermasalah, dan mengembalikan `true` hanya jika semuanya valid; dialog ringkasan hanya ditampilkan jika hasilnya `true`. Contoh nilai yang ditolak adalah Institusi yang hanya berisi spasi (`"   "`), karena validator memeriksa `value.trim().isEmpty`. Jenis input atau papan ketik tidak cukup karena hanya mengatur cara pengguna mengetik, bukan isi yang dikirim: keyboard teks tetap bisa menerima spasi saja atau teks yang terlalu panjang, dan `showDatePicker()` memastikan formatnya tanggal tetapi tidak mencegah Tanggal Selesai yang lebih awal daripada Tanggal Mulai. Aturan tersebut harus dicek oleh validator.
