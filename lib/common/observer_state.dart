import 'dart:async';

import 'package:flutter/material.dart';

abstract class ObserverState<E extends StatefulWidget> extends State<E> with WidgetsBindingObserver {
  final _subscriptions = <StreamSubscription>{};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    for (final s in _subscriptions) {
      s.cancel();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      for (final s in _subscriptions) {
        s.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      for (final s in _subscriptions) {
        s.resume();
      }
    }
  }

  void observeFuture<T>(Future<T> future, Function(T event) onData, {Function(Object error)? onError}) {
    late StreamSubscription s;
    s = future.asStream().listen(onData, onError: onError, cancelOnError: true, onDone: () {
      _subscriptions.remove(s);
    });

    _subscriptions.add(s);
  }
}
