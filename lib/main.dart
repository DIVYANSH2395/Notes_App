
import 'package:flutter/material.dart';
import 'package:notes_app/screens/notes_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {                                                 
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          ),
          home: const MyWidget(),
    );
  }
}                                                                            
                                                                                           