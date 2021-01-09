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
  DatabaseHelper databaseHelper;
  List<Note> allNotes;

  Future<List<Note>> veri;

  @override
  void initState() {
    super.initState();
    allNotes = List<Note>();

    databaseHelper = DatabaseHelper();
    //DENEMEICIN// YAPTIM veri = databaseHelper.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleName = Theme.of(context).textTheme.body1.copyWith(
        color: Colors.grey.shade200,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Balsamiq');

    return FutureBuilder(
      future: databaseHelper.getNoteList(),
      builder: (BuildContext context, AsyncSnapshot<List<Note>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          allNotes = snapShot.data;
          sleep(Duration(milliseconds: 500));
          return ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
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
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  allNotes[index].categoryName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.grey
                                          .shade200), //Theme.of(context).accentColor),
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
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  databaseHelper.dateFormat(
                                      DateTime.parse(allNotes[index].noteDate)),
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                  //color: Theme.of(context).accentColor),
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
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 14),
                                child: Text(
                                  allNotes[index].noteContent,
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20
                                      //color: Colors.blueGrey
                                      ),
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
                                      color: Colors.grey
                                          .shade900 //Theme.of(context).primaryColor
                                      ),
                                  onPressed: () {
                                    _deleteNote(allNotes[index].noteID);
                                  },
                                  child: Text(
                                    "SİL",
                                    style: TextStyle(
                                        color: Colors
                                            .redAccent, //Theme.of(context).primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )),
                              OutlineButton(
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade900 // Theme.of(context).accentColor
                                      ),
                                  onPressed: () {
                                    _goContentPage(context, allNotes[index]);
                                  },
                                  child: Text(
                                    "GÜNCELLE",
                                    style: TextStyle(
                                        color: Colors
                                            .orange, //Theme.of(context).accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
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
                  name: "Notu Düzenle",
                  noteToBeEdited: note,
                ))).then((getNote) => setState(() {}));
  }

  _assignPriorityIcon(int notePriority) {
    switch (notePriority) {
      case 0:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "AZ",
              style: TextStyle(color: Colors.orange, fontSize: 14),
            ),
            backgroundColor: Colors.grey.shade900);
        break;
      case 1:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ORTA",
              style: TextStyle(color: Colors.orange, fontSize: 14),
            ),
            backgroundColor: Colors.grey.shade900);
      case 2:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ACİL",
              style: TextStyle(
                  color: Colors.deepOrangeAccent.shade400,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade900);
        break;
    }
  }

  _deleteNote(int noteID) {
    databaseHelper.deleteNote(noteID).then((deletedID) {
      //silinen ID
      if (deletedID != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          "Not Silindi",
          style: TextStyle(color: Colors.grey.shade200),
        )));
        setState(() {});
      }
    });
  }
}
