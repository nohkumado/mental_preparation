import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'motivation_item.dart';
import 'motivation_state.dart';

class StorageService {
  Future<void> saveData(List<MotivationItem> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/motivation_data.json');
    await file.writeAsString(jsonEncode(data.map((e) => e.toJson()).toList()));
  }
   Future<void>  saveCandidate({String basename = "saved", required MotivationState person})
  async {
    Directory directory = Directory(basename);
    if(directory.existsSync() )
    {
      StringBuffer filename = StringBuffer('${directory.path}/');
      filename.write('${person.name.toLowerCase()}_${person.familyname.toLowerCase()}');
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      filename.write('${formatter.format(person.date)}.json');

      final file = File('$filename');
      await file.writeAsString(jsonEncode(person.toJson()));
    }//if(is_writable($filename))
    else print("can't write to dir<br>\n");
  }//function save()

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