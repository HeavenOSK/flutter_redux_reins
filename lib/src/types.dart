import 'redux_reins.dart';

// ignore: one_member_abstracts
abstract class MiddlewareClass<S> {
  void call(Store<S> store, dynamic action, NextDispatcher next);
}

// ignore: one_member_abstracts
abstract class ReducerClass<S> {
  S call(S state, dynamic action);
}
