import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preparation_mentale/generated/l10n.dart';
import 'package:preparation_mentale/core/motivation_data.dart';

void main() {
  late MockS loc;
  late MotivationData motivationData;
  setUp(() async {
    loc = MockS();
    motivationData = MotivationData();
    final mockLocale = Locale('fr', 'FR');
    // Normally, this would be handled by Flutter's localization mechanism.
    // But in the test, we'll manually initialize the localization for this locale.
    final localization = await S.delegate.load(mockLocale);

    // Manually build the MotivationData using the French localization
    motivationData.build(localization);

    // // Mock the localization strings
    // when(loc.autonomy_label).thenReturn('AUTONOMIE');
    // when(loc.autonomy_caption).thenReturn('Test caption for autonomy');
    // when(loc.autonomy_recipe).thenReturn('Test recipe for autonomy');
    // when(loc.competence_label).thenReturn('COMPETENCE');
    // when(loc.competence_caption).thenReturn('Test caption for competence');
    // when(loc.competence_recipe).thenReturn('Test recipe for competence');
  });

  group('MotivationData', () {
    test('build method populates french record list correctly', () {
      // Act: Call the build method
      //motivationData.build(loc);

      // Assert: Check that the record list is populated correctly
      expect(motivationData.length, 7); // We expect two items in the list

      final firstItem = motivationData[0];
      expect(firstItem.label, 'AUTONOMIE');
      expect(RegExp(r'^Sur une échelle').hasMatch(firstItem.caption), isTrue);
      expect(RegExp(r'^ajuster les consignes donn').hasMatch(firstItem.recipe), isTrue);

      final secondItem = motivationData[1];
      expect(secondItem.label, 'COMPÉTENCE');
      expect(RegExp(r'^Penses-tu avoir acquis un grand').hasMatch(secondItem.caption), isTrue);
      expect(RegExp(r'^prendre vraiment conscience').hasMatch(secondItem.recipe), isTrue, reason: 'Apprendre is not a valid ${secondItem.recipe}');
    });
    test('MotivationData should correctly load localized strings for English locale', () async {
      // Simulate the loading of English locale
      final mockLocale = Locale('en', 'US');

      // Load English localization
      final localization = await S.delegate.load(mockLocale);

      // Manually build the MotivationData using the English localization
      motivationData.build(localization);

      // Verify that the record is populated with the correct data
      expect(motivationData.record.length, 7); // Assuming you have 2 items
      expect(motivationData.record[0].label, 'AUTONOMY'); // English label for autonomy
      expect(RegExp(r'^On a scale of').hasMatch(motivationData[0].caption), isTrue);
      expect(RegExp(r'^adjust the instructions').hasMatch(motivationData[0].recipe), isTrue);
      expect(motivationData.record[1].label, 'COMPETENCE'); // English label for competence
      expect(RegExp(r'^Do you think you have acquired').hasMatch(motivationData[1].caption), isTrue);
      expect(RegExp(r'^become fully aware').hasMatch(motivationData[1].recipe), isTrue);
    });

  });
}

// Mock the S class (localizations) using mockito or any mocking library
class MockS extends Mock implements S {}

