import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/screens/note_card.dart';
import 'package:notes_app/screens/note_dialog.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> notecolors = [
    const Color(0xFFFFF9C4),
    const Color(0xFFFFE0B2),
    const Color(0xFFFFCCBC),
    const Color(0xFFFFF8E1),
    const Color(0xFFFFE1F5),
    const Color.fromARGB(255, 38, 141, 189),
    const Color(0xFFE8F5E9),
    const Color(0xFFE3F2FD),
    const Color(0xFFFFF3E0),
    const Color.fromARGB(255, 234, 57, 57),
    const Color.fromARGB(255, 249, 241, 155),
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogcontext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: notecolors,
          noteId: id,
          title: title,
          content: content,
          onNoteSaved:
              (
                newTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              ) async {
                if (id == null) {
                  await NotesDatabase.instance.addNote(
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                  );
                } else {
                  await NotesDatabase.instance.updateNote(
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                    id,
                  );
                }
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NotesDatabase.instance.addNote(
            'Sample Title',
            'Sample Description',
            '2026-04-02',
            0,
          );

          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes_outlined, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 20),
                  Text(
                    'No notes yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return NoteCard(
                    note: note,
                    onDelete: () async {
                      await NotesDatabase.instance.deleteNote(note['id']);
                      fetchNotes();
                    },
                    onTap: () {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorIndex: note['color'],
                      );
                    },
                    noteColors: notecolors,
                  );
                },
              ),
            ),
    );
  }
}
