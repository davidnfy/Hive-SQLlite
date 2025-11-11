import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'repositories/notes_repository.dart';
import 'blocs/notes_list_bloc/notes_list_bloc.dart';
import 'pages/notes_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Hive
  await Hive.initFlutter();
  await Hive.openBox('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notesBox = Hive.box('notesBox');
    final notesRepository = NotesRepository(notesBox);
    
    return BlocProvider<NotesListBloc>(
      create: (_) => NotesListBloc(notesRepository)..add(LoadNotes()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: NotesListScreen(repository: notesRepository),
      ),
    );
  }
}