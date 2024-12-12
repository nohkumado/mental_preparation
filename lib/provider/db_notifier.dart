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
    //if (version >= 2) {
    //await db.execute('ALTER TABLE motivation_state ADD COLUMN new_field TEXT');
    //}
  }

 // Future<void> removeDoubles(Database db) async {
 //   await db.execute('''
 // DELETE FROM motivation_state
 // WHERE rowid NOT IN (
 // SELECT MIN(rowid)
 // FROM motivation_state
 // GROUP BY name, familyname, sport, date
 // );
 //   ''');
 // }
  Future<void> removeDoubles(Database db) async {
     print("Before removing duplicates:");
  print(await db.rawQuery('SELECT * FROM motivation_state'));

  await db.execute('''
  DELETE FROM motivation_state
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM motivation_state
    GROUP BY name, familyname, sport, 
             strftime('%Y-%m-%d %H', datetime(date)) || ':' || 
             (cast(strftime('%M', datetime(date)) as integer) / 15 * 15)
  );
  ''');

  print("After removing duplicates:");
  print(await db.rawQuery('SELECT * FROM motivation_state'));
}

  Future<int> insertMotivationState(MotivationState state) async {
    if(state.id >= 0) return upsertMotivationState(state);
    DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm");

    final db = await database;
    // Round the date to the nearest 15-minute interval
  DateTime roundedDate = roundToNearest15Minutes(state.date);
  String formattedDate = formatter.format(roundedDate);

 // Check if a record with the same name, familyname, sport, and date already exists
  final List<Map<String, dynamic>> existingRecords = await db.query(
    'motivation_state',
    where: '''name = ? AND familyname = ? AND sport = ? AND datetime(date) 
        BETWEEN datetime(?, '-10 minutes') AND datetime(?, '+10 minutes')''',
    whereArgs: [state.name, state.familyname, state.sport, formattedDate, formattedDate],
  );

  if (existingRecords.isNotEmpty) {
     if(existingRecords.length >1) await removeDoubles(db);
    // If a record exists, perform an upsert
    return upsertMotivationState(state);
  }




    Map<String,dynamic> toSave;
    try {
      toSave = {
        'name': state.name,
        'familyname': state.familyname,
        'sport': state.sport,
        'date': formatter.format(state.date),
        'data': jsonEncode(state.toJson()),
      };
    }
    catch(e) {
      print("Error while trying to encode $state : $e");
      return -1;
    }
    final id = await db.insert('motivation_state', toSave );
    return id;
  }
Future<int> upsertMotivationState(MotivationState state) async {
  final db = await database;
  DateFormat formatter = DateFormat("yyyy-MM-dd");

  // Prepare the data to be inserted/updated
  final Map<String, dynamic> row = {
    'name': state.name,
    'familyname': state.familyname,
    'sport': state.sport,
    'date': formatter.format(state.date),
    'data': jsonEncode(state.toJson()),
  };

  // Try to update first
  int updatedRows = await db.update(
    'motivation_state',
    row,
    where: 'name = ? AND familyname = ? AND sport = ? AND date = ?',
    whereArgs: [state.name, state.familyname, state.sport, formatter.format(state.date)],
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
    MotivationState.shortPrint = true;
    final db = await database;
    //final List<Map<String, dynamic>> maps = await db.query('motivation_state');
    var query = await db.query('motivation_state');
    List<Map<String, dynamic>> maps = query;
    //print("retrieved from DB : $maps");

    List<MotivationState> res = [];
    for (var map in maps) {
      print("unpacking[${map['id']}]: ${map['data']} v:${map['data'] == null?'$map':''}");
      MotivationState packed = map['data'] != null? MotivationState.fromJson(map['data']):MotivationState();
      packed.complete(map);
      if(packed.name == "invalid")
      {
        db.delete("motivation_state", where: "id = ?", whereArgs: [map["id"]]);
        continue; // Skip items based on the condition
      }
      //print("got: $packed, completing with rest");
      packed.complete(map);
      //print("result: $packed");
      res.add(packed);
    }
    print("returning $res");
    return res;
  }

  DateTime roundToNearest15Minutes(DateTime dt)
  {
    return DateTime(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      (dt.minute ~/ 15) * 15,
    );
  }


}
