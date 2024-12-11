import 'dart:convert';

import 'package:preparation_mentale/core/motivation_data.dart';

import '../ui/motivation_item_labels.dart';
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


  int id = -1;
  //default CTOR
  MotivationState({
    this.id = -1,
    this.name = "",
    this.familyname = "",
    this.sport = "",
    DateTime? date,
    this.empty = true,
    MotivationData? data,
  }) : date = date ?? DateTime.now(), data = data ?? MotivationData();

  @override
  String toString() {
    return 'MotivationState[$id]{name: $name, familyname: $familyname, sport: $sport, date: $date, empty: $empty, data: $data}';
  } // building from incoming map
  String dbIdString() {
    return '[$id]$name $familyname ($sport) @ $date';
  } // building from incoming map
  MotivationState.fromMap(Map<String, dynamic> incoming, {bool autosave = true}) {
    if (incoming.isNotEmpty && incoming.containsKey("nom")) {
      name = incoming["nom"];
      familyname = incoming["prenom"];
      sport = incoming["sport"];

      if (incoming.containsKey("date") && incoming["date"].isNotEmpty) {
        date = DateTime.parse(incoming["date"]);
      }
      if (incoming.containsKey("data") && incoming["data"].isNotEmpty) {
        data = MotivationData.fromMap(incoming["data"]);
      }
      empty = false;

      if (autosave) {
        //save(); //TODO call something or mark this as dirty
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "type": "MotivationState",
      "nom": name,
      "prenom": familyname,
      "sport": sport,
      "date": date.toIso8601String(),
      "data": data.toJson(),
      //TODO missing motivation
      //TODO missing objectives
      //TODO missing confidence
    };
    if(id >= 0) map['id'] = id;
    return map;
  }

  MotivationState copyWith({String? name,
    String? familyname,
    String? sport,
    DateTime? date,
    MotivationData? data, int? id
  })
  {
    return MotivationState(
      id: id?? this.id,
      name: name?? this.name,
      familyname: familyname?? this.familyname,
      sport: sport?? this.sport,
      date: date?? this.date,
      data: data?? this.data,
    );
  }

  static fromJson(String jsonStr) {
    //print("Motivation State fromJson incoming $jsonStr");
    Map<String, dynamic> json = jsonDecode(jsonStr);
    if(!json.containsKey("type") || json["type"] != "MotivationState") {
      //print("MotivationState invalid json $jsonStr for ");
      return MotivationState(name: "invalid");
    }

    try
    {
      //print("success returning state ${json}");
      //print("id ${json['id']}");
      //print("prenom ${json['prenom']}");
      //print("nom ${json['nom']}");
      //print("sport ${json['sport']}");
      //print("date ${DateTime.parse(json["date"])}");
      //print("score ${MotivationData.fromJson(json["data"])}");
      MotivationState res =
      MotivationState(
         id: json['id'] ?? -1,
        name : json["prenom"]??"invalid",
        familyname : json["nom"]??"",
        sport:  json["sport"]??"",
        date : DateTime.parse(json["date"]),
        empty: false,
        data: MotivationData.fromJson(json["data"]),
      );
      return res;
    }
    catch(e)
    {
      print("dejson MotivationState failed!!");
      return MotivationState(name: "invalid");
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
        other.date == date;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    familyname.hashCode ^
    sport.hashCode ^
    date.hashCode ^
    data.hashCode;
  }

  DateTime get normalizedDate => DateTime(date.year, date.month, date.day);

}