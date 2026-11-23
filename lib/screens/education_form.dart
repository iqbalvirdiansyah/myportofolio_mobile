import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Formulir untuk menambahkan riwayat pendidikan (Edukasi) ke portofolio.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Batas panjang teks, mengikuti batas max_length pada model.
  static const int _maxTextLength = 100;

  final List<String> _levels = ['SMA/SMK', 'D3', 'S1', 'S2', 'S3'];

  String _institution = "";
  String _level = "S1"; // default
  String _fieldOfStudy = "";
  DateTime? _startDate;
  DateTime? _endDate;

  // Controller untuk menampilkan tanggal terpilih di kolom tanggal.
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka date picker dan menyimpan tanggal ke state serta controller.
  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  /// Validasi teks wajib: tidak boleh kosong/hanya spasi dan tidak melebihi batas.
  String? _validateRequiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label tidak boleh kosong!";
    }
    if (value.trim().length > _maxTextLength) {
      return "$label maksimal $_maxTextLength karakter!";
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _institution = "";
      _level = "S1";
      _fieldOfStudy = "";
      _startDate = null;
      _endDate = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edukasi berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_institution.trim()}'),
                Text('Jenjang: $_level'),
                Text('Bidang Studi: ${_fieldOfStudy.trim()}'),
                Text('Tanggal Mulai: ${_formatDate(_startDate!)}'),
                Text('Tanggal Selesai: ${_formatDate(_endDate!)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Education Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Warna tema yang sama dengan halaman utama.
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView menjaga semua input dan tombol Simpan tetap
        // dapat digulir saat layar sempit atau papan ketik tampil.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === Institusi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Institusi",
                    hint: "Contoh: Universitas Indonesia",
                  ),
                  maxLength: _maxTextLength,
                  onChanged: (value) => setState(() => _institution = value),
                  validator: (value) =>
                      _validateRequiredText(value, "Institusi"),
                ),
              ),

              // === Jenjang ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration("Jenjang"),
                  initialValue: _level,
                  items: _levels
                      .map(
                        (level) =>
                            DropdownMenuItem(value: level, child: Text(level)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _level = value!),
                ),
              ),

              // === Bidang Studi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Bidang Studi",
                    hint: "Contoh: Ilmu Komputer",
                  ),
                  maxLength: _maxTextLength,
                  onChanged: (value) => setState(() => _fieldOfStudy = value),
                  validator: (value) =>
                      _validateRequiredText(value, "Bidang studi"),
                ),
              ),

              // === Tanggal Mulai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Mulai",
                    hint: "Pilih tanggal",
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (_) {
                    if (_startDate == null) {
                      return "Tanggal mulai wajib dipilih!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Selesai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Selesai",
                    hint: "Pilih tanggal",
                    suffixIcon: const Icon(Icons.event),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (_) {
                    if (_endDate == null) {
                      return "Tanggal selesai wajib dipilih!";
                    }
                    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onPressed: _submit,
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
