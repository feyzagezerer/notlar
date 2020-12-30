import 'package:flutter/material.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/utils/database_helper.dart';

class CategoryOperations extends StatefulWidget {
  @override
  _CategoryOperationsState createState() => _CategoryOperationsState();
}

class _CategoryOperationsState extends State<CategoryOperations> {
  List<Category> allCategory;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleName = Theme.of(context).textTheme.body1.copyWith(
        color: Colors.grey.shade200,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Balsamiq');

    if (allCategory == null) {
      allCategory = List<Category>();
      updateCategoryList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Kategoriler",
          style: TextStyle(color: Colors.grey.shade200),
        ),
      ),
      body: ListView.builder(
          itemCount: allCategory.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => _updateCategory(allCategory[index], context),
              title: Text(
                allCategory[index].categoryName,
                style: textStyleName,
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onTap: () => _deleteCategory(allCategory[index].categoryID),
              ),
              leading: Icon(
                Icons.category,
                color: Colors.orange,
              ),
            );
          }),
    );
  }

  void updateCategoryList() {
    databaseHelper.getCategoryList().then((getCategory) {
      setState(() {
        allCategory = getCategory;
      });
    });
  }

  _deleteCategory(int categoryID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade200,
            title: Text("Kategori Sil ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Balsamiq')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "Kategoriyi sildiğinizde, bu kategoride bulunan tüm notlar da silinecektir.\n\nEmin misiniz?"),
                ButtonBar(
                  children: <Widget>[
                    OutlineButton(
                      borderSide: BorderSide(
                          color: Colors
                              .grey.shade900 //Theme.of(context).primaryColor
                          ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(
                            color: Colors
                                .redAccent, //Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    OutlineButton(
                      borderSide: BorderSide(
                          color: Colors
                              .grey.shade900), //Theme.of(context).accentColor),
                      onPressed: () {
                        databaseHelper
                            .deleteCategory(categoryID)
                            .then((deletedCategory) {
                          if (deletedCategory != 0) {
                            //silinen kategori
                            setState(() {
                              updateCategoryList();
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(
                            color:
                                Colors.orange, //Theme.of(context).accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  //categoryToUpdate = güncellenecek kategori
  _updateCategory(Category categoryToUpdate, BuildContext c) {
    categoryUpdateDialog(c, categoryToUpdate);
  }

  void categoryUpdateDialog(BuildContext myContext, Category categoryToUpdate) {
    var formKey = GlobalKey<FormState>();
    String categoryToUpdateName; //güncellenecek kategori adı

    showDialog(
        barrierDismissible: false,
        context: myContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.grey.shade300,
            title: Text(
              "Kategori Güncelle",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w400,
                  color: Colors.orange),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: categoryToUpdate.categoryName,
                    onSaved: (newValue) {
                      categoryToUpdateName = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (enteredCategorName) {
                      if (enteredCategorName.length < 2) {
                        return "En az 2 karakter giriniz";
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
                    color: Colors.orange,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Colors
                              .redAccent, // Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Colors.grey
                            .shade900), //color: Theme.of(context).accentColor),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();

                        databaseHelper
                            .updateCategory(Category.withID(
                                categoryToUpdate.categoryID,
                                categoryToUpdateName))
                            .then((katID) {
                          if (katID != 0) {
                            Scaffold.of(myContext).showSnackBar(
                              SnackBar(
                                content: Text("Kategori Güncellendi"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            updateCategoryList();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Colors.orange, //Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
