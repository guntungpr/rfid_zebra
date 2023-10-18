// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_app/resources/pages/scan/scan_qris_page.dart';
// import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/resources/widgets/logo_widget.dart';
import 'package:flutter_zebra_rfid/flutter_zebra_rfid.dart';
import '/app/controllers/home_controller.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/safearea_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';

class HomePage extends NyStatefulWidget {
  @override
  final HomeController controller = HomeController();

  static const path = '/home-page';

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends NyState<HomePage> {
  String _platformVersion = 'Unknown';
  List<Reader> _availableReader = [];
  var _connect;
  List _availabelReadersNative = [];
  List _activeReadersNative = [];

  @override
  init() async {
    super.init();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterZebraRfid().sdkVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
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

  Future<void> getAvailableReadersNative() async {
    print('getAvailableReadersNative');
    final data = await platform.invokeMethod('getAvailableReaders');
    print('check data getAvailableReadersNative= $data');
    setState(() {
      _availabelReadersNative = data;
    });
  }

  Future<void> getActiveReadersNative() async {
    print('getActiveReadersNative');
    final data = await platform.invokeMethod('getActiveReaders');
    print('check data getActiveReadersNative= $data');
    setState(() {
      _activeReadersNative = data;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Activo X".tr()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.controller.showAbout,
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeAreaWidget(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Logo(),
                Text(
                  getEnv("APP_NAME"),
                ).displayMedium(context),
                Text(
                  "Fixed Asset Management System",
                ).bodyMedium(context).alignCenter(),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(
                //       context,
                //       ScanQrisPage.path,
                //       arguments: {'exampleArgument': 'testss'},
                //     );
                //   },
                //   child: Text(
                //     "SCAN QR",
                //   ).bodyMedium(context).alignCenter(),
                // ),
                const SizedBox(height: 20),
                Center(
                  child: Text('Running on: $_platformVersion\n'),
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
                ElevatedButton(
                  onPressed: () async {
                    getAvailableReadersNative();
                  },
                  child: Text("getAvailableReadersNative"),
                ),
                Center(
                  child: Text('getAvailableReadersNative =  $_availabelReadersNative\n'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    getActiveReadersNative();
                  },
                  child: Text("getActiveReadersNative"),
                ),
                Center(
                  child: Text('getActiveReadersNative =  $_activeReadersNative\n'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Divider(),
                    Container(
                      height: 250,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          color: ThemeColor.get(context).surfaceBackground,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 9,
                              offset: Offset(0, 3),
                            ),
                          ]),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children:
                              ListTile.divideTiles(context: context, tiles: []).toList(),
                        ),
                      ),
                    ),
                    if (!context.isDarkMode)
                      Switch(
                          value: isThemeDark,
                          onChanged: (_) {
                            NyTheme.set(context,
                                id: getEnv(isThemeDark != true
                                    ? 'DARK_THEME_ID'
                                    : 'LIGHT_THEME_ID'));
                          }),
                    if (!context.isDarkMode)
                      Text("${isThemeDark ? "Dark" : "Light"} Mode"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId == getEnv('DARK_THEME_ID');
}
