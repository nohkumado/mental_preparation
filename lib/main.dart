import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:preparation_mentale/provider/locale_notifier.dart';

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';
import 'motivation_data.dart';
import 'rp_provider.dart';



Future<void> main() async {
   Intl.defaultLocale = 'fr';
  await initializeMessages('fr');
  runApp(ProviderScope(child:MyApp()));
}

 // class MyApp extends ConsumerWidget {
 //   @override
 //   Widget build(BuildContext context, WidgetRef ref) {
 //      // Set the locale only once when the app starts
 //     Future.microtask(() {
 //       final locale = Localizations.localeOf(context);
 //       ref.read(localeProvider.notifier).setLocale(locale);
 //     });
 //
 //         final locale = ref.watch(localeProvider);
 //     MotivationData  motData= ref.watch(motivationDataProvider);
 //
 //         return MaterialApp(
 //           localizationsDelegates: [
 //             S.delegate,
 //             GlobalMaterialLocalizations.delegate,
 //             GlobalWidgetsLocalizations.delegate,
 //             GlobalCupertinoLocalizations.delegate,
 //           ],
 //           supportedLocales: S.delegate.supportedLocales,
 //           locale: locale.locale,
 //           home: MentalPreparation(data: motData,onSave: _saveData(),),
 //         );
 //   }
 // }
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final locale = ref.watch(localeProvider);
    final motDataAsync = ref.watch(motivationDataProvider); // This is now AsyncValue

    return motDataAsync.when(
      data: (motData) {
        // When the data is available, render the UI
        return MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: locale.locale,
          home:
          Builder(builder: (BuildContext context)
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final currentlocale = Localizations.localeOf(context);
            final localeState = ref.read(localeProvider);
            print("found locale : $locale vs $currentlocale/$localeState");
            if (currentlocale != localeState.locale) {
              ref.read(localeProvider.notifier).setLocale(currentlocale);
            }
          }
          );
          return MentalPreparation(data: motData);

      })
         ,
        );
      },
      loading: () {
        // You can show a loading indicator while waiting for data
        return CircularProgressIndicator();
      },
      error: (error, stack) {
        // You can handle errors here, such as showing a message
        return Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        );
      },
    );
  }
}




  //@override
  //Widget build(BuildContext context) {
  //  return Scaffold(
  //    appBar: AppBar(
  //      title: Text('Motivation Form'),
  //    ),
  //    body: _data.isEmpty
  //        ? Center(child: CircularProgressIndicator())
  //        : MotivationFormWidget(data: _data, onSave: _saveData),
  //    floatingActionButton: FloatingActionButton(
  //      onPressed: _saveData,
  //      child: Icon(Icons.save),
  //    ),
  //  );
  //}

class MentalPreparation extends ConsumerWidget {
  final MotivationData data;

  MentalPreparation({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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