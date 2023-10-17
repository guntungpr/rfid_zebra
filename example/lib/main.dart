import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_zebra_rfid/flutter_zebra_rfid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  List<Reader> _availableReader = [];
  var _connect;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterZebraRfid().sdkVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  static const platform = MethodChannel('flutter_zebra_rfid');

  Future<void> getConnect() async {
    print('connect');
    final data = await platform.invokeMethod('connect');
    print('check data connect= $data');
    setState(() {
      _connect = data;
    });
  }

  Future<void> getAvailableReaders() async {
    print('getAvailableReaders');
    final data = await FlutterZebraRfid().fetchAvailableReaders();
    print('check data getAvailableReaders= $data');
    setState(() {
      _availableReader = data;
    });
    if (_availableReader.isNotEmpty) {
      print('exist');
      Reader _read = Reader(
        id: _availableReader[0].id,
        name: _availableReader[0].name,
      );
      print(await _read.isConnected);

      await _read.startLocateTag('tagEpcId');

      print(await _read.readTag(
        tagId: _read.id,
        memoryBank: MemoryBank.all,
        offset: 1,
        length: 2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RFID example app'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              onPressed: () async {
                getConnect();
              },
              child: Text("connect"),
            ),
            Center(
              child: Text('get connect =  $_connect\n'),
            ),
            ElevatedButton(
              onPressed: () async {
                getAvailableReaders();
              },
              child: Text("getAvailableReaders"),
            ),
            Center(
              child: Text('get Available readers =  $_availableReader\n'),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
