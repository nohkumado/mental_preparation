import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preparation_mentale/core/motivation_item.dart';
import 'package:preparation_mentale/generated/l10n.dart';
import 'package:preparation_mentale/core/motivation_data.dart';

void main() {
  late MockS loc;
  late MotivationData motivationData;
  late Map<Motivations, MotivationItemLabels> labels;
  setUp(() async {
    loc = MockS();
    motivationData = MotivationData();
    final mockLocale = Locale('fr', 'FR');
    // Normally, this would be handled by Flutter's localization mechanism.
    // But in the test, we'll manually initialize the localization for this locale.
    final locali= await S.delegate.load(mockLocale);

    // Manually build the MotivationData using the French localialization
    //motivationData.build(localialization);
    labels =  {
      Motivations.autonomy: MotivationItemLabels(
        label: locali.autonomy_label,
        caption: locali.autonomy_caption,
        recipe: locali.autonomy_recipe,
      ),
      Motivations.competence: MotivationItemLabels(
        label: locali.competence_label,
        caption: locali.competence_caption,
        recipe: locali.competence_recipe,
      ),
      Motivations.belonging:MotivationItemLabels(
        label: locali.appartenance_label,
        caption: locali.appartenance_caption,
        recipe: locali.appartenance_recipe,
      ),
      Motivations.pleasure:MotivationItemLabels(
        label: locali.plaisir_label,
        caption: locali.plaisir_caption,
        recipe: locali.plaisir_recipe,
      ),
      Motivations.progress:MotivationItemLabels(
        label: locali.progres_label,
        caption: locali.progres_caption,
        recipe: locali.progres_recipe,
      ),
      Motivations.engagement:MotivationItemLabels(
        label: locali.engagement_label,
        caption: locali.engagement_caption,
        recipe: locali.engagement_recipe,
      ),
      Motivations.meaning:MotivationItemLabels(
        label: locali.sens_label,
        caption: locali.sens_caption,
        recipe: locali.sens_recipe,
      ),
    };
  });

  group('MotivationData', () {
    test('build method populates french record list correctly', () {
      // Act: Call the build method
      //motivationData.build(loc);

      // Assert: Check that the record list is populated correctly
      expect(motivationData.length, 7); // We expect two items in the list

      final firstItem = labels[Motivations.values.first];
      expect(firstItem!.label, 'AUTONOMIE');
      expect(RegExp(r'^Sur une échelle').hasMatch(firstItem.caption), isTrue);
      expect(RegExp(r'^ajuster les consignes donn').hasMatch(firstItem.recipe), isTrue);

      final secondItem = labels[Motivations.values[1]];
      expect(secondItem!.label, 'COMPÉTENCE');
      expect(RegExp(r'^Penses-tu avoir acquis un grand').hasMatch(secondItem.caption), isTrue);
      expect(RegExp(r'^prendre vraiment conscience').hasMatch(secondItem.recipe), isTrue, reason: 'Apprendre is not a valid ${secondItem.recipe}');
    });
    test('MotivationData should correctly load localized strings for English locale', () async {
      // Simulate the loading of English locale
      final mockLocale = Locale('en', 'US');

      // Load English localization
      final locali= await S.delegate.load(mockLocale);
      labels =  {
        Motivations.autonomy: MotivationItemLabels(
          label: locali.autonomy_label,
          caption: locali.autonomy_caption,
          recipe: locali.autonomy_recipe,
        ),
        Motivations.competence: MotivationItemLabels(
          label: locali.competence_label,
          caption: locali.competence_caption,
          recipe: locali.competence_recipe,
        ),
        Motivations.belonging:MotivationItemLabels(
          label: locali.appartenance_label,
          caption: locali.appartenance_caption,
          recipe: locali.appartenance_recipe,
        ),
        Motivations.pleasure:MotivationItemLabels(
          label: locali.plaisir_label,
          caption: locali.plaisir_caption,
          recipe: locali.plaisir_recipe,
        ),
        Motivations.progress:MotivationItemLabels(
          label: locali.progres_label,
          caption: locali.progres_caption,
          recipe: locali.progres_recipe,
        ),
        Motivations.engagement:MotivationItemLabels(
          label: locali.engagement_label,
          caption: locali.engagement_caption,
          recipe: locali.engagement_recipe,
        ),
        Motivations.meaning:MotivationItemLabels(
          label: locali.sens_label,
          caption: locali.sens_caption,
          recipe: locali.sens_recipe,
        ),
      };

      // Manually build the MotivationData using the English localization

      // Verify that the record is populated with the correct data
      expect(motivationData.record.length, 7); // Assuming you have 2 items
      expect(labels[Motivations.values.first]!.label, 'AUTONOMY'); // English label for autonomy
      expect(RegExp(r'^On a scale of').hasMatch(labels[Motivations.values.first]!.caption), isTrue);
      expect(RegExp(r'^adjust the instructions').hasMatch(labels[Motivations.values.first]!.recipe), isTrue);
      expect(labels[Motivations.values[1]]!.label, 'COMPETENCE'); // English label for competence
      expect(RegExp(r'^Do you think you have acquired').hasMatch(motivationData[Motivations.values[1]].caption), isTrue);
      expect(RegExp(r'^become fully aware').hasMatch(motivationData[Motivations.values[1]].recipe), isTrue);
    });

  });
}

// Mock the S class (localizations) using mockito or any mocking library
class MockS extends Mock implements S {}

