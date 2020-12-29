import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notlar/models/note.dart';
import 'package:notlar/note_content.dart';
import 'package:notlar/utils/database_helper.dart';

class NoteOperations extends StatefulWidget {
  @override
  _NoteOperationsState createState() => _NoteOperationsState();
}

class _NoteOperationsState extends State<NoteOperations> {
  List<Note> allNotes;

  DatabaseHelper databaseHelper;
  Future<List<Note>> veri;
  @override
  void initState() {
    super.initState();
    allNotes = List<Note>();

    databaseHelper = DatabaseHelper();
    veri = databaseHelper.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleName = Theme.of(context).textTheme.body1.copyWith(
        fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Balsamiq');

    return FutureBuilder(
      future: veri,
      builder: (context, AsyncSnapshot<List<Note>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          allNotes = snapShot.data;
          sleep(Duration(milliseconds: 500));
          return ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (BuildContext context, index) {
                return ExpansionTile(
                  leading: _assignPriorityIcon(
                      allNotes[index].notePriority), //öncelik iconu ata
                  title: Text(
                    allNotes[index].noteName,
                    style: textStyleName,
                  ),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  allNotes[index].categoryName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Oluşturulma Tarihi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  databaseHelper.dateFormat(
                                      DateTime.parse(allNotes[index].noteDate)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "İçerik",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 14),
                                child: Text(
                                  allNotes[index].noteContent,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              OutlineButton(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  onPressed: () =>
                                      _deleteNote(allNotes[index].noteID),
                                  child: Text(
                                    "SİL",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              OutlineButton(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                  onPressed: () {
                                    _goContentPage(context, allNotes[index]);
                                  },
                                  child: Text(
                                    "GÜNCELLE",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        } else {
          return Center(child: Text("Yükleniyor..."));
        }
      },
    );
  }

  _goContentPage(BuildContext context, Note note) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteContent(
                  name: "noteToBeEdited",
                  noteToBeEdited: note,
                )));
  }

  _assignPriorityIcon(int notePriority) {
    switch (notePriority) {
      case 0:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "AZ",
              style: TextStyle(
                  color: Colors.deepOrange.shade200,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);
        break;
      case 1:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ORTA",
              style: TextStyle(
                  color: Colors.deepOrange.shade400,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);
      case 2:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ACIL",
              style: TextStyle(
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);
        break;
    }
  }

  _deleteNote(int noteID) {
    databaseHelper.deleteNote(noteID).then((deletedID) {
      //silinen ID
      if (deletedID != 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Not Silindi")));

        setState(() {});
      }
    });
  }
}
