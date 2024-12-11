import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/core/motivation_item.dart';

void main() {
  group('MotivationItem', () {
    test('constructor sets fields correctly', () {
      // Arrange
      final motivationItem = MotivationItem(
        note: 8,
        action: 'Increase independence',
      );

      // Assert
      expect(motivationItem.note, 8);
      expect(motivationItem.action, 'Increase independence');
      expect(motivationItem.commentary, ''); // Default value
    });

    test('fromJson converts JSON correctly', () {
      // Arrange
      final json = {
        'type' : 'MotivationItem',
        'label': 'Autonomy',
        'caption': 'How autonomous do you feel?',
        'note': 8,
        'commentary': 'Some commentary',
        'recipe': 'Allow more flexibility',
        'action': 'Increase independence',
      };

      // Act
      final motivationItem = MotivationItem.fromJson(json);
      if(motivationItem.note == -1) print("AAAYYYEEEHHH invalid Item°!!!!");

      // Assert
      expect(motivationItem.note, 8);
      expect(motivationItem.commentary, 'Some commentary');
      expect(motivationItem.action, 'Increase independence');
    });

    test('fromJson uses default values for missing fields', () {
      // Arrange
      final json = {
        'type' : 'MotivationItem',
        'label': 'Autonomy',
        'caption': 'How autonomous do you feel?',
        'note': 8,
        'recipe': 'Allow more flexibility',
      };

      // Act
      final motivationItem = MotivationItem.fromJson(json);
      if(motivationItem.note == -1) print("AAAYYYEEEHHH invalid 2nd Item°!!!!");

      // Assert
      expect(motivationItem.note, 8);
      expect(motivationItem.commentary, ''); // Default value
      expect(motivationItem.action, ''); // Default value
    });
  });
}
