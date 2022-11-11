import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_osy/models/entry.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();
  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'FinancialPlanning.db';

    //create, read databases
    var itemDatabase = openDatabase(path, version: 4, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

  //buat tabel baru dengan nama product dan etry
  void _createDb(Database db, int version) async {
    await db.execute('''
 CREATE TABLE entry (
 entryId INTEGER PRIMARY KEY AUTOINCREMENT,
 titlee TEXT,
 type TEXT,
 total INTEGER
 )
 ''');
  }

//PEMASUKKAN---------------------------------------------
  Future<List<Map<String, dynamic>>> selectEntry() async {
    Database db = await this.initDb();
    var mapList = await db.query('entry', orderBy: 'titlee');
    return mapList;
  }

//create databases
  Future<int> insertEntry(Entry object) async {
    Database db = await this.initDb();
    int count = await db.insert('entry', object.toMap());
    return count;
  }

//update databases
  Future<int> updateEntry(Entry object) async {
    Database db = await this.initDb();
    int count = await db.update('entry', object.toMap(),
        where: 'entryId=?', whereArgs: [object.entryId]);
    return count;
  }

//delete databases
  Future<int> deleteEntry(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('entry', where: 'entryId=?', whereArgs: [id]);
    return count;
  }

  Future<List<Entry>> getEntryList() async {
    var itemMapList = await selectEntry();
    int count = itemMapList.length;
    List<Entry> itemList = List<Entry>();
    for (int i = 0; i < count; i++) {
      itemList.add(Entry.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
