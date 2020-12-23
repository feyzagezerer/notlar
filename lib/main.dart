import 'package:flutter/material.dart';
import 'package:notlar/note_operations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notlarım",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Balsamiq',
          primarySwatch: Colors.purple,
          accentColor: Colors.orange),
      home: NoteOperations(),
    );
  }
}
