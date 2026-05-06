import '../models/note_model.dart';
import 'api_service.dart';

class NoteService {
  static Future<List<Note>> getNotes() async {
    final data = await ApiService.get("notes");
    if (data != null && data is List) {
      return data.map((json) => Note.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> createNote(String title, String content) async {
    final data = await ApiService.authPost("notes", {
      "title": title,
      "content": content,
    });
    return data != null && data['id'] != null;
  }

  static Future<bool> updateNote(int id, String title, String content) async {
    final data = await ApiService.put("notes/$id", {
      "title": title,
      "content": content,
    });
    return data != null && data['id'] != null;
  }

  static Future<bool> deleteNote(int id) async {
    final data = await ApiService.delete("notes/$id");
    return data != null && data['message'] == 'Note deleted successfully';
  }
}
