
class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String newTitle) {
    if(newTitle.length <= 256) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if(newDescription.length <= 256) {
      _description = newDescription;
    }
  }

  set date(String newDate) {
      _date = newDate;
  }

  set priority(int newPriority) {
    if(newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  // Convert a Note object to Map object because sqflite plugin 
  // only deals with Map objects.
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    if(_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  // Extract Note object from Map object.
  // Named constructor.
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }

}