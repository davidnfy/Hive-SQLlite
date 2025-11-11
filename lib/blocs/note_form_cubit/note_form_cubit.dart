import 'package:bloc/bloc.dart';
import '../../models/note.dart';

class NoteFormCubit extends Cubit<Note> {
  NoteFormCubit([Note? initialNote]) : super(initialNote ?? Note(title: '', content: '', createdAt: DateTime.now()));

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateContent(String content) {
    emit(state.copyWith(content: content));
  }

  void reset() {
    emit(Note(title: '', content: '', createdAt: DateTime.now()));
  }
}
