import 'package:flutter/material.dart';
import 'package:inventory_app/categories/category.dart';
import 'package:inventory_app/categories/category_database.dart';
import 'package:inventory_app/screens/add_categories.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage(this.drawer);
  final Drawer drawer;
  @override
  _CategoriesPageState createState() => _CategoriesPageState(drawer);
}

class _CategoriesPageState extends State<CategoriesPage> {
  _CategoriesPageState(this.drawer);
  final Drawer drawer;
  CategoryDbHelper categoryDb = CategoryDbHelper();
  List<CategoryName> category = [];
  var db;
  int count;

  @override
  void initState() {
    startDataBase(categoryDb, category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return AddCategory();
                }));
              },
              tooltip: 'Add new Category',
            )
          ],
        ),
        body: getCategoryList(),
        drawer: drawer,
      ),
    );
  }

  ListView getCategoryList() {
    startDataBase(categoryDb, category);
    return ListView.builder(
      itemBuilder: ((BuildContext context, int position) {
        return Card(
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(),
            title: Text(category[position].categoryName),
            trailing: GestureDetector(
              child: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onTap: () {
                setState(() {
                  deleteData(category[position].id);
                  startDataBase(categoryDb, category);
                });
              },
            ),
          ),
        );
      }),
      itemCount: count,
    );
  }

  void startDataBase(
      CategoryDbHelper category, List<CategoryName> catList) async {
    await category.initializeDatabase();
    catList = await category.getDataAsList();
    setState(() {
      this.category = catList;
      this.count = catList.length;
    });
  }

  void deleteData(int id) async {
    var result;
    result = await categoryDb.deleteData(id);

    if (result == 0) {
      print('could not delete $id');
    } else {
      print('Deleted!');
    }
  }
}
