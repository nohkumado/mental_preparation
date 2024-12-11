import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/core/motivation_data.dart';
import 'package:preparation_mentale/ui/motivation_item_labels.dart'; // Import the new file

void main() {
  late MotivationData motivationData;
  late Map<Motivations, MotivationItemLabels> labels;

  setUp(() {
    motivationData = MotivationData();
  });

  group('MotivationDataLabel in french', () {
    test('build method populates French record list correctly', () async {
      // Act: Load French localization and get labels
      final frenchLocale = Locale('fr', 'FR');
      labels = await MotivationItemLabels.getLabels(frenchLocale);

      // Assert: Check that the record list is populated correctly
      expect(labels.length, 7);

      final firstItem = labels[Motivations.values.first];
      expect(firstItem!.label, 'AUTONOMIE');
      expect(RegExp(r'^Sur une échelle').hasMatch(firstItem.caption), isTrue);
      expect(RegExp(r'^ajuster les consignes donn').hasMatch(firstItem.recipe), isTrue);

      final secondItem = labels[Motivations.values[1]];
      expect(secondItem!.label, 'COMPÉTENCE');
      expect(RegExp(r'^Penses-tu avoir acquis un grand').hasMatch(secondItem.caption), isTrue);
      expect(RegExp(r'^prendre vraiment conscience').hasMatch(secondItem.recipe), isTrue);
    });

    test('MotivationDataLabel should correctly load localized strings for English locale', () async {
      // Simulate loading of English locale
      final englishLocale = Locale('en', 'US');
      labels = await MotivationItemLabels.getLabels(englishLocale);

      // Assert: Verify that the record is populated with the correct data
      expect(labels.length, 7);
      expect(labels[Motivations.values.first]!.label, 'AUTONOMY');
      expect(RegExp(r'^On a scale of').hasMatch(labels[Motivations.values.first]!.caption), isTrue);
      expect(RegExp(r'^adjust the instructions').hasMatch(labels[Motivations.values.first]!.recipe), isTrue);

      final secondItem = labels[Motivations.values[1]];
      expect(secondItem!.label, 'COMPETENCE');
      expect(RegExp(r'^Do you think you have acquired').hasMatch(secondItem.caption), isTrue);
      expect(RegExp(r'^become fully aware').hasMatch(secondItem.recipe), isTrue);
    });
  });
}
