import 'package:preparation_mentale/generated/l10n.dart';
import 'package:preparation_mentale/core/motivation_item.dart';

enum Motivations {autonomy, competence, belonging, pleasure,progress,engagement, meaning}
class MotivationData
{
  Map<Motivations,MotivationItem> record = {};
   MotivationData() : record = Map.fromEntries(
    Motivations.values.map((motivation) => MapEntry(
      motivation,
      MotivationItem(note: 5, commentary: '', action: '')
    ))
  );

  get length => record.length;

  bool get isEmpty => record.isEmpty;
  operator [](Motivations index) => record[index];


 Map<String, dynamic> toJson() {
  return {
    'record': record.map((key, value) => MapEntry(key.toString().split('.').last, value.toJson())),
  };
}

static MotivationData fromJson(Map<String, dynamic> json) {
  var motivationData = MotivationData();
  if (json['record'] != null) {
    motivationData.record = (json['record'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(
        Motivations.values.firstWhere((e) => e.toString().split('.').last == key),
        MotivationItem.fromJson(value as Map<String, dynamic>)
      );
    });
  }
  return motivationData;
}

  static MotivationData fromMap(Map<String, dynamic> map) {
    MotivationData motivationData = MotivationData();
    if (map['record'] != null) {
      motivationData.record = (map['record'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(
            Motivations.values.firstWhere((e) => e.toString() == 'Motivations.$key'),
            MotivationItem.fromJson(value)
        );
      });
    }
    return motivationData;
  }

  @override
  String toString() {
    StringBuffer res = StringBuffer();
    record.forEach((motivation, item) {
      res.writeln('$motivation: $item');
    });
    return res.toString();
  }

}
