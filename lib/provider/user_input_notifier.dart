import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preparation_mentale/core/motivation_state.dart';

enum  txtFields { comment, action}
class UserInputNotifier extends StateNotifier<MotivationState> {
  UserInputNotifier() : super(MotivationState());

  void updateName(String name) { state = state.copyWith(name: name); }
  void updateFamilyname(String value) { state = state.copyWith(familyname: value); }
  void updateSport(String value) { state = state.copyWith(sport: value); }
  void update(MotivationState newValue) {
    state = state.copyWith(name: newValue.name, familyname: newValue.familyname, sport: newValue.sport, date: newValue.date, data: newValue.data);
  }

  // Method to save user input to the database
  Future<void> saveToDatabase() async {
    // ... database operations
  }

  void chgNote(int index, int val)
  {
    state.data.record[index].note = val;
    state = state.copyWith();
  }

  void chgText({required int i, txtFields type = txtFields.comment, required String val})
  {
    if(type == txtFields.comment) state.data.record[i].commentary = val;
    else if(type == txtFields.action) state.data.record[i].action = val;
  }



}
