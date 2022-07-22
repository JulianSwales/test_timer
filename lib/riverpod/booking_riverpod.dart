import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_timer/riverpod/timer_riverpod.dart';

final bookingGood = Provider<bool>((ref) {
  final bookingInfo = ref.watch(bookingOn);
  if (bookingInfo) {
    return true;
  }
  return false;
}, name: 'bookingGood');

final bookingOn = StateProvider<bool>((ref) => false, name: 'bookingOn');

enum ScreenType { edit, add, view, tableAdd }

final screenTypeProvider = StateProvider<ScreenType>((ref) => ScreenType.view,
    name: 'screenTypeProvider');

final timerState = Provider((ref) {
  print('in timerState');
  final bookingGoodv = ref.watch(bookingGood);
  final screenval = ref.watch(screenTypeProvider);
  if (bookingGoodv && screenval != ScreenType.view) {
    ref.read(timerProvider.notifier).start();
  }
}, name: 'timerState');
