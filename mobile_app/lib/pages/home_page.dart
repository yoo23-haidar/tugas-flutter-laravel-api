import 'package:flutter/material.dart'; 
import '../services/auth_service.dart'; 
import '../services/note_service.dart'; 
import '../models/user_model.dart'; 
import '../models/note_model.dart'; 
import 'note_form_page.dart';

class HomePage extends StatefulWidget { 
  @override 
  _HomePageState createState() => _HomePageState(); 
} 

class _HomePageState extends State<HomePage> { 
  User? user; 
  List<Note> notes = [];
  bool isLoadingNotes = true;

  @override 
  void initState() { 
    super.initState(); 
    loadUser(); 
    loadNotes();
  } 

  void loadUser() async { 
    User? localUser = await AuthService.getLocalUser();
    if (localUser != null && mounted) {
      setState(() { user = localUser; });
    }
    
    User? fetchedUser = await AuthService.getUser(); 
    if (fetchedUser != null && mounted) {
      setState(() { user = fetchedUser; }); 
    }
  } 

  void loadNotes() async {
    setState(() { isLoadingNotes = true; });
    List<Note> fetchedNotes = await NoteService.getNotes();
    if (mounted) {
      setState(() { 
        notes = fetchedNotes; 
        isLoadingNotes = false;
      });
    }
  }

  void logout(BuildContext context) async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void navigateToNoteForm({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormPage(note: note)),
    );
    if (result == true) {
      loadNotes(); // Refresh list if a note was created or updated
    }
  }

  void deleteNote(int id) async {
    bool success = await NoteService.deleteNote(id);
    if (success) {
      loadNotes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus catatan")),
      );
    }
  }

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(
        title: Text("Home & Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: user == null 
        ? Center(child: CircularProgressIndicator()) 
        : Column(
            children: [
              Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Profil Anda", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text("Halo, ${user!.name}!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Email: ${user!.email}"),
                      Text("NPM: ${user!.npm ?? '-'}"),
                    ],
                  ),
                ),
              ), 
              Expanded(
                child: isLoadingNotes 
                  ? Center(child: CircularProgressIndicator())
                  : notes.isEmpty 
                    ? Center(child: Text("Belum ada catatan. Tambahkan sekarang!"))
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: ListTile(
                              title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                              onTap: () => navigateToNoteForm(note: note),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Hapus Catatan"),
                                      content: Text("Yakin ingin menghapus '${note.title}'?"),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteNote(note.id);
                                          }, 
                                          child: Text("Hapus", style: TextStyle(color: Colors.red))
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToNoteForm(),
        child: Icon(Icons.add),
        tooltip: 'Tambah Catatan',
      ),
    ); 
  } 
}
