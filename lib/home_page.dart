import 'package:flutter/material.dart';
import 'package:notlar/category_operations.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/models/note.dart';
import 'package:notlar/note_content.dart';
import 'package:notlar/note_operations.dart';
import 'package:notlar/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Note> allNotes = List<Note>();

  @override
  void initState() {
    super.initState();
    List<Note> allNotes = List<Note>();
    DatabaseHelper databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        title: Text(
          "Notlarım",
          style: TextStyle(
              fontFamily: "Balsamiq",
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade200),
        ),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.grey.shade200,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      color: Colors.orange,
                    ),
                    title: Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _goCategoryPage(context); //kategori sayfasına git
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              addCategoryDialog(context);
            },
            heroTag: "KategoriEkle",
            tooltip: "Kategori Ekle",
            child: Icon(Icons.add_to_photos_rounded,
                color: Colors.black, size: 30.0),
            mini: true,
            backgroundColor: Colors.orange,
          ),
          FloatingActionButton(
            heroTag: "NotEkle",
            tooltip: "Not Ekle",

            onPressed: () {
              _goContentPage(context);
            }, //içerik sayfasına git
            child: Icon(Icons.playlist_add_rounded,
                color: Colors.black, size: 40.0),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: NoteOperations(),
      //_control(context),
    );
  }

  void addCategoryDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String newCategoryName;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.grey.shade300,
            title: Text(
              "Kategori Ekle",
              style: TextStyle(
                  fontFamily: "Balsamiq",
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                  fontSize: 18),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      newCategoryName = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    //girilen kategori adı 2den küçükse uyar
                    validator: (enteredCategoryName) {
                      if (enteredCategoryName.length < 2) {
                        return "En az 2 karakter giriniz.";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Colors
                            .grey.shade900), //Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.grey,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Colors
                              .redAccent, //Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Colors
                            .grey.shade900), //Theme.of(context).accentColor),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        databaseHelper
                            .addCategory(Category(newCategoryName))
                            .then((categoryID) {
                          if (categoryID > 0) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kategori Eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Colors.orange, //Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _goContentPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NoteContent(
                  name: "Yeni Not",
                ))).then((getNote) => setState(() {}));
  }

  void _goCategoryPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryOperations()));
  }
}
