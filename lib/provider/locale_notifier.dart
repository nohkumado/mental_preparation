import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleState {
  final Locale locale;
  LocaleState(this.locale);
}

class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier() : super(LocaleState(const Locale('fr', 'FR')));

  void setLocale(Locale newLocale) {
    final supportedLocales = ['en', 'de', 'fr'];
    if (supportedLocales.contains(newLocale.languageCode)) {
      state = LocaleState(newLocale); // Update state with the new supported locale
    } else {
      state = LocaleState(const Locale('fr', 'FR')); // Default to French if unsupported
    }
  }
}


