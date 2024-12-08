import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';
import 'motivation_data.dart';
import 'provider/locale_notifier.dart';

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

final motivationDataProvider = FutureProvider<MotivationData>((ref) async {
  final locale = ref.watch(localeProvider);
  await initializeMessages(locale.locale.languageCode);
 final appLocalizations = S(); // Initialize with a default locale
  return MotivationData()..build(appLocalizations);
});
