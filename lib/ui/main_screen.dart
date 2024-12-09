import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preparation_mentale/ui/user_input_screen.dart';

import '../generated/l10n.dart';
import '../rp_provider.dart';
import 'analysis_screen.dart';
import 'questionnaire_general.dart';

class MainScreen extends ConsumerWidget {

  const MainScreen({super.key});

  static List<Widget> _widgetOptions = <Widget>[
    // Replace with your actual screens
    const UserInputScreen(),
    QuestionnaireGeneral(),
    AnalysisScreen(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
      ),
      body: _widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Select User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Questionnaire',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).update(index);
        },
      ),
    );
  }
}