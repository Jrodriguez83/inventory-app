import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/Inventory/inventory_database.dart';
import 'package:inventory_app/screens/categories.dart';
import 'package:inventory_app/screens/content.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inventory_app/Inventory/inventory.dart';

class MainList extends StatefulWidget {
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  DatabaseHelper database = DatabaseHelper();
  List<Inventory> recordList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    updateList();
    return WillPopScope(onWillPop: (){
      SystemNavigator.pop();
      return null;
    }, 
    child: Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
      ),
      drawer: getDrawer(),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToContactScreen('Add Record', Inventory(1, "", '', ''));
        },
        child: Icon(Icons.add),
      ),
    ), );
  }

  Drawer getDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer'),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),
          ListTile(
            title: Text('Inventory'),
            onTap: (){
              navigateToInventoryScreen();
            },
          ),
          ListTile(
            title: Text('Categories'),
            onTap: (){
              moveToCategories();
            },
          )
        ],
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, position) {
          return Card(
            elevation: 10,
            child: ListTile(
              leading: CircleAvatar(
                child: leadingIcon(position),
              ),
              title: Text(recordList[position].name),
              subtitle: Text('Date submitted: ${recordList[position].date}'),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    database.deleteData(recordList[position].id);
                    showSnackBar(context,
                        message:
                            '${recordList[position].name} has been deleted');
                  });
                },
              ),
              onTap: () {
                setState(() {
                  moveToContactScreen('Edit Record', recordList[position]);
                });
              },
            ),
          );
        });
  }

  void moveToCategories(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CategoriesPage(getDrawer());
    }));
  }

  void moveToContactScreen(String title, Inventory record) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactScreen(title, record);
    }));
  }

  void navigateToInventoryScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return MainList();
    }));
  }

  void updateList() {
    final Future<Database> dbFuture = database.initializeDatabase();
    dbFuture.then((Database database) {
      Future<List<Inventory>> recordListFuture = this.database.getRecordList();
      recordListFuture.then((recordList) {
        setState(() {
          this.recordList = recordList;
          this.count = recordList.length;
        });
      });
    });
  }

  Icon leadingIcon(int position) {
    Icon themeIcon;
    switch (recordList[position].type) {
      case 1:
        themeIcon = Icon(Icons.home);
        break;
      case 2:
        themeIcon = Icon(Icons.directions_car);
        break;
      default:
        themeIcon = Icon(Icons.all_inclusive);
    }

    return themeIcon;
  }

  void showSnackBar(BuildContext context, {String message = 'Item deleted'}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue,
    ));
  }
}
