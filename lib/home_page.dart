import 'package:flutter/material.dart';
import 'package:notlar/category_operations.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/note_content.dart';
import 'package:notlar/note_operations.dart';
import 'package:notlar/utils/database_helper.dart';

class NoteList extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //   backgroundColor: Colors.black,
      appBar: AppBar(
        //   backgroundColor: Colors.grey.shade900,
        elevation: 0,
        title: Text(
          "Notlarım",
          style: TextStyle(fontFamily: "Balsamiq", fontWeight: FontWeight.w600),
        ),

        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                      Icons.import_contacts,
                      color: Colors.orange,
                    ),
                    title: Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w700),
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

            onPressed: () => _goContentPage(context), //içerik sayfasına git
            child: Icon(Icons.playlist_add_rounded,
                color: Colors.black, size: 40.0),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: NoteOperations(),
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
            title: Text(
              "Kategori Ekle",
              style: TextStyle(
                  fontFamily: "Balsamiq",
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
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
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
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
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
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
            builder: (context) => NoteContent(
                  name: "Yeni Not",
                )));
  }

  void _goCategoryPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryOperations()));
  }
}
