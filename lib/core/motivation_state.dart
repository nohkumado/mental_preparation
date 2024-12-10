import 'dart:convert';

import 'package:preparation_mentale/core/motivation_data.dart';
import 'package:preparation_mentale/generated/l10n.dart';

import 'motivation_item.dart';


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

  Map<Motivations,MotivationItemLabels>? labels;
  //default CTOR
  MotivationState({
    this.name = "",
    this.familyname = "",
    this.sport = "",
    DateTime? date,
    this.empty = true,
    MotivationData? data,
  }) : date = date ?? DateTime.now(), data = data ?? MotivationData();

  @override
  String toString() {
    return 'MotivationState{name: $name, familyname: $familyname, sport: $sport, date: $date, empty: $empty, data: $data}';
  } // building from incoming map
  @override
  String dbIdString() {
    return '$name $familyname ($sport) @ $date';
  } // building from incoming map
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
        //save(); //TODO call something or mark this as dirty
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
      //TODO missing motivation
      //TODO missing objectives
      //TODO missing confidence
    };
    return json.encode(map);
  }

  MotivationState copyWith({String? name,
    String? familyname,
    String? sport,
    DateTime? date,
    MotivationData? data
  })
  {
    return MotivationState(
      name: name?? this.name,
      familyname: familyname?? this.familyname,
      sport: sport?? this.sport,
      date: date?? this.date,
      data: data?? this.data,
    );
  }

  static fromJson(String json) {
    var incom = jsonDecode(json);
    if(incom is Map<String,dynamic>)
    {

      Map<String, dynamic> map = jsonDecode(json);
      DateTime date;
      MotivationData data;
      bool empty = false;
      try
      {
        date = DateTime.parse(map["date"]);
        data = MotivationData.fromMap(map["data"]);
      }
      catch(e)
      {
        date = DateTime.now();
        data = MotivationData();
        empty = true;
      }
      return MotivationState(
        name : map["prenom"],
        familyname : map["name"],
        sport:  map["sport"],
        date : date,
        empty: empty,
        data: data,
      );
    }
    else
    {
      return MotivationState();
    }


  }

  void complete(Map<String, dynamic> map)
  {
    if(map.containsKey('name') && name.isEmpty) {
      name = map['name'];
      if(map.containsKey('familyname') && familyname.isEmpty) familyname = map['familyname'];
      if(map.containsKey('sport') && sport.isEmpty) sport = map['sport'];
      date = DateTime.parse(map['date']);
    }
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MotivationState &&
        other.name == name &&
        other.familyname == familyname &&
        other.sport == sport &&
        other.date == date &&
        other.data == data;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    familyname.hashCode ^
    sport.hashCode ^
    date.hashCode ^
    data.hashCode;
  }

  Map<Motivations,MotivationItemLabels> initLabels(loc)
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