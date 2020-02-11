import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'redux.dart';

/// A provider for [Store].
class StoreProvider<S> extends Provider<Store<S>> {
  StoreProvider({
    Key key,
    @required this.store,
    this.child,
  })  : assert(store != null),
        super(
          key: key,
          create: (_) => store,
          dispose: (_, store) => store.dispose(),
          child: child,
        );

  final Store<S> store;
  final Widget child;

  static Store<S> of<S>(BuildContext context) =>
      Provider.of<Store<S>>(context, listen: false);
}
