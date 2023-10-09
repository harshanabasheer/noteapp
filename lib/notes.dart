import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/settings_page.dart';


class NotesAdd extends StatefulWidget {
  const NotesAdd({super.key});

  @override
  State<NotesAdd> createState() => _NotesAddState();
}

class _NotesAddState extends State<NotesAdd> {
  final CollectionReference _notes = FirebaseFirestore.instance.collection('noteapp');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Color> colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue,
                        Colors.deepOrange,Colors.greenAccent,Colors.purple, Colors.brown];
  Random random = Random();
  int index = 0;
  void changeIndex() {
    if (colors.isNotEmpty) {
      setState(() {
        index = random.nextInt(colors.length);
      });
    }
  }
  bool isListView = true;

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    DateTime now = DateTime. now();
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _notesController.text = documentSnapshot['notes'];

    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String title = _titleController.text;
                    final String notes =_notesController.text;
                    final date = DateFormat('EEEE, MMM d, yyyy').format(now);

                    if (notes != null) {
                      await _notes.add({"title": title, "notes": notes,"date":date});
                      _titleController.text = '';
                      _notesController.text = '';
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          );
        });
  }


  @override

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(isListView ? Icons.grid_on : Icons.list, color: Colors.black),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
          title: Text("Notes", style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()),);
              },
            ),
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () => _create(),
          child: Icon(Icons.note_add_outlined, color: Colors.black),
        ),
        body: StreamBuilder(
          stream: _notes.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              if (isListView) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return Card(
                      color: colors[index % colors.length],
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(documentSnapshot['notes'], style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(documentSnapshot['date'], style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                );
              } else {
                // Show Grid View
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Set the number of columns here
                  ),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return Card(
                      color: colors[index % colors.length],
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(documentSnapshot['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 10,),
                            Text(documentSnapshot['notes'], style: TextStyle(fontSize: 15)),
                            SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(documentSnapshot['date'], style: TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      );
    }
}
