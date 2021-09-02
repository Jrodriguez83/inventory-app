import 'package:flutter/material.dart';
import 'package:inventory_app/categories/category.dart';
import 'package:inventory_app/categories/category_database.dart';

class AddCategory extends StatefulWidget {
  
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  
  CategoryDbHelper dbHelper = CategoryDbHelper();
  CategoryName category = CategoryName('','');
  TextEditingController nameController = TextEditingController();
  
  @override
  void initState() {
    openDb(dbHelper);
    super.initState();
  }

  void openDb(CategoryDbHelper dbHelper) async{
    await dbHelper.initializeDatabase();


  }

  @override
  Widget build(BuildContext context) {
    category.categoryName = nameController.text;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Category'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: (){
                    setState(() {
                      _save(category.categoryName);
                    });
                  })
            ],
          ),
          body: Form(
              child: ListView(
            children: <Widget>[
              Container(
                // Spacer container
                height: 20,
              ),
              Row(
                children: <Widget>[
                  // Spacer container
                  Expanded(
                    child: Container(
                      width: 5,
                    ),
                    flex: 0,
                  ),
                  //Category Icon
                  Expanded(
                      flex: 0,
                      child: CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.all_inclusive,
                            size: 30,
                          ))),
                  //Spacer container
                  Expanded(
                      flex: 0,
                      child: Container(
                        width: 10,
                      )),
                  //Add new category field
                  Expanded(
                      child: TextFormField(
                        controller: nameController ,
                        onChanged: (String value){
                          setState(() {
                            category.categoryName = nameController.text;
                          });
                        },
                    decoration: InputDecoration(helperText: 'Category Name'),
                  ))
                ],
              ),
            ],
          )),
        ),
        onWillPop: null);
  }

  void _save(String name) async{
    
    var result;
      await dbHelper.initializeDatabase();
      if (category.id == null) {
        result = await dbHelper.insertData(CategoryName(name,''));      

      }
    
    if (result == 0) {
      _showAlertDialog('Status', 'Error Saving');
    }else{
      Navigator.pop(context);
      _showAlertDialog('Status', 'Category successfully saved');
    }
  }

  void _showAlertDialog(String status, String message){
    var alertDialog = AlertDialog(
      title: Text(status),
      content: Text(message),
    );

    showDialog(context: context, builder: (context)=> alertDialog);
  }
}
