import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'motivation_item.dart';

class StorageService {
  Future<void> saveData(List<MotivationItem> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/motivation_data.json');
    await file.writeAsString(jsonEncode(data.map((e) => e.toJson()).toList()));
  }

  Future<List<MotivationItem>> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/motivation_data.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content).map((e) => MotivationItem.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}

extension JsonConversion on MotivationItem {
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

}