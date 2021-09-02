
import 'dart:io';

import 'package:inventory_app/Inventory/inventory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String inventoryTable = 'inventory_table';
  String colId = 'id';
  String colType = 'type';
  String colDate = 'date';
  String colName = 'name';
  String colDescription = 'description';
  String colSubName = 'subName'; 

  DatabaseHelper.createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'inventory.db';

    Database inventoryDatabase = await openDatabase(path,version: 1, onCreate: _createDb);

    return inventoryDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $inventoryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colType INTEGER, $colDate TEXT, '
    '$colName TEXT, $colDescription TEXT, $colSubName TEXT)');

  }

  Future<Database> get database async{
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  //The CRUD goes beyond

  // Create Operation (To insert Data)
  Future<int> insertData(Inventory record) async{
    Database db = await this.database;

    int result = await db.insert('$inventoryTable', record.toMap());

    return result;
  }

  // Read Operation (To retrieve the Data)
  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await this.database;

    var result = await db.query("$inventoryTable", orderBy: "$colId ASC");

    return result;

  }

  // Update Operation (To update the existing Data)
  Future<int> updateData(Inventory record) async{
    var db = await this.database;

    var result = db.update('$inventoryTable', record.toMap());

    return result;
  }

  // Delete Operation (To delete the existing data)
  Future<int> deleteData(int id) async{
    var db = await this.database;

    var result = db.delete('$inventoryTable', where: '$colId = $id');

    return result;
  }

  // Get amount of records in DB
  Future<int> getCount() async{
    var db = await this.database;

    var x = await db.rawQuery('SELECT COUNT (*) from $inventoryTable');

    var result = Sqflite.firstIntValue(x);

    return result;
  }

  // To pass the Data to the Data base, we needed to pass it as a map, now we will
  // turn it back into a list so we can use it in our app.

  Future<List<Inventory>> getRecordList() async{
    var recordsAsMap = await getData();
    int count = recordsAsMap.length;

    List<Inventory> recordList = List<Inventory>();
    for (var i = 0; i < count; i++) {
      recordList.add(Inventory.fromMapObject(recordsAsMap[i]));
    }

    return recordList;
  }
  
  
}