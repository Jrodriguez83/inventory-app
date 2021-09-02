import 'package:flutter/material.dart';
import 'package:inventory_app/screens/list.dart';


main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainList(),
    );
  }

  static void moveToLastScreen(BuildContext context){
  Navigator.pop(context);
}
}