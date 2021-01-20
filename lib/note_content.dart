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
  List<Category> allCategories;
  DatabaseHelper databaseHelper;
  int categoryID;
  String categoryName;
  int chosenPriority; //seçilen öncelik
  Category chosenCategory;
  String noteName, noteContent;
  static var _priority = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCategories = List<Category>();
    databaseHelper = DatabaseHelper();
    databaseHelper.getCategory().then((mapListWhichIncludesCategory) {
      for (Map readMap in mapListWhichIncludesCategory) {
        //okunan map
        allCategories.add(Category.fromMap(readMap));
      }

      if (widget.noteToBeEdited != null) {
        categoryID = widget.noteToBeEdited.categoryID;
        chosenPriority = widget.noteToBeEdited.notePriority;
      } else {
        categoryID = allCategories[0].categoryID;
        chosenPriority = 0;
        chosenCategory = allCategories[0];
        debugPrint(
            "seçilen kategoriye değer atandı " + chosenCategory.categoryName);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var tag = TextStyle(
        //etiket
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Colors.orange);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(widget.name),
      ),
      body: allCategories.length <= 0
          ? Center(
              child: Text(
                "Not eklemeden önce kategori eklemeniz gerekmektedir.",
                style: TextStyle(color: Colors.black),
              ),
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
                            "Kategori: ",
                            style: tag,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                                      .shade900, //Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<Category>(
                            items:
                                createCategoryItems(), //kategori itemleri oluştur
                            hint: Text(
                              "Kategori Seç",
                              style: TextStyle(color: Colors.grey.shade200),
                            ),
                            value: chosenCategory,
                            onChanged: (Category userSelectedCategory) {
                              //kullanıcının seçtiği kategori
                              //   debugPrint("Seçilen kategori:" + userSelectedCategory.toString());
                              setState(() {
                                chosenCategory = userSelectedCategory;
                                categoryID = userSelectedCategory.categoryID;
                              });
                            },
                          )),
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
                          hintText: "Not içeriğini giriniz.",
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
                            "Öncelik: ",
                            style: tag,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                                      .shade900, //Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                  items: _priority.map((priority) {
                                    return DropdownMenuItem<int>(
                                      child: Text(
                                        priority,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.orange),
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
                                color: Colors.grey
                                    .shade900), // Theme.of(context).primaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "VAZGEÇ",
                              style: TextStyle(
                                  color: Colors
                                      .redAccent, //Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            )),
                        OutlineButton(
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade900), // Theme.of(context).accentColor),
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
                                  color: Colors
                                      .orange, //Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
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
    return allCategories.map((mycategory) {
      return DropdownMenuItem<Category>(
        value: mycategory,
        child: Text(
          mycategory.categoryName,
          style: TextStyle(fontSize: 16, color: Colors.orange),
        ),
      );
    }).toList();
  }
}
