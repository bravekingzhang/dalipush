import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dalipush/dalipush.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dalipush _push = new Dalipush();
  String _platformVersion = 'Unknown';
  String _deviceId = 'Unknown';
  String _deviceToken= 'Unknown';

//  StreamSubscription<dynamic> _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String deviceId;
    String deviceToken;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Dalipush().platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      deviceId = await Dalipush().deviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId';
    }

    try {
      deviceToken = await Dalipush().deviceToken;
    } on PlatformException {
      deviceId = 'Failed to get deviceToken';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

//    if (_messageStreamSubscription == null) {
//      _messageStreamSubscription = _push.onMessage.listen((dynamic onData) {
//        print("我收到了推送$onData");
//      });
//    }

    setState(() {
      _platformVersion = platformVersion;
      _deviceId = deviceId;
      _deviceToken = deviceToken;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    canCelListener();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: new Text('Running on: $_platformVersion\n'),
              ),
              ListTile(
                title: new Text('deviceId: $_deviceId\n'),
              ),
              ListTile(
                title: new Text('deviceToken: $_deviceToken\n'),
              ),
              ListTile(
                title: StreamBuilder(
                    stream: _push.onMessage,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return new Text('Select lot');
                        case ConnectionState.waiting:
                          return new Text('等待消息到来...');
                        case ConnectionState.active:
                          return new Text('\$${snapshot.data}');
                        case ConnectionState.done:
                          return new Text('\$${snapshot.data} (closed)');
                      }
                    }),
              ),
            ],
          )),
    );
  }

//  void canCelListener() {
//    if (_messageStreamSubscription != null) {
//      _messageStreamSubscription.cancel();
//    }
//  }
}
