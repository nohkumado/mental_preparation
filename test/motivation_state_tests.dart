import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/core/motivation_state.dart';
import 'package:preparation_mentale/core/motivation_data.dart';

void main() {
  group('MotivationState', () {
    test('Default constructor initializes correctly', () {
      // Act
      final state = MotivationState();

      // Assert
      expect(state.name, "");
      expect(state.familyname, "");
      expect(state.sport, "");
      expect(state.empty, true);
      expect(state.data, isA<MotivationData>());
      expect(state.id, -1);
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange
      final original = MotivationState(name: "John", familyname: "Doe", sport: "Soccer");

      // Act
      final copy = original.copyWith(name: "Jane");

      // Assert
      expect(copy.name, "Jane");
      expect(copy.familyname, "Doe");
      expect(copy.sport, "Soccer");
      expect(copy.id, original.id); // ID remains unchanged
    });

    test('toJson produces correct JSON', () {
      // Arrange
      final specificDate = DateTime(2023, 11, 25);
      final state = MotivationState(name: "John", familyname: "Doe", sport: "Soccer", date: specificDate);

      // Act
      final json = state.toJson();

      // Assert
      expect(json['type'], "MotivationState");
      expect(json['nom'], "John");
      expect(json['prenom'], "Doe");
      expect(json['sport'], "Soccer");
      expect(json['date'], isNotNull); // Date is serialized
      expect(json['data'], isA<Map<String, dynamic>>());
      String result = '{"type":"MotivationState","nom":"John","prenom":"Doe","sport":"Soccer","date":"2023-11-25T00:00:00.000","data":{"type":"MotivationData","record":{"autonomy":{"type":"MotivationItem","note":5,"commentary":"","action":""},"competence":{"type":"MotivationItem","note":5,"commentary":"","action":""},"belonging":{"type":"MotivationItem","note":5,"commentary":"","action":""},"pleasure":{"type":"MotivationItem","note":5,"commentary":"","action":""},"progress":{"type":"MotivationItem","note":5,"commentary":"","action":""},"engagement":{"type":"MotivationItem","note":5,"commentary":"","action":""},"meaning":{"type":"MotivationItem","note":5,"commentary":"","action":""}}}}';
      expect(jsonEncode(json),result,reason: 'json encode ${jsonEncode(json)} failed $result');
    });

    test('fromJson reconstructs a valid MotivationState', () {
      // Arrange
      final json = '''
      {
        "type": "MotivationState",
        "prenom": "John",
        "nom": "Doe",
        "sport": "Soccer",
        "date": "2024-12-10T19:16:21.710003",
        "data": {"type":"MotivationData","record":{"autonomy":{"type":"MotivationItem","note":5,"commentary":"","action":""},"competence":{"type":"MotivationItem","note":5,"commentary":"","action":""},"belonging":{"type":"MotivationItem","note":5,"commentary":"","action":""},"pleasure":{"type":"MotivationItem","note":5,"commentary":"","action":""},"progress":{"type":"MotivationItem","note":5,"commentary":"","action":""},"engagement":{"type":"MotivationItem","note":5,"commentary":"","action":""},"meaning":{"type":"MotivationItem","note":5,"commentary":"","action":""}}}
      }
      ''';

      // Act
      final state = MotivationState.fromJson(json);

      // Assert
      expect(state.familyname, "Doe"); // Note: field mapping seems reversed
      expect(state.name, "John");
      expect(state.sport, "Soccer");
      expect(state.empty, false); // Data is provided
      expect(state.date, DateTime.parse("2024-12-10T19:16:21.710003"));
    });

    test('fromJson handles invalid JSON gracefully', () {
      // Arrange
      final invalidJson = '''
      {
        "type": "InvalidType",
        "data": {}
      }
      ''';

      // Act
      final state = MotivationState.fromJson(invalidJson);

      // Assert
      expect(state.name, "invalid"); // Default for invalid state
    });

    test('fromMap reconstructs MotivationState correctly', () {
      // Arrange
      final map = {
        "nom": "John",
        "prenom": "Doe",
        "sport": "Soccer",
        "date": "2024-12-10T19:16:21.710003",
        "data": {}
      };

      // Act
      final state = MotivationState.fromMap(map);

      // Assert
      expect(state.name, "John");
      expect(state.familyname, "Doe");
      expect(state.sport, "Soccer");
      expect(state.date, DateTime.parse("2024-12-10T19:16:21.710003"));
    });

    test('complete updates empty fields', () {
      // Arrange
      final state = MotivationState(name: "", familyname: "", sport: "");
      final map = {
        "name": "John",
        "familyname": "Doe",
        "sport": "Soccer",
        "date": "2024-12-10T19:16:21.710003",
      };

      // Act
      state.complete(map);

      // Assert
      expect(state.name, "John");
      expect(state.familyname, "Doe");
      expect(state.sport, "Soccer");
      expect(state.date, DateTime.parse("2024-12-10T19:16:21.710003"));
    });

    test('toString produces human-readable output', () {
      // Arrange
      final state = MotivationState(name: "John", familyname: "Doe", sport: "Soccer");

      // Act
      final stringRepresentation = state.toString();

      // Assert
      expect(stringRepresentation, contains("name: John"));
      expect(stringRepresentation, contains("familyname: Doe"));
      expect(stringRepresentation, contains("sport: Soccer"));
    });

    test('dbIdString formats state correctly', () {
      final specificDate = DateTime(2023, 11, 25);
      // Arrange
      final state = MotivationState(id: 42, name: "John", familyname: "Doe", sport: "Soccer", date: specificDate);

      // Act
      final dbIdString = state.dbIdString();

      // Assert
      expect(dbIdString, "[42]John Doe (Soccer) @ 2023-11-25 00:00:00.000");
    });

    test('equality works as expected', () {
      final specificDate = DateTime(2023, 11, 25);
      // Arrange
      final state1 = MotivationState(name: "John", familyname: "Doe", date: specificDate);
      final state2 = MotivationState(name: "John", familyname: "Doe", date: specificDate);
      final state4 = MotivationState(name: "John", familyname: "Doe");
      final state3 = MotivationState(name: "Jane", familyname: "Doe", date: specificDate);

      // Assert
      expect(state1, equals(state2) , reason: "state1 and 2 should be same but aren't??");
      expect(state1, isNot(equals(state3)));
      expect(state1, isNot(equals(state4)));
    });

    test('hashCode is consistent with equality', () {
      final specificDate = DateTime(2023, 11, 25);
      final specificData = MotivationData(); // Assuming MotivationData has a
      // Arrange
      final state1 = MotivationState(name: "John", familyname: "Doe", date: specificDate, data: specificData);
      final state2 = MotivationState(name: "John", familyname: "Doe", date: specificDate, data: specificData);

      // Assert
      expect(state1.hashCode, equals(state2.hashCode));
    });
  });
}

