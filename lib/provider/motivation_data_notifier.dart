import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/motivation_data.dart';
import '../generated/intl/messages_all.dart';
import '../generated/l10n.dart';

class MotivationDataNotifier extends StateNotifier<MotivationData> {

  MotivationDataNotifier() : super(MotivationData());

  Future<void> chLoc(Locale newLoc) async {
    await initializeMessages(newLoc.languageCode);
    final appLocalizations = S(); // Initialize with a default locale
    state = MotivationData()..build(appLocalizations);
  }

}
