import 'package:flutter/material.dart';

import 'core/motivation_item.dart';

class MotivationForm extends StatefulWidget {
  @override
  _MotivationFormState createState() => _MotivationFormState();
}

class _MotivationFormState extends State<MotivationForm> {
  final _formKey = GlobalKey<FormState>();
  List<MotivationItem> _data = [
    MotivationItem(
      label: 'AUTONOMIE',
      caption: 'Sur une échelle de 0 à 10 NOTE\nÀ quel degré te sens-tu autonome dans ta pratique sportive, dans tes entrainements, dans la façon dont tu pratiques ton sport ?\n0 = pas du tout autonome, sentiment de contrainte permanente 10= sentiment d\'autonomie totale.',
      note: 5,
      recipe: 'ajuster les consignes données pour laisser du choix',
    ),
    // Add other fields similarly
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(_data[index].label),
                  Text(_data[index].caption),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _data[index].note.toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _data[index].note.toString(),
                          onChanged: (value) {
                            setState(() {
                              _data[index].note = value.toInt();
                            });
                          },
                        ),
                      ),
                      Text(_data[index].note.toString()),
                    ],
                  ),
                  TextFormField(
                    initialValue: _data[index].commentary,
                    decoration: InputDecoration(
                      labelText: 'Commentaire',
                    ),
                    onChanged: (value) {
                      _data[index].commentary = value;
                    },
                  ),
                  Text(_data[index].recipe),
                  TextFormField(
                    initialValue: _data[index].action,
                    decoration: InputDecoration(
                      labelText: 'Action',
                    ),
                    onChanged: (value) {
                      _data[index].action = value;
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