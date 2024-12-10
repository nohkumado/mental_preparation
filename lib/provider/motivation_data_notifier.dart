import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/motivation_data.dart';
import '../generated/intl/messages_all.dart';
import '../generated/l10n.dart';

class MotivationDataNotifier extends StateNotifier<MotivationData> {

  MotivationDataNotifier() : super(MotivationData());
}
