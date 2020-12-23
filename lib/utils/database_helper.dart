import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    //return kullanacaksan factory de

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notes.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> getCategory() async {
    var db = await _getDatabase();
    var result = await db.query("category");
    return result; //sonuc
  }

  //kategori listesini getir
  Future<List<Category>> getCategoryList() async {
    var mapListWhichIncludesCategory =
        await getCategory(); //kategorileri içeren map listesi
    var categoryList = List<Category>();
    for (Map map in mapListWhichIncludesCategory) {
      categoryList.add(Category.fromMap(map));
    }
    return categoryList;
  }

  Future<int> addCategory(Category category) async {
    var db = await _getDatabase();
    var result = await db.insert("category", category.toMap());
    return result;
  }

  Future<int> updateCategory(Category category) async {
    var db = await _getDatabase();
    var result = await db.update("category", category.toMap(),
        where: 'categoryID=?', whereArgs: [category.categoryID]);
    return result;
  }

  Future<int> deleteCategory(int categoryID) async {
    var db = await _getDatabase();
    var result = await db
        .delete("category", where: 'categoryID=?', whereArgs: [categoryID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getNote() async {
    var db = await _getDatabase();
    var result = await db.query("notes",
        orderBy: 'noteID DESC'); //en son eklenen not en başta gelsin
    return result;
  }

  //not listesini getir
  Future<List<Note>> getNoteList() async {
    var mapListWhichIncludesNote = await getNote(); //notlar map listesi
    var noteList = List<Note>();
    for (Map map in mapListWhichIncludesNote) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<int> addNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.insert("notes", note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.update("notes", note.toMap(),
        where: 'noteID=?', whereArgs: [note.noteID]);
    return result;
  }

  Future<int> deleteNote(int noteID) async {
    var db = await _getDatabase();
    var result =
        await db.delete("notes", where: 'noteID=?', whereArgs: [noteID]);
    return result;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
