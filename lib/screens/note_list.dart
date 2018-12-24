import 'package:database_flutter_app/models/note.dart';
import 'package:database_flutter_app/screens/note_detail.dart';
import 'package:database_flutter_app/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (_noteList == null) {
      _noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB Pressed");
          // This is used to navigate to a new screen
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
        tooltip: "Add New Note",
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle style = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(_noteList[position].priority),
              child: getPriorityIcon(_noteList[position].priority),
            ),
            title: Text(_noteList[position].title, style: style),
            subtitle: Text(_noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                _delete(context, _noteList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile item tapped");
              navigateToDetail(_noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Note note, String title) async {
    // By prefixing await keyword, we are simple awaiting the response from noteDetail Screen.
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) { 
      return NoteDetail(note, title);
    }));
    if(result == true) {
      updateListView();
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.arrow_right);
        break;
      default:
        return Icon(Icons.arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await _databaseHelper.delete(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    var snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() async {
    var database = await  _databaseHelper.initializeDatabase();
    List<Note> noteList = await _databaseHelper.getNotesList();
     setState(() {
          this._noteList = noteList;
          this.count = noteList.length;
        });
    // final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //   Future<List<Note>> noteListFuture = _databaseHelper.getNotesList();
    //   noteListFuture.then((noteList) { 
    //   });
    // });
  }
}
