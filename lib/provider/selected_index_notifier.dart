import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier(int initialIndex) : super(initialIndex);

  void update(int newIndex) {
    state = newIndex;
  }
}
