import 'package:flutter/material.dart';
import 'package:myplan_app/main.dart';

class AddEditPage extends StatefulWidget {
  final Map<String, dynamic>? planData; // Jika null = Mode Tambah, Jika ada = Mode Edit

  const AddEditPage({super.key, this.planData});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _savedController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.planData != null) {
      _titleController.text = widget.planData!['title'];
      _targetController.text = widget.planData!['target_amount'].toString();
      _savedController.text = widget.planData!['saved_amount'].toString();
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = supabase.auth.currentUser;
    final title = _titleController.text;
    final target = int.parse(_targetController.text);
    final saved = int.parse(_savedController.text);

    try {
      if (widget.planData == null) {
        // --- CREATE (Tambah Baru) ---
        await supabase.from('plans').insert({
          'user_id': user!.id,
          'title': title,
          'target_amount': target,
          'saved_amount': saved,
        });
      } else {
        // --- UPDATE (Edit Data) ---
        await supabase.from('plans').update({
          'title': title,
          'target_amount': target,
          'saved_amount': saved,
        }).eq('id', widget.planData!['id']);
      }
      
      if (mounted) Navigator.pop(context); // Kembali ke Home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.planData != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Rencana' : 'Tambah Rencana Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Barang/Impian'),
                validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(labelText: 'Target Harga (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _savedController,
                decoration: const InputDecoration(labelText: 'Uang Terkumpul Saat Ini (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveData,
                child: _isLoading 
                  ? const CircularProgressIndicator() 
                  : Text(isEditing ? 'Update Rencana' : 'Simpan Rencana'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}