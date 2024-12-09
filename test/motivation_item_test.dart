import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/core/motivation_item.dart';

void main() {
  group('MotivationItem', () {
    test('constructor sets fields correctly', () {
      // Arrange
      final motivationItem = MotivationItem(
        label: 'Autonomy',
        caption: 'How autonomous do you feel?',
        note: 8,
        recipe: 'Allow more flexibility',
        action: 'Increase independence',
      );

      // Assert
      expect(motivationItem.label, 'Autonomy');
      expect(motivationItem.caption, 'How autonomous do you feel?');
      expect(motivationItem.note, 8);
      expect(motivationItem.recipe, 'Allow more flexibility');
      expect(motivationItem.action, 'Increase independence');
      expect(motivationItem.commentary, ''); // Default value
    });

    test('fromJson converts JSON correctly', () {
      // Arrange
      final json = {
        'label': 'Autonomy',
        'caption': 'How autonomous do you feel?',
        'note': 8,
        'commentary': 'Some commentary',
        'recipe': 'Allow more flexibility',
        'action': 'Increase independence',
      };

      // Act
      final motivationItem = MotivationItem.fromJson(json);

      // Assert
      expect(motivationItem.label, 'Autonomy');
      expect(motivationItem.caption, 'How autonomous do you feel?');
      expect(motivationItem.note, 8);
      expect(motivationItem.commentary, 'Some commentary');
      expect(motivationItem.recipe, 'Allow more flexibility');
      expect(motivationItem.action, 'Increase independence');
    });

    test('fromJson uses default values for missing fields', () {
      // Arrange
      final json = {
        'label': 'Autonomy',
        'caption': 'How autonomous do you feel?',
        'note': 8,
        'recipe': 'Allow more flexibility',
      };

      // Act
      final motivationItem = MotivationItem.fromJson(json);

      // Assert
      expect(motivationItem.label, 'Autonomy');
      expect(motivationItem.caption, 'How autonomous do you feel?');
      expect(motivationItem.note, 8);
      expect(motivationItem.recipe, 'Allow more flexibility');
      expect(motivationItem.commentary, ''); // Default value
      expect(motivationItem.action, ''); // Default value
    });
  });
}
