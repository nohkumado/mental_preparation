import 'package:preparation_mentale/generated/l10n.dart';
import 'package:preparation_mentale/motivation_item.dart';

class MotivationData
{
  List<MotivationItem> record = [];

  get length => record.length;
  operator [](int index) => record[index];

  List<MotivationItem> build(S loc) {
    record =  [
      MotivationItem(
        label: loc.autonomy_label,
        caption: loc.autonomy_caption,
        note: 5,
        commentary: '',
        recipe: loc.autonomy_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.competence_label,
        caption: loc.competence_caption,
        note: 5,
        commentary: '',
        recipe: loc.competence_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.appartenance_label,
        caption: loc.appartenance_caption,
        note: 5,
        commentary: '',
        recipe: loc.appartenance_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.plaisir_label,
        caption: loc.plaisir_caption,
        note: 5,
        commentary: '',
        recipe: loc.plaisir_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.progres_label,
        caption: loc.progres_caption,
        note: 5,
        commentary: '',
        recipe: loc.progres_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.engagement_label,
        caption: loc.engagement_caption,
        note: 5,
        commentary: '',
        recipe: loc.engagement_recipe,
        action: '',
      ),
      MotivationItem(
        label: loc.sens_label,
        caption: loc.sens_caption,
        note: 5,
        commentary: '',
        recipe: loc.sens_recipe,
        action: '',
      ),
    ];
    return record;
  }

  toJson() {

  }

}