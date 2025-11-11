import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../repositories/notes_repository.dart';

class NoteFormScreen extends StatefulWidget {
  final NotesRepository repository;
  
  const NoteFormScreen({super.key, required this.repository});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final note = BlocProvider.of<NoteFormCubit>(context).state;
      _titleController.text = note.title;
      _contentController.text = note.content;
    });
  }

  void _saveNote() async {
    final noteCubit = BlocProvider.of<NoteFormCubit>(context);
    
    await widget.repository.saveNote(noteCubit.state);
    
    if (mounted) {
      Navigator.pop(context, true); // return true untuk trigger reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat / Edit Catatan'),
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Judul',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                BlocProvider.of<NoteFormCubit>(context).updateTitle(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Isi catatan',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  BlocProvider.of<NoteFormCubit>(context).updateContent(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}