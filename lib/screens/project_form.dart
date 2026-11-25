import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Field mengikuti ProjectSerializer pada backend Django.
  String _title = "";
  String _role = "";
  String _shortDescription = "";
  String _fullDescription = "";
  String _techStack = "";
  String _projectUrl = "";
  String _projectImageUrl = "";
  bool _isSubmitting = false;

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label tidak boleh kosong!";
    }
    return null;
  }

  /// Validasi URL opsional: boleh kosong, tetapi bila diisi harus http(s).
  String? _validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return "Format URL tidak valid!";
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final token = context.read<AuthState>().token!;
    final newProject = Project(
      title: _title.trim(),
      role: _role.trim(),
      shortDescription: _shortDescription.trim(),
      fullDescription: _fullDescription.trim(),
      techStack: _techStack.trim(),
      link: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Proyek berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Title: ${created.title}'),
                  Text('Role: ${created.role}'),
                  Text('Tech Stack: ${created.techStack}'),
                  Text('Project URL: ${created.link}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      _formKey.currentState?.reset();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token tidak valid: logout lalu minta login ulang.
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi berakhir, silakan login ulang.')),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan proyek (status ${e.statusCode}).'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _textField({
    required String label,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                label: "Title",
                onChanged: (value) => _title = value,
                validator: (value) => _validateRequired(value, "Title"),
              ),
              _textField(
                label: "Role",
                onChanged: (value) => _role = value,
                validator: (value) => _validateRequired(value, "Role"),
              ),
              _textField(
                label: "Short Description",
                onChanged: (value) => _shortDescription = value,
                validator: (value) {
                  final error = _validateRequired(value, "Short description");
                  if (error != null) return error;
                  if (value!.trim().length > 300) {
                    return "Short description maksimal 300 karakter!";
                  }
                  return null;
                },
              ),
              _textField(
                label: "Full Description",
                maxLines: 5,
                onChanged: (value) => _fullDescription = value,
                validator: (value) =>
                    _validateRequired(value, "Full description"),
              ),
              _textField(
                label: "Tech Stack",
                onChanged: (value) => _techStack = value,
                validator: (value) => _validateRequired(value, "Tech stack"),
              ),
              _textField(
                label: "Project URL (Optional)",
                onChanged: (value) => _projectUrl = value,
                validator: _validateOptionalUrl,
              ),
              _textField(
                label: "Project Image URL (Optional)",
                onChanged: (value) => _projectImageUrl = value,
                validator: _validateOptionalUrl,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
