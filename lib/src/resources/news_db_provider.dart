import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';
import 'dart:core';

class NewsDbProvider implements Source, Cache{
  Database db; //we cannot use async with constructors so init method is used in this instead of constructor
  NewsDbProvider(){
    init();
  }
  
  Future<List<int>> fetchTopIds() async {
   return null;
  }


  void init() async {
    Directory documentDirectory =
        await getApplicationDocumentsDirectory(); // return address of a folder on our device where we can store the data
    final path = join(documentDirectory.path,
        "items4.db"); //stores reference to file path where actual database is stored
    db = await openDatabase(
      path,
      version: 1, 
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by Text,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER,
          )
        """);
    });
  }
  Future<ItemModel> fetchItem(int id) async{
    final maps= await db.query(
      "Items",
      columns: null,
      where:"id = ?",
      whereArgs: [id],
    );
    if(maps.length>0){
      return ItemModel.fromDb(maps.first);
    }
    else
    {
      return null;
    }
  }
  Future<int> addItem(ItemModel item) {
    final result=db.insert(
      "Items",
      item.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
  );
    print(result);
    return result;
  }
  Future<int> clear() async{
    await db.delete("Items");
  }
}

final newsDbProvider = NewsDbProvider();
