
import 'motivation_data.dart';

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
    if(json.containsKey('type') && json['type'] == 'MotivationItem') {
      return MotivationItem(
        note: json['note'] ?? -1,
        commentary: json['commentary'] ?? "",
        action: json['action'] ?? "",
      );
    }
    return MotivationItem(note: -1);
  }

  Map<String, dynamic> toJson() {
    return {
      'type' : 'MotivationItem',
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



