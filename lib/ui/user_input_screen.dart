import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../core/motivation_state.dart';
import '../generated/l10n.dart';
import '../rp_provider.dart';

class UserInputScreen extends ConsumerStatefulWidget {
  const UserInputScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserInputScreenState();
}
class _UserInputScreenState extends ConsumerState<UserInputScreen> {
  Map<String, TextEditingController> controllers =  {};



@override
void initState() {
  super.initState();
  final userState = ref.read(userInputProvider);
  controllers["name"] = TextEditingController(text: userState.name);
  controllers["familyname"] = TextEditingController(text: userState.familyname);
  controllers["sport"] = TextEditingController(text: userState.sport);


}

  @override
  void dispose() {
    for(TextEditingController ctrl in controllers.values){ ctrl.dispose(); }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  //print("Rebuilding UserInputScreen");
    MotivationState userState = ref.watch(userInputProvider);
    final dbState = ref.watch(dataBaseProvider);
    final motivationStatesAsync = ref.watch(motivationStatesProvider);
    return  Column(
      children: [
        TextField(
          controller: controllers["name"],
          onChanged: (value) => ref.read(userInputProvider.notifier).updateName(value),
          decoration: InputDecoration(labelText: S.of(context).name_label),
        ),
        TextField(
          controller: controllers["familyname"],
          onChanged: (value) => ref.read(userInputProvider.notifier).updateFamilyname(value),
          decoration: InputDecoration(labelText: S.of(context).family_name_label),
        ),
        TextField(
          controller: controllers["sport"],
          onChanged: (value) => ref.read(userInputProvider.notifier).updateSport(value),
          decoration: InputDecoration(labelText: S.of(context).sport),
        ),
        const SizedBox(height: 16.0),
        Text(intl.DateFormat.yMd().format(userState.date ?? DateTime.now())),
        ElevatedButton(
          onPressed: () async {

            if (_validateForm(userState)) {
              _submitToDatabase(ref:ref, state:userState, context:context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).form_validation_error)),
              );
            }
            // Save user data to database (use databaseProvider)
            final db = ref.read(dataBaseProvider);
            // ... database interaction code to save user
          },
          child: Text(S.of(context).save),
        ),
        // Dropdown for existing users
        motivationStatesAsync.when(
          data: (motivationStates) {
            if(userState.empty && motivationStates.isNotEmpty){
              userState = motivationStates.first;
            }
            return DropdownButton<MotivationState>(
            hint: Text(S.of(context).select_user),
            value: userState,
            onChanged: (MotivationState? newValue) {
              if (newValue != null) {
                // Listen to state changes and update controllers
                controllers["name"]?.text = newValue.name;
                controllers["familyname"]?.text = newValue.familyname;
                controllers["sport"]?.text = newValue.sport;
                if(newValue.labels == null || newValue.labels!.isEmpty){
                  newValue.initLabels(S.of(context));
                }
                ref.read(userInputProvider.notifier).update(newValue);
                ref.read(dataBaseProvider.notifier).upsertMotivationState(newValue);
              }
            },
            items: motivationStates.map<DropdownMenuItem<MotivationState>>((state) {
              return DropdownMenuItem<MotivationState>(
                value: state,
                child: Text('${state.name} ${state.familyname}'),
              );
            }).toList(),
          );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error loading users: $error'),
        ),
      ],
    );
  }
  bool _validateForm(MotivationState state) {
    return state.name.isNotEmpty && state.familyname.isNotEmpty && state.sport.isNotEmpty;
  }
  void _submitToDatabase({required WidgetRef ref, required MotivationState state, required BuildContext context}) {
    ref.read(dataBaseProvider.notifier).insertMotivationState(state).then((_) {
      // Handle successful insertion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).data_saved_successfully)),
      );
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_saving_data)),
      );
    });
  }


}
