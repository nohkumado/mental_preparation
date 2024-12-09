import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    print("About to insert : $state");
    final db = await database;
    return await db.insert('motivation_state', {
      'name': state.name,
      'familyname': state.familyname,
      'sport': state.sport,
      'date': state.date.toIso8601String(),
      'data': jsonEncode(state.toJson()),
    });
  }
Future<int> upsertMotivationState(MotivationState state) async {
  final db = await database;

  // Prepare the data to be inserted/updated
  final Map<String, dynamic> row = {
    'name': state.name,
    'familyname': state.familyname,
    'sport': state.sport,
    'date': state.date.toIso8601String(),
    'data': jsonEncode(state.data.toJson()),
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

    List<MotivationState> res =
    List.generate(maps.length, (i) {
      MotivationState packed =  MotivationState.fromJson(maps[i]['data']);
      packed.complete(maps[i]);

      return packed;
    });
    return res;
  }


}
