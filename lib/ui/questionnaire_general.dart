import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preparation_mentale/rp_provider.dart';

import '../core/motivation_data.dart';

class QuestionnaireGeneral extends ConsumerWidget {

  QuestionnaireGeneral({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MotivationData data = ref.watch(motivationDataProvider);
    return Form(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(data[index].label),
                  Text(data[index].caption),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: data[index].note.toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: data[index].note.toString(),
                          onChanged: (value) {
                            data[index].note = value.toInt();
                          },
                        ),
                      ),
                      Text(data[index].note.toString()),
                    ],
                  ),
                  TextFormField(
                    initialValue: data[index].commentary,
                    decoration: InputDecoration(
                      labelText: 'Commentaire',
                    ),
                    onChanged: (value) {
                      data[index].commentary = value;
                    },
                  ),
                  Text(data[index].recipe),
                  TextFormField(
                    initialValue: data[index].action,
                    decoration: InputDecoration(
                      labelText: 'Action',
                    ),
                    onChanged: (value) {
                      data[index].action = value;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
