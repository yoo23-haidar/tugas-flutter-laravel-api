import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;

  NoteFormPage({this.note});

  @override
  _NoteFormPageState createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final content = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      title.text = widget.note!.title;
      content.text = widget.note!.content;
    }
  }

  void saveNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() { isLoading = true; });
      bool success;
      if (widget.note == null) {
        success = await NoteService.createNote(title.text, content.text);
      } else {
        success = await NoteService.updateNote(widget.note!.id, title.text, content.text);
      }
      setState(() { isLoading = false; });

      if (success) {
        Navigator.pop(context, true); // Return true to signal refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan catatan")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Catatan" : "Tambah Catatan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: InputDecoration(labelText: "Judul", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: content,
                decoration: InputDecoration(labelText: "Konten", border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Konten wajib diisi' : null,
              ),
              SizedBox(height: 24),
              isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveNote,
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
