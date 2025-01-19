import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowNavBarNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {
      'showNavBar': true,
      'selectedIndex': 0,
    };
  }

  void showBottomNavBar(bool show) {
    state = {
      ...state,
      'showNavBar': show,
    };
  }

  void setActiveBottomNavBar(int index) {
    state = {
      ...state,
      'selectedIndex': index,
    };
  }

  int getActiveBottomNavBar() {
    return state['selectedIndex'];
  }
}

final showNavBarNotifierProvider =
    NotifierProvider<ShowNavBarNotifier, Map<String, dynamic>>(
  () => ShowNavBarNotifier(),
);
