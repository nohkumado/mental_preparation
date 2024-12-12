import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:preparation_mentale/provider/db_notifier.dart';
import 'package:preparation_mentale/core/motivation_state.dart';

// Mock Database
class MockDatabase extends Mock implements Database {}

void main() {
  late DbNotifier dbNotifier;
  late MockDatabase mockDatabase;
  late Database db;

  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Set global factory
    databaseFactory = databaseFactoryFfi;
     dbNotifier = DbNotifier(url: inMemoryDatabasePath);
    db = await dbNotifier.initDatabase();
  });

  setUp(() async {
    mockDatabase = MockDatabase();
    //dbNotifier = DbNotifier(url: inMemoryDatabasePath);
    await db.delete('motivation_state');
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM motivation_state'));
  print('Database cleared. Row count: $count');
  });

  tearDownAll(() async {
    await db.close();
  });

  test('initDatabase creates database', () async {
    //final db = await dbNotifier.initDatabase();
    expect(db, isA<Database>());
  // Optionally, check that the table is empty
  final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM motivation_state'));
  expect(count, 0,reason: 'Database should be empty at the start of the test');
  });

  test('insertMotivationState inserts data correctly', () async {
    final state = MotivationState(
      name: 'John',
      familyname: 'Doe',
      sport: 'Running',
      date: DateTime.now(),
    );

    final id = await dbNotifier.insertMotivationState(state);
    expect(id, greaterThan(0));
  });

  test('getAllMotivationStates retrieves data correctly', () async {
    // Insert some test data
    final state1 = MotivationState(
      name: 'John',
      familyname: 'Doe',
      sport: 'Running',
      date: DateTime.now(),
    );
    final state2 = MotivationState(
      name: 'Jane',
      familyname: 'Doe',
      sport: 'Swimming',
      date: DateTime.now(),
    );

    await dbNotifier.insertMotivationState(state1);
    await dbNotifier.insertMotivationState(state2);

    final states = await dbNotifier.getAllMotivationStates();
    expect(states.length, 2);
    expect(states[0].name, 'John', reason: 'First state should be John : ${states[0]}');
    expect(states[1].name, 'Jane');
  });

  test('_removeDoubles removes duplicate records', () async {
    final db = await dbNotifier.database;

    // Insert duplicate records
    await db.insert('motivation_state', {'name': 'John', 'familyname': 'Doe', 'sport': 'Running', 'date': '2023-01-01'});
    await db.insert('motivation_state', {'name': 'John', 'familyname': 'Doe', 'sport': 'Running', 'date': '2023-01-01'});

    await dbNotifier.removeDoubles(db);

    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM motivation_state'));
    expect(count, 1);
  });


}
