import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_mentale/rp_provider.dart';


void main() {
  group('LocaleProvider tests', () {
    // Create a provider container for testing
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(); // Set up provider container before each test
    });

    tearDown(() {
      container.dispose(); // Clean up after each test
    });

    //test('should return French locale by default', () {
    //  // Test when an unsupported locale is passed
    //  final locale = container.read(localeProvider);
    //  expect(locale, Locale('fr', 'FR')); // Default fallback locale
    //});

    test('should return English locale when supported', () {
      // Mock supported locale to 'en'
      final supportedLocale = Locale('en', 'US');
      container.read(localeProvider.notifier).setLocale(supportedLocale);

      final locale = container.read(localeProvider);
      expect(locale.locale, Locale('en', 'US')); // Expect English locale
    });

    test('should return German locale when supported', () {
      // Mock supported locale to 'de'
      final supportedLocale = Locale('de', 'DE');
      container.read(localeProvider.notifier).setLocale(supportedLocale);

      final locale = container.read(localeProvider);
      expect(locale.locale, Locale('de', 'DE')); // Expect German locale
    });

    test('should default to French if locale is not supported', () {
      // Mock unsupported locale (e.g., 'it')
      final unsupportedLocale = Locale('it', 'IT');
      container.read(localeProvider.notifier).setLocale(unsupportedLocale);

      final locale = container.read(localeProvider);
      expect(locale.locale, Locale('fr', 'FR')); // Should fallback to French
    });
  });
}
