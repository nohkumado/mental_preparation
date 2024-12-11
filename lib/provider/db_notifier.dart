import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:preparation_mentale/core/motivation_state.dart';
import 'package:sqflite/sqflite.dart';

class DbNotifier extends StateNotifier<AsyncValue<MotivationState>> {
  Database? _database;
  String dbUrl = 'motivation_database.db';

  DbNotifier({String url = 'motivation_database.db'}) : super(const AsyncValue.loading()) {
    dbUrl = url;
  }


Future<Database> get database async {
    if (_database != null) {
      await _createDb(_database!, 1);
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(),dbUrl );
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS motivation_state(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        familyname TEXT,
        sport TEXT,
        date TEXT,
        data TEXT
      )
    ''');
  }

  Future<int> insertMotivationState(MotivationState state) async {
    if(state.id >= 0) return upsertMotivationState(state);
    print("About to INSERT : $state");
    final db = await database;
    //DateFormat formater = DateFormat("yyyy-MM-dd");
    Map<String,dynamic> toSave;
    try {
      toSave = {
        'name': state.name,
        'familyname': state.familyname,
        'sport': state.sport,
        //'date': formater.format(state.date),
        'date': state.date,
        'data': jsonEncode(state.toJson()),
      };
    }
    catch(e) {
      print("Error while trying to encode $state : $e");
      return -1;
    }
    print("################# saving $toSave ");
    final id = await db.insert('motivation_state', toSave );
    print("Insertion yielded $id");
    return id;
  }
Future<int> upsertMotivationState(MotivationState state) async {
  print("About to UPSERT $state");
  final db = await database;
  DateFormat formater = DateFormat("yyyy-MM-dd");

  // Prepare the data to be inserted/updated
  final Map<String, dynamic> row = {
    'name': state.name,
    'familyname': state.familyname,
    'sport': state.sport,
    'date': formater.format(state.date),
    'data': jsonEncode(state.toJson()),
  };

  // Try to update first
  int updatedRows = await db.update(
    'motivation_state',
    row,
    where: 'name = ? AND familyname = ? AND sport = ? AND date = ?',
    whereArgs: [state.name, state.familyname, state.sport, state.date.toIso8601String()],
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // If no rows were updated, perform an insert
  if (updatedRows == 0) {
    return await db.insert(
      'motivation_state',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Return the number of updated rows
  return updatedRows;
}
  Future<List<MotivationState>> getAllMotivationStates() async {
    final db = await database;
    //final List<Map<String, dynamic>> maps = await db.query('motivation_state');
    var query = await db.query('motivation_state');
    List<Map<String, dynamic>> maps = query;
    //print("retrieved from DB : $maps");

    //List<MotivationState> res =
    //List.generate(maps.length, (i) {
    //  print("entpacking : ${maps[i]['data']}");
    //  MotivationState packed =  MotivationState.fromJson(maps[i]['data']);
    //  if(packed.name == "invalid")
    //    {
    //      print("Excluding record $maps , need to remove id: ${maps[i]["id"]}");
    //      continue;
    //    }
    //  print("got : ${packed} completing with rest");
    //  packed.complete(maps[i]);
    //  print("result : ${packed}");
    //  return packed;
    //});
    List<MotivationState> res = [];
    for (var map in maps) {
      //print("unpacking: ${map['data']}");
      MotivationState packed = MotivationState.fromJson(map['data']);
      packed.complete(map);
      if(packed.name == "invalid")
      {
        //print("Excluding record: $packed");
        //print("Excluding from $maps , need to remove id: ${map["id"]}");
        db.delete("motivation_state", where: "id = ?", whereArgs: [map["id"]]);
        continue; // Skip items based on the condition
      }
      //print("got: $packed, completing with rest");
      packed.complete(map);
      //print("result: $packed");
      res.add(packed);
    }
    //print("returning $res");
    return res;
  }


}
