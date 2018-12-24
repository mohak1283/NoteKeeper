import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:database_flutter_app/utils/database_helper.dart';
import 'package:database_flutter_app/models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _formKey = GlobalKey<FormState>();

  _NoteDetailState(this.note, this.appBarTitle);

  var _priorities = ["High", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    // Setting the text on the TextFields.
    titleController.text = note.title;
    descriptionController.text = note.description;

    // This WillPopScope widget is used to control the device back button
    return WillPopScope(
      // This handler will be invoked when device back button is pressed.
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton<String>(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newItemSelected) {
                      updatePriorityAsInt(newItemSelected);
                    },
                    style: textStyle,
                    value: updatePriorityAsString(note.priority),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    style: textStyle,
                    controller: titleController,
                    validator: (String userInput) {
                      if(userInput.isEmpty) {
                        return 'Please enter title';
                      }
                    },
                    onFieldSubmitted: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: "Title",
                      labelStyle: textStyle,
                      hintText: "Enter note title",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    style: textStyle,
                    controller: descriptionController,
                    validator: (String userInput) {
                      if(userInput.isEmpty) {
                        return 'Please enter description';
                      }
                    },
                    onFieldSubmitted: (String value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: "Description",
                      labelStyle: textStyle,
                      hintText: "Enter note description",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.deepPurple,
                          child: Text("Save"),
                          textColor: Colors.white,
                          splashColor: Colors.yellow,
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              save();
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.deepPurple,
                          child: Text("Delete"),
                          textColor: Colors.white,
                          splashColor: Colors.yellow,
                          onPressed: () {
                            debugPrint("Delete Button pressed");
                            delete();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true); // passing the true value to noteList screen.
  }

  // Convert the string priority in the form of integer before saving in the database.
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority in the form of String to display it in the DropDown
  String updatePriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  // Update title of note object.
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update description of note object.
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Saving data to database.
  void save() async {
    moveToLastScreen();
    note.date =
        DateFormat.yMMMd().format(DateTime.now()); // Sets the current date

    int result;
    if (note.id != null) {
      // Update operation
      result = await databaseHelper.update(note);
    } else {
      // Insert operation
      result = await databaseHelper.insert(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved successfully');
    } else {
      _showAlertDialog('Status', 'Error saving note, Please try again later');
    }
  }

  void delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', 'No note was deleted');
      return;
    } else {
      int result = await databaseHelper.delete(note.id);
      if (result != 0) {
        _showAlertDialog('Status', 'Note Deleted Successfully');
      } else {
        _showAlertDialog('Status',
            'Error occurred while deleting note, please try again later');
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
