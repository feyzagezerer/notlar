import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notlar/models/category.dart';
import 'package:notlar/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    var result = await db.query("note",
        orderBy: 'noteID DESC'); //en son eklenen not en başta gelsin
    return result;
  }

  Future<int> addNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.insert("note", note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.update("note", note.toMap(),
        where: 'noteID=?', whereArgs: [note.noteID]);
    return result;
  }

  Future<int> deleteNote(int noteID) async {
    var db = await _getDatabase();
    var result =
        await db.delete("note", where: 'noteID=?', whereArgs: [noteID]);
    return result;
  }
}
