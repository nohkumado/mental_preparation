import 'dart:ui';

import '../core/motivation_data.dart';
import '../generated/l10n.dart';

class MotivationItemLabels {
  static Map<Motivations,MotivationItemLabels>? labels;
  String label;
  String caption;
  String recipe;

  MotivationItemLabels({
    required this.label,
    required this.caption,
    required this.recipe,
  });


  @override
  String toString() {
    return 'MotivationItem{label: $label, caption: $caption,  recipe: $recipe}';
  }
  /// Returns a map of `MotivationItemLabels` for a given locale.
  static Future<Map<Motivations, MotivationItemLabels>> getLabels(Locale locale) async {
    final locali = await S.delegate.load(locale);
    return initLabels(locali);
  }

  static Map<Motivations,MotivationItemLabels> initLabels(loc)
  {
    labels =  {
      Motivations.autonomy: MotivationItemLabels(
        label: loc.autonomy_label,
        caption: loc.autonomy_caption,
        recipe: loc.autonomy_recipe,
      ),
      Motivations.competence: MotivationItemLabels(
        label: loc.competence_label,
        caption: loc.competence_caption,
        recipe: loc.competence_recipe,
      ),
      Motivations.belonging:MotivationItemLabels(
        label: loc.appartenance_label,
        caption: loc.appartenance_caption,
        recipe: loc.appartenance_recipe,
      ),
      Motivations.pleasure:MotivationItemLabels(
        label: loc.plaisir_label,
        caption: loc.plaisir_caption,
        recipe: loc.plaisir_recipe,
      ),
      Motivations.progress:MotivationItemLabels(
        label: loc.progres_label,
        caption: loc.progres_caption,
        recipe: loc.progres_recipe,
      ),
      Motivations.engagement:MotivationItemLabels(
        label: loc.engagement_label,
        caption: loc.engagement_caption,
        recipe: loc.engagement_recipe,
      ),
      Motivations.meaning:MotivationItemLabels(
        label: loc.sens_label,
        caption: loc.sens_caption,
        recipe: loc.sens_recipe,
      ),
    };
    return labels!;
  }
}