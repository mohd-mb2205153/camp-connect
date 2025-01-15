import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowBotNavNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void showBottomNavBar(bool show) => state = show;
}

final showBotNavNotifierProvider =
    NotifierProvider<ShowBotNavNotifier, bool>(() => ShowBotNavNotifier());
