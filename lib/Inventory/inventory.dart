
class Inventory{

  int _id;
  int _type;
  String _date;
  String _name;
  String _description;
  String _subName;

  Inventory(this._type, this._date, this._name,this._subName,[this._description]);
  Inventory.withID(this._id,this._type, this._date, this._name,this._subName,[this._description]);

  int get id => _id;
  int get type => _type;
  String get date => _date;
  String get name => _name;
  String get description => _description;
  String get subName => _subName;

  set type(int newType){
    if (newType > 0) {
      this._type = newType;
    }
  }

  set date(String newDate){
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  set name(String newName){
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set description(String newDescription){
    if (newDescription.length <=255) {
      this._description = newDescription;
    }
  }

  set subName(String newSubName){
    if (newSubName.length <=255) {
      this._subName = newSubName;
    }
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }

    map['type'] = _type;
    map['date'] = _date;
    map['name'] = _name;
    map['description'] = _description;
    map['subName'] = _subName;

    return map;
  }

  Inventory.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._type = map['type'];
    this._date = map['date'];
    this._name = map['name'];
    this._description = map['description'];
    this._subName = map['subName'];

  }

}