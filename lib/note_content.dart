import 'package:flutter/material.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/models/note.dart';
import 'package:notlar/utils/database_helper.dart';

class NoteContent extends StatefulWidget {
  String name;
  Note noteToBeEdited; //düzenlenecek not

  NoteContent({this.name, this.noteToBeEdited});

  @override
  _NoteContentState createState() => _NoteContentState();
}

class _NoteContentState extends State<NoteContent> {
  var formKey = GlobalKey<FormState>();
  List<Category> allCategory;
  DatabaseHelper databaseHelper;
  int categoryID;
  int chosenPriority; //seçilen öncelik
  Category chosenCategory;
  String noteName, noteContent;
  static var _priority = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCategory = List<Category>();
    databaseHelper = DatabaseHelper();
    databaseHelper.getCategory().then((mapListWhichIncludesCategory) {
      for (Map readMap in mapListWhichIncludesCategory) {
        //okunan map
        allCategory.add(Category.fromMap(readMap));
      }

      if (widget.noteToBeEdited != null) {
        categoryID = widget.noteToBeEdited.categoryID;
        chosenPriority = widget.noteToBeEdited.notePriority;
      } else {
        categoryID = 1;
        chosenPriority = 0;
        chosenCategory = allCategory[0];
        debugPrint(
            "secilen kategoriye deger atandı" + chosenCategory.categoryName);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var tag = TextStyle(
        //etiket
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.blueGrey);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Yeni Not"),
      ),
      body: allCategory.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategori :",
                            style: tag,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<Category>(
                                  items:
                                      createCategoryItems(), //kategori itemleri oluştur
                                  hint: Text("Kategori Seç"),
                                  value: chosenCategory,
                                  onChanged: (Category userSelectedCategory) {
                                    //kullanıcının seçtiği kategori
                                    debugPrint("Seçilen kategori:" +
                                        userSelectedCategory.toString());
                                    setState(() {
                                      chosenCategory = userSelectedCategory;
                                      categoryID =
                                          userSelectedCategory.categoryID;
                                    });
                                  })),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.noteToBeEdited != null
                            ? widget.noteToBeEdited.noteName
                            : "",
                        validator: (text) {
                          if (text.length < 2) {
                            return "En az 2 karakter olmalı.";
                          }
                        },
                        onSaved: (text) {
                          noteName = text;
                        },
                        decoration: InputDecoration(
                          hintText: "Notun adını giriniz.",
                          labelText: "Ad",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.noteToBeEdited != null
                            ? widget.noteToBeEdited.noteContent
                            : "",
                        onSaved: (text) {
                          noteContent = text;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Not içeriğini giriniz",
                          labelText: "İçerik",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Öncelik :",
                            style: tag,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                  items: _priority.map((priority) {
                                    return DropdownMenuItem<int>(
                                      child: Text(
                                        priority,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      value: _priority.indexOf(priority),
                                    );
                                  }).toList(),
                                  value: chosenPriority,
                                  onChanged: (chosenPriorityID) {
                                    setState(() {
                                      chosenPriority = chosenPriorityID;
                                    });
                                  })),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        OutlineButton(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "VAZGEÇ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )),
                        OutlineButton(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();

                                var now = DateTime.now();
                                if (widget.noteToBeEdited == null) {
                                  databaseHelper
                                      .addNote(Note(
                                          categoryID,
                                          noteName,
                                          noteContent,
                                          now.toString(),
                                          chosenPriority))
                                      .then((savedNoteID) {
                                    //kaydedilen not IDsi
                                    if (savedNoteID != 0) {
                                      Navigator.pop(context);
                                    }
                                  });
                                } else {
                                  databaseHelper
                                      .updateNote(Note.withID(
                                          widget.noteToBeEdited.noteID,
                                          categoryID,
                                          noteName,
                                          noteContent,
                                          now.toString(),
                                          chosenPriority))
                                      .then((updatedID) {
                                    //güncellenen ID
                                    if (updatedID != 0) {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              }
                            },
                            child: Text(
                              "KAYDET",
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
            ),
    );
  }

  List<DropdownMenuItem<Category>> createCategoryItems() {
    return allCategory.map((mycategory) {
      return DropdownMenuItem<Category>(
        value: mycategory,
        child: Text(
          mycategory.categoryName,
          style: TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }
}
