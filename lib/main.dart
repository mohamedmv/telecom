import 'package:flutter/material.dart';
import 'choicesScreen/choices.dart';
import 'database.dart';
import 'firstScreen/firstScreen.dart';
import 'home/Home.dart';

void main() async {
   await intializeDatabase();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "firstScreen",
      routes: {
        "home": (context) => Home(),
        "firstScreen": (context) => FirstScreen(),
        "choices": (context) => Choices(),
      },
    );
  }
}

/*
* */
