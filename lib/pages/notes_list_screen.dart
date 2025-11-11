import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../repositories/notes_repository.dart';
import 'note_form_screen.dart';

class NotesListScreen extends StatelessWidget {
  final NotesRepository repository;
  
  const NotesListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) {
          if (state is NotesListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesListLoaded) {
            final notes = state.notes;
            
            if (notes.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada catatan.\nTekan tombol + untuk menambah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      note.title.isEmpty ? '(Tanpa Judul)' : note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content.isEmpty ? '(Kosong)' : note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Konfirmasi hapus
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hapus Catatan'),
                            content: const Text('Yakin ingin menghapus catatan ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirm == true && note.id != null) {
                          await repository.deleteNote(note.id!);
                          if (context.mounted) {
                            BlocProvider.of<NotesListBloc>(context).add(LoadNotes());
                          }
                        }
                      },
                    ),
                    onTap: () async {
                      // Navigasi ke edit note
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => NoteFormCubit(note),
                            child: NoteFormScreen(repository: repository),
                          ),
                        ),
                      );
                      
                      // Reload notes jika ada perubahan
                      if (result == true && context.mounted) {
                        BlocProvider.of<NotesListBloc>(context).add(LoadNotes());
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Terjadi kesalahan'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke tambah note baru
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => NoteFormCubit(),
                child: NoteFormScreen(repository: repository),
              ),
            ),
          );
          
          // Reload notes jika ada penambahan
          if (result == true && context.mounted) {
            BlocProvider.of<NotesListBloc>(context).add(LoadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}