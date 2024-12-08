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
      label: json['label'],
      caption: json['caption'],
      note: json['note'],
      commentary: json['commentary'],
      recipe: json['recipe'],
      action: json['action'],
    );
  }
}