import 'package:flutter/material.dart';
import 'package:redux_reins/redux_reins.dart';

import 'redux.dart';

void main() => runApp(
      StoreProvider<AppState>(
        store: Store(
          initialState: AppState.initialize(),
          reducer: reducer,
        ),
        child: MyHomePage(),
      ),
    );

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: store.onChange.map((state) => state.counter),
            builder: (context, snapshot) {
              return Text(
                '${snapshot.data}',
                style: Theme.of(context).textTheme.display1,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          onPressed: () => store.dispatch(CounterIncrementAction()),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
