import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Center(
          child: Text("Notlarım"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
            tooltip: "Kategori Ekle",
            child: Icon(Icons.add_to_photos_rounded,
                color: Colors.black, size: 30.0),
            mini: true,
            backgroundColor: Colors.orange,
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: "Not Ekle",
            child: Icon(Icons.playlist_add_rounded,
                color: Colors.black, size: 40.0),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: Container(),
    );
  }
}
