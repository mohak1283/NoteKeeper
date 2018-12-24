import 'package:database_flutter_app/screens/note_detail.dart';
import 'package:database_flutter_app/screens/note_list.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteKeeper",
      theme: ThemeData(
        primarySwatch: Colors.lime
      ),
      home: NoteList(),
    );
  }
}