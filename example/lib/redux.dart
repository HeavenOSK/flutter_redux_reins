import 'package:flutter/foundation.dart';

class AppState {
  AppState._({
    @required this.counter,
  });

  factory AppState.initialize() => AppState._(
        counter: 0,
      );

  final int counter;

  AppState copyWith({int counter}) => AppState._(
        counter: counter ?? this.counter,
      );
}

class CounterIncrementAction {}

AppState reducer(AppState state, dynamic action) {
  if (action is CounterIncrementAction) {
    return state.copyWith(
      counter: state.counter + 1,
    );
  }
  return state;
}
