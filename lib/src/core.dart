import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

typedef Reducer<S> = S Function(S state, dynamic action);

typedef Dispatcher = void Function(dynamic action);

typedef Middleware<S> = Function(
  Store<S> store,
  dynamic action,
  Dispatcher next,
);

/// A store for Redux architecture.
class Store<S> {
  Store({
    @required S initialState,
    @required Reducer<S> reducer,
    List<Middleware<S>> middlewareList = const [],
  })  : assert(reducer != null),
        assert(initialState != null),
        assert(middlewareList != null),
        _reducer = reducer,
        _state = BehaviorSubject.seeded(initialState) {
    _dispatchers = _createDispatchers(middlewareList);
    _reducerQueue.stream
        .map<S>((dynamic action) => _reducer(currentState, action))
        .distinct((previous, next) => previous == next)
        .listen(_state.add);
  }

  final Reducer<S> _reducer;
  List<Dispatcher> _dispatchers;
  final BehaviorSubject<S> _state;
  final _reducerQueue = StreamController<dynamic>.broadcast();

  /// A current value of state.
  S get currentState => _state.value;

  /// A stream that emits the current state when it changes.
  Stream<S> get state => _state.stream;

  /// Dispatches action to top of the middleware or reducer.
  void dispatch(dynamic action) => _dispatchers.first(action);

  List<Dispatcher> _createDispatchers(List<Middleware<S>> middlewareList) {
    final dispatchers = <Dispatcher>[]..add(_reducerQueue.add);
    for (final middleware in middlewareList.reversed) {
      final next = dispatchers.last;
      dispatchers.add(
        (dynamic action) => middleware(this, action, next),
      );
    }
    return dispatchers.reversed.toList();
  }

  /// Disposes streams which are had by [Store].
  Future<void> dispose() async {
    await _state.close();
    await _reducerQueue.close();
  }
}
