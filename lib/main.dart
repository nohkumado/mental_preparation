import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:preparation_mentale/provider/locale_notifier.dart';
import 'package:preparation_mentale/ui/main_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';
import 'core/motivation_data.dart';
import 'rp_provider.dart';
import 'ui/questionnaire_general.dart';

import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   Intl.defaultLocale = 'fr';
  await initializeMessages('fr');
    if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI for Windows and Linux
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    //no need to initalize anything on other platforms natively present
  }
    else databaseFactory = databaseFactoryFfiWeb;
  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final locale = ref.watch(localeProvider);

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
            if (currentlocale != localeState.locale) {
              ref.read(localeProvider.notifier).setLocale(currentlocale);
            }
          }
          );
          return MainScreen();
          //return QuestionnaireGeneral();

      })
        );
  }
}
