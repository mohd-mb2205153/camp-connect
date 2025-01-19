import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowNavBarNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void showBottomNavBar(bool show) => state = show;
}

final showNavBarNotifierProvider =
    NotifierProvider<ShowNavBarNotifier, bool>(() => ShowNavBarNotifier());
