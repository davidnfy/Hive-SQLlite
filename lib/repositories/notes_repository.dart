import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  final Box notesBox;

  NotesRepository(this.notesBox);

  Future<void> saveNote(Note note) async {
    int id;
    if (note.id != null) {
      id = note.id!;
    } else {
      final notes = getAllNotes();
      final maxId = notes.isEmpty ? 0 : notes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b);
      id = maxId + 1;
    }
    final noteWithId = note.copyWith(id: id);
    await notesBox.put(id, noteWithId.toMap());
  }

  List<Note> getAllNotes() {
    return notesBox.values
        .map((e) => Note.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteNote(int id) async {
    await notesBox.delete(id);
  }
}
