import 'package:mynote/mynote.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import 'dart:io' as io;
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "SimpleNotDB");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE mynote(id INTEGER PRIMARY KEY, title TEXT, note TEXT,createDate TEXT, updateDate TEXT, sortDate TEXT)");
    print("DB created");
  }

  Future<int> saveNote(Mynote mynote) async{
    var dbClient = await db;
    int res =await dbClient.insert("mynote", mynote.toMap());
    print("data inserted");
    return res;
  }

  Future<List<Mynote>> getNote() async{
    var dbClien = await db;
    List<Map> list = await dbClien.rawQuery("select * from mynote ORDER BY sortDate DESC");
    List<Mynote> noteData=new List();
    for(int i=0; i<list.length; i++){
      var note= new Mynote(list[i]['title'],list[i]['note'],list[i]['createDate'],list[i]['updateDate'],list[i]['sortDate']);
      note.setNoteid(list[i]['id']);
      noteData.add(note);
    }
    return noteData;
  }

  Future<bool> updateNote(Mynote mynote) async{
    var dbClien = await db;
    int res = await dbClien.update("mynote", mynote.toMap(),where: "id=?",whereArgs: <int>[mynote.id]);
    return res > 0 ? true:false;
  }

  Future<int> deleteNote(Mynote mynote) async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM mynote WHERE id= ?", [mynote.id]);
    return res;
  }
}
