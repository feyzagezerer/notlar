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
        fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Balsamiq');

    if (allCategory == null) {
      allCategory = List<Category>();
      updateCategoryList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler"),
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
                  color: Colors.orange,
                ),
                onTap: () => _deleteCategory(allCategory[index].categoryID),
              ),
              leading: Icon(
                Icons.import_contacts,
                color: Colors.blueGrey,
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
            title: Text("Kategori Sil ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecektir.\n\nEmin misiniz?"),
                ButtonBar(
                  children: <Widget>[
                    OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
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
            title: Text(
              "Kategori Güncelle",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey),
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
                      } else {
                        return null;
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
}
