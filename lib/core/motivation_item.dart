import 'package:preparation_mentale/core/motivation_data.dart';

class MotivationItem {
  String label;
  String caption;
  int note;
  String commentary;
  String recipe;
  String action;

  MotivationItem({
    required this.label,
    required this.caption,
    required this.note,
    this.commentary = '',
    required this.recipe,
    this.action = '',
  });

  static fromJson(Map<String, dynamic> json) {
    return MotivationItem(
      label: json['label'] ??"",
      caption: json['caption']??"",
      note: json['note']??-1,
      commentary: json['commentary']??"",
      recipe: json['recipe']??"",
      action: json['action']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'caption': caption,
      'note': note,
      'commentary': commentary,
      'recipe': recipe,
      'action': action,
    };
  }

  @override
  String toString() {
    return 'MotivationItem{label: $label, caption: $caption, note: $note, commentary: $commentary, recipe: $recipe, action: $action}';
  }
}