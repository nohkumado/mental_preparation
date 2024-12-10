import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preparation_mentale/core/motivation_state.dart';
import 'package:preparation_mentale/provider/motivation_data_notifier.dart';

import 'generated/l10n.dart';
import 'core/motivation_data.dart';
import 'provider/db_notifier.dart';
import 'provider/locale_notifier.dart';
import 'provider/selected_index_notifier.dart';
import 'provider/user_input_notifier.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier();
});


Future<S> lookupAppLocalizations(Locale locale) async {
  return await S.delegate.load(locale);
}


 // final motivationDataProvider = Provider<List<MotivationItem>>((ref) async {
 //   final locale = await ref.watch(localeProvider);
 //  final appLocalizations = lookupAppLocalizations(locale); // Initialize with a default locale
 //   return MotivationData()..build(appLocalizations);
 //   ;
 // });

// final motivationDataProvider = FutureProvider<MotivationData>((ref) async {
//   final locale = ref.watch(localeProvider);
//   await initializeMessages(locale.locale.languageCode);
//  final appLocalizations = S(); // Initialize with a default locale
//   return MotivationData()..build(appLocalizations);
// });
final motivationDataProvider = StateNotifierProvider<MotivationDataNotifier, MotivationData>((ref)
=> MotivationDataNotifier()
);

final userInputProvider = StateNotifierProvider<UserInputNotifier, MotivationState>((ref) {
  return UserInputNotifier();
});

final selectedIndexProvider = StateNotifierProvider<SelectedIndexNotifier, int>((ref) => SelectedIndexNotifier(0));

final dataBaseProvider = StateNotifierProvider<DbNotifier, AsyncValue<MotivationState>>((ref) {
  return DbNotifier();
});
//// Create a provider to manage the list of motivation states
//final motivationStatesProvider = FutureProvider<List<MotivationState>>((ref) {
//  final dbNotifier = ref.read(dataBaseProvider.notifier);
//  return dbNotifier.getAllMotivationStates();
//});
final motivationStatesProvider = FutureProvider<List<MotivationState>>((ref) async {
  final dbNotifier = ref.watch(dataBaseProvider.notifier);
  return await dbNotifier.getAllMotivationStates();
});
