import 'dart:convert';

import 'package:preparation_mentale/motivation_data.dart';

enum Henji  {yes, no, maybe,wakaran}
enum Terme  {short, average, long, every, undef}

class MotivationState
{
  String name = "";
  String familyname = "";
  String sport = "";
  DateTime date = DateTime.now();
  bool empty = true;
  MotivationData data = MotivationData();
  //default CTOR
  MotivationState({
    this.name = "",
    this.familyname = "",
    this.sport = "",
    DateTime? date,
    this.empty = true,
    MotivationData? data,
  }) : date = date ?? DateTime.now(), data = data ?? MotivationData();
  // building from incoming map
  MotivationState.fromMap(Map<String, dynamic> incoming, {bool autosave = true}) {
    if (incoming.isNotEmpty && incoming.containsKey("nom")) {
      name = incoming["nom"];
      familyname = incoming["prenom"];
      sport = incoming["sport"];

      if (incoming.containsKey("date") && incoming["date"].isNotEmpty) {
        date = DateTime.parse(incoming["date"]);
      }
      print("OOOOOYYYY Motivation state do something with $incoming.....");

      //data.record.forEach((key, rec) {
      //  if (incoming[key] is Map) {
      //    data[key].note = incoming[key]["note"];
      //    data[key].commentaire = incoming[key]["commentaire"];
      //    if (incoming[key].containsKey("action")) {
      //      data[key].action = incoming[key]["action"];
      //    }
      //  } else {
      //    data[key].note = incoming[key];
      //    data[key].commentaire = incoming["pkoi$key"];
      //  }
      //});

      empty = false;

      if (autosave) {
        //save(); //TODO call something or mark this as doirty
      }
    }
  }

  String toJson() {
    Map<String, dynamic> map = {
      "nom": name,
      "prenom": familyname,
      "sport": sport,
      "date": date.toIso8601String(),
      "data": data.record,
    };
    return json.encode(map);
  }

}