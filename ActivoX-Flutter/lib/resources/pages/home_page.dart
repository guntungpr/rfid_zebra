import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/scan/scan_qris_page.dart';
// import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/resources/widgets/logo_widget.dart';
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
  @override
  init() async {
    super.init();
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ScanQrisPage.path,
                    arguments: {'exampleArgument': 'testss'},
                  );
                },
                child: Text(
                  "SCAN QRIS",
                ).bodyMedium(context).alignCenter(),
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
                  if (!context.isDarkMode) Text("${isThemeDark ? "Dark" : "Light"} Mode"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId == getEnv('DARK_THEME_ID');
}
