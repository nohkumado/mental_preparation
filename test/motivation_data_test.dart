
import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/core/motivation_item.dart';
import 'package:preparation_mentale/core/motivation_data.dart';

void main() {
  group('MotivationData', () {
    test('Initialization creates a complete record with default values', () {
      // Act
      final motivationData = MotivationData();

      // Assert
      expect(motivationData.length, Motivations.values.length);
      for (var motivation in Motivations.values) {
        expect(motivationData[motivation], isA<MotivationItem>());
        expect(motivationData[motivation].note, 5);
        expect(motivationData[motivation].commentary, '');
        expect(motivationData[motivation].action, '');
      }
    });

    test('toJson produces the correct JSON structure', () {
      // Arrange
      final motivationData = MotivationData();

      // Act
      final json = motivationData.toJson();

      // Assert
      expect(json['type'], 'MotivationData');
      expect(json['record'], isA<Map<String, dynamic>>());
      for (var motivation in Motivations.values) {
        expect(json['record'][motivation.toString().split('.').last], isNotNull);
      }
    });

    test('fromJson reconstructs MotivationData from valid JSON', () {
      // Arrange
      final original = MotivationData();
      final json = original.toJson();

      // Act
      final reconstructed = MotivationData.fromJson(json);

      // Assert
      expect(reconstructed.length, original.length);
      for (var motivation in Motivations.values) {
        expect(reconstructed[motivation].note, original[motivation].note);
        expect(reconstructed[motivation].commentary, original[motivation].commentary);
        expect(reconstructed[motivation].action, original[motivation].action);
      }
    });

    test('fromJson throws an exception for invalid JSON', () {
      // Arrange
      final invalidJson = {'type': 'InvalidType', 'record': {}};

      // Assert
      expect(() => MotivationData.fromJson(invalidJson), throwsException);
    });

    test('fromMap reconstructs MotivationData from a valid map', () {
      // Arrange
      final original = MotivationData();
      final map = {
        'record': original.record.map((key, value) =>
            MapEntry(key.toString().split('.').last, value.toJson())),
      };

      // Act
      final reconstructed = MotivationData.fromMap(map);

      // Assert
      expect(reconstructed.length, original.length);
      for (var motivation in Motivations.values) {
        expect(reconstructed[motivation].note, original[motivation].note);
        expect(reconstructed[motivation].commentary, original[motivation].commentary);
        expect(reconstructed[motivation].action, original[motivation].action);
      }
    });

    test('length and isEmpty work correctly', () {
      // Arrange
      final motivationData = MotivationData();

      // Assert
      expect(motivationData.length, Motivations.values.length);
      expect(motivationData.isEmpty, isFalse);
    });

    test('toString produces a human-readable string representation', () {
      // Arrange
      final motivationData = MotivationData();

      // Act
      final stringRepresentation = motivationData.toString();

      // Assert
      for (var motivation in Motivations.values) {
        expect(stringRepresentation, contains(motivation.toString()));
      }
    });
  });
}
