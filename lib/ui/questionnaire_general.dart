import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:preparation_mentale/core/motivation_item.dart';
import 'package:preparation_mentale/provider/user_input_notifier.dart';
import 'package:preparation_mentale/rp_provider.dart';

import '../core/motivation_data.dart';
import '../core/motivation_state.dart';
import '../generated/l10n.dart';
import 'motivation_item_labels.dart';

class QuestionnaireGeneral extends ConsumerWidget {

  QuestionnaireGeneral({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final MotivationData data = ref.watch(motivationDataProvider);
   //print("retrieved $data " );
    MotivationState userState = ref.watch(userInputProvider);
    Map<Motivations,MotivationItemLabels> labels = MotivationItemLabels.labels ?? MotivationItemLabels.initLabels(S.of(context));

    DateFormat formater = DateFormat("yyyy-MM-dd");
    return Column(
      children: [
        Row(
          children: [
            Padding(padding: const EdgeInsets.only(right: 8),child: Text(S.of(context).questionnaire_titre)),
            Padding(padding: const EdgeInsets.only(right: 8),child: Text("${userState.name}")),
            Padding(padding: const EdgeInsets.only(right: 8),child: Text("${userState.familyname}")),
            Text("Date : ${formater.format(userState.date)}"),
          ],
        ),
        Expanded(
          child:
          Form(
            child: ListView.builder(
              itemCount: Motivations.values.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(labels[Motivations.values[index]]!.label),
                        Text(labels[Motivations.values[index]]!.caption),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: userState.data[Motivations.values[index]].note.toDouble(),
                                min: 0,
                                max: 10,
                                divisions: 10,
                                label: userState.data[Motivations.values[index]].note.toString(),
                                onChanged: (value) {
                                  ref.read(userInputProvider.notifier).chgNote(Motivations.values[index], value.toInt());
                                  userState.data[Motivations.values[index]].note = value.toInt();
                                },
                              ),
                            ),
                            Text(userState.data[Motivations.values[index]].note.toString()),
                          ],
                        ),
                        TextFormField(
                          initialValue: userState.data[Motivations.values[index]].commentary,
                          decoration: InputDecoration(
                            labelText: 'Commentaire',
                          ),
                          onChanged: (value) {
                            ref.read(userInputProvider.notifier).chgText(i:Motivations.values[index], type:txtFields.comment, val:  value);
                            userState.data[Motivations.values[index]].commentary = value;
                          },
                        ),
                        Text(labels[Motivations.values[index]]!.recipe),
                        TextFormField(
                          initialValue: userState.data[Motivations.values[index]].action,
                          decoration: InputDecoration(
                            labelText: 'Action',
                          ),
                          onChanged: (value) {
                            ref.read(userInputProvider.notifier).chgText(i:Motivations.values[index], type:txtFields.action, val:  value);
                            userState.data[Motivations.values[index]].action = value;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ),
        ElevatedButton(onPressed: () {
          print("about to save $userState");
          //ref.read(userInputProvider.notifier).saveToDatabase();
          ref.read(dataBaseProvider.notifier).upsertMotivationState(userState).then((_) {
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
        }, child: Text(S.of(context).save)),

      ],
    );
  }
}
