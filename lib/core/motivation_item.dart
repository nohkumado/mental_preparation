import 'package:preparation_mentale/core/motivation_data.dart';

class MotivationItem {
  int note;
  String commentary;
  String action;

  MotivationItem({
    required this.note,
    this.commentary = '',
    this.action = '',
  });

  static fromJson(Map<String, dynamic> json) {
    return MotivationItem(
      note: json['note']??-1,
      commentary: json['commentary']??"",
      action: json['action']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'commentary': commentary,
      'action': action,
    };
  }

  @override
  String toString() {
    return 'MotivationItem{ note: $note, commentary: $commentary, action: $action}';
  }
}

class MotivationItemLabels {
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
}
