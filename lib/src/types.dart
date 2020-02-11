import 'package:meta/meta.dart';

import 'core.dart';

/// A function which is executed when type matched of [TypedReducer].
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
typedef Reducer<S> = S Function(S state, dynamic action);

typedef ReducerCallback<S, A> = S Function(S state, A action);

typedef Dispatcher = void Function(dynamic action);

typedef Middleware<S> = Function(
  Store<S> store,
  dynamic action,
  Dispatcher next,
);

extension CombineReducer on Reducer {}

/// A Reducer class which provides type matching.
///
/// This is fully inspired from [TypedReducer] and modified that statement
/// for IDE support & readability.
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
/// # Usage
///
/// final appReducer = combineReducers<AppState>(
///   [
///     ReducerOf<AppState, IncrementAction>(
///       callback: (state, action) {
///         return state.copyWith(
///           counter: state.counter + 1,
///         );
///       },
///     ),
///     ReducerOf<AppState, DecrementAction>(
///       callback: (state, action) {
///         return state.copyWith(
///           counter: state.counter - 1,
///         );
///       },
///     ),
///   ],
/// );
///
class TypedReducer<S, A> {
  const TypedReducer({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final ReducerCallback<S, A> callback;

  /// Lets [TypedReducer] act as a function.
  S call(S state, dynamic action) {
    if (action is A) {
      return callback(state, action);
    }
    return state;
  }
}

/// A function which is executed when type matched of [TypedMiddleware].
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
typedef MiddlewareCallback<S, A> = void Function(
  Store<S> store,
  A action,
  Dispatcher next,
);

/// A Middleware class which provides type matching.
///
/// This is fully inspired from [TypedMiddleware] and modified that statement
/// for IDE support & readability.
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
/// # Usage
///
/// List<Middleware<AppState>> counterMiddleware() {
///   return [
///     MiddlewareOf<AppState, IncrementAction>(
///       callback: (store, action, next) {
///         print('IncrementAction was called!');
///         next(action);
///       },
///     ),
///     MiddlewareOf<AppState, DecrementAction>(
///       callback: (store, action, next) {
///         print('DecrementAction was called!');
///         next(action);
///       },
///     ),
///   ];
/// }
///
class TypedMiddleware<S, A> {
  const TypedMiddleware({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final MiddlewareCallback<S, A> callback;

  /// Lets [TypedMiddleware] act as a function.
  void call(Store<S> store, dynamic action, Dispatcher next) {
    if (action is A) {
      callback(store, action, next);
    } else {
      next(action);
    }
  }
}

/// A callback for [TypedInjectionMiddleware].
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
/// * [D] is type of a dependency which is injected.
///
typedef InjectionMiddlewareCallback<S, A, D> = void Function(
  Store<S> store,
  A action,
  Dispatcher next,
  D dependency,
);

/// A type matching middleware which can use injected dependency.
///
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
/// * [D] is type of a dependency which is injected.
///
/// # Usage
class TypedInjectionMiddleware<S, A, D> {
  const TypedInjectionMiddleware({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  /// Any dependency.
  final D dependency;

  /// A callback for middleware with dependency.
  final InjectionMiddlewareCallback<S, A, D> callback;

  /// Executes [callback] if the type of [action] is matched to [A].
  void call(Store<S> store, dynamic action, Dispatcher next) {
    if (action is A) {
      callback(store, action, next, dependency);
    } else {
      next(action);
    }
  }
}
