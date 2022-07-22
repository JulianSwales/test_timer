import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  TimerNotifier() : super(_initialState);

  static const int _initialDuration = 30;
  static final _initialState =
      TimerModel(_durationString(_initialDuration), TimerState.initial);

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  static String _durationString(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(1, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void start() {
    _startTimer();
  }

  void _startTimer() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick(ticks: _initialDuration).listen((duration) {
      state = TimerModel(_durationString(duration), TimerState.started);
    });
    _tickerSubscription?.onDone(() {
      print('Ticker Finished');
      state = TimerModel(state.timeLeft, TimerState.finished);
    });
    state = TimerModel(_durationString(_initialDuration), TimerState.started);
  }

  void reset() {
    _tickerSubscription?.cancel();
    state = _initialState;
  }

  void stop() {
    _tickerSubscription?.cancel();
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class TimerModel {
  const TimerModel(this.timeLeft, this.timerState);
  final String timeLeft;
  final TimerState timerState;
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, TimerModel>((ref) => TimerNotifier(), name: 'timerProvider');

final timeLeftProvider = Provider<String>((ref) {
  return ref.watch(timerProvider).timeLeft;
}, name: 'timeLeftProvider');

enum TimerState {
  initial,
  started,
  finished,
}
