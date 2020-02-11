import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'core.dart';

/// A provider for [Store].
class StoreProvider<S> extends Provider<Store<S>> {
  StoreProvider({
    Key key,
    @required Store<S> store,
    Widget child,
  })  : assert(store != null),
        super(
          key: key,
          create: (_) => store,
          dispose: (_, store) => store.dispose(),
          child: child,
        );

  static Store<S> of<S>(BuildContext context) =>
      Provider.of<Store<S>>(context, listen: false);
}
