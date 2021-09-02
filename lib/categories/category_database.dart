

import 'package:inventory_app/categories/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class CategoryDbHelper{
  static CategoryDbHelper _categoryDbHelper;
  static Database _database;

  String categoryTable = 'category_table';
  String colId = 'Id';
  String colCategoryName = 'category_name';
  String colIconName = 'icon_name';

  CategoryDbHelper.createInstance(); 

  factory CategoryDbHelper(){
    if (_categoryDbHelper == null) {
      _categoryDbHelper = CategoryDbHelper.createInstance();
    }

    return _categoryDbHelper;
  }

  Future<Database> initializeDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path + 'category.db';

    var categoryDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase);

    return categoryDatabase;

  }

  void _createDatabase(Database db, int newVersion) async{
     await db.execute('CREATE TABLE $categoryTable('
    '$colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCategoryName TEXT, $colIconName TEXT)');
    
    Map<String,dynamic> map = Map<String,dynamic>();
    map['category_name'] = 'Work';
    map['icon_name'] = 'work';

    Map<String,dynamic> map2 = Map<String,dynamic>();
    map2['category_name'] = 'Home';
    map2['icon_name'] = 'home';
    
    Map<String,dynamic> map3 = Map<String,dynamic>();
    map3['category_name'] = 'Car';
    map3['icon_name'] = 'directions_car';

    await db.insert('$categoryTable', map);
    await db.insert('$categoryTable', map2);
    await db.insert('$categoryTable', map3);

    // await insertData(CategoryName('Work', 'work'));
    // await insertData(CategoryName('Home', 'home'));
    // await insertData(CategoryName('Car', 'directions_car'));


  }

  Future<Database> get database async{
    if (_database == null){
      _database = await initializeDatabase();
    }

    return _database;
  }

  //The CRUD goes beyond

  //Create Operation
  Future<int> insertData(CategoryName category) async{
    var db = await this.database;
    var list = await getDataAsList();
    int result = 0;
    if (list.contains(category.convertIntoMap()) == false) {
          result = await db.insert('$categoryTable', category.convertIntoMap());
    }

    return result;

  }

  //Read Operation
  Future<List<Map<String,dynamic>>> pullData() async{
    var db = await this.database;

    var result = await db.query('$categoryTable', orderBy: '$colId ASC');

    return result;
  }

  //Update Operation
  Future<int> updateData(CategoryName category) async{
    var db = await this.database;

    var result = await db.update('$categoryTable', category.convertIntoMap());

    return result;
  }

  //Delete Operation
  Future<int> deleteData(int id) async{
    var db = await this.database;

    var result = await db.delete('$categoryTable', where: '$colId = $id');

    return result;
  }

  Future<int> deleteAllData() async{
    var db = await this.database;

    var result = await db.delete('$categoryTable');

    return result;
  }

  Future<List<CategoryName>> getDataAsList() async{
    var dataAsMap = await pullData();
    int count = dataAsMap.length;
    List<CategoryName> dataAsList = List<CategoryName>();

    for (var i = 0; i < count; i++) {
      dataAsList.add(CategoryName.fromMapObject(dataAsMap[i]));
    }

    return dataAsList;

  }

}