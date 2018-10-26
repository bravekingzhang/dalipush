import 'dart:async';

import 'package:flutter/services.dart';

class Dalipush {
  factory Dalipush() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('dalipush');
      final EventChannel eventChannel = const EventChannel('dalipush_event');
      _instance = new Dalipush.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  Dalipush.private(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;

  final EventChannel _eventChannel;

  static Dalipush _instance;

  Stream<dynamic> _listener;

  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Stream<dynamic> get onMessage {
    if (_listener == null) {
      _listener = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseMsg(event));
    }
    return _listener;
  }

  dynamic _parseMsg(event) {
    return event;
  }
}
