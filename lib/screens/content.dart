import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_app/Inventory/inventory.dart';
import 'package:inventory_app/Inventory/inventory_database.dart';
import 'package:inventory_app/categories/category.dart';
import 'package:inventory_app/categories/category_database.dart';

import '../main.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen(this.title, this.record);
  final String title;
  final Inventory record;
  @override
  _ContactScreenState createState() => _ContactScreenState(title, record);
}

class _ContactScreenState extends State<ContactScreen> {
  _ContactScreenState(this.title, this.record);
  Inventory record;
  var category = CategoryDbHelper();
  List<CategoryName> categoryName;
  var database = DatabaseHelper();
  var iName = TextEditingController();
  var iDescription = TextEditingController();
  var subName = TextEditingController();
  List<String> type = [];
  var title;

  @override
  void initState() {
    addCategoryToType(category, type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    iName.text = record.name;
    iDescription.text = record.description;
    subName.text = record.subName;

    return WillPopScope(
        onWillPop: () {
          MyApp.moveToLastScreen(context);
          // deleteAllData(category,type);
          addCategoryToType(category, type);
          return null;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  MyApp.moveToLastScreen(context);
                  // deleteAllData(category,type);
                }),
            title: Text(title),
          ),
          body: Form(
              child: ListView(
            children: <Widget>[
              //Row containing type and days widgets
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    //Dropdown for the type of Item being added
                    Expanded(
                        child: DropdownButton(
                            value: turnTypeIntoString(record.type),
                            items: type.map((String value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                turnTypeIntoInteger(newValue);
                              });
                            })),
                  ],
                ),
              ),

              //Text Field to enter the name of the Item
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (value) {
                    updateName();
                  },
                  controller: iName,
                  decoration: InputDecoration(
                      labelText: "Item Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),

              //Description of the submitted Item
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (value) {
                    updateDescription();
                  },
                  controller: iDescription,
                  decoration: InputDecoration(
                      labelText: "Item description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),

              //Name of the submitter's name

              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (value) {
                    updateSubName();
                  },
                  controller: subName,
                  decoration: InputDecoration(
                      labelText: "Submitter's Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),

              //Expanded Item containing Row
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      //Save button
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              MyApp.moveToLastScreen(context);
                              addCategoryToType(category, type);
                              _save();
                            });
                          },
                          child: Text('Save'),
                        ),
                      ),

                      //Delete button
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              MyApp.moveToLastScreen(context);
                              addCategoryToType(category, type);
                              _delete(record.id);
                            });
                          },
                          child: Text('Delete'),
                        ),
                      )
                    ],
                  ))
            ],
          )),
        ));
  }

  void _save() async {
    record.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (record.id != null) {
      result = await database.updateData(record);
    } else {
      result = await database.insertData(record);
    }

    if (result == 0) {
      showAlertDialog('Status', 'Error saving to Database');
    } else {
      showAlertDialog('Status', 'Record successfully saved');
    }
  }

  void _delete(int id) async {
    var result;

    if (record.id != null) {
      result = await database.deleteData(id);
    }

    if (result == 0) {
      showAlertDialog('Status', 'Error deleting from Database');
    } else {
      showAlertDialog('Status', 'Record successfully deleted');
    }
  }

  void turnTypeIntoInteger(String value) {
    for (var i = 0; i < type.length; i++) {
      if (value == type[i]) {
        record.type = i + 1;
      }
    }
  }

  String turnTypeIntoString(int value) {
    String type;
    for (var i = 0; i < this.type.length; i++) {
      if (value == i + 1) {
        type = this.type[i];
      }
    }
    return type;
  }

  void updateName() => record.name = iName.text;

  void updateDescription() => record.description = iDescription.text;

  void updateSubName() => record.subName = subName.text;

  void showAlertDialog(String title, String message) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  void addCategoryToType(CategoryDbHelper category, List<String> type) async {
    await category.initializeDatabase();
    var data = await category.getDataAsList();

    setState(() {
      for (var i = 0; i < data.length; i++) {
        if (type.contains(data[i].categoryName) == false) {
          type.add(data[i].categoryName);
        }
      }
    });
  }
}
