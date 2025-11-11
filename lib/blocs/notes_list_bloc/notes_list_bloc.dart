import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/notes_repository.dart';
import '../../models/note.dart';

part 'notes_list_event.dart';
part 'notes_list_state.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final NotesRepository notesRepository;

  NotesListBloc(this.notesRepository) : super(NotesListLoading()) {
    on<LoadNotes>((event, emit) {
      final notes = notesRepository.getAllNotes();
      emit(NotesListLoaded(notes));
    });
  }
}
