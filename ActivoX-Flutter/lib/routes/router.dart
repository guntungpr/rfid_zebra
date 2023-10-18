import 'package:flutter_app/resources/pages/nfc/nfc_page.dart';
import 'package:flutter_app/resources/pages/scan/scan_qr_page.dart';

import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.x/router
|--------------------------------------------------------------------------
*/

appRouter() => nyRoutes((router) {
      router.route(HomePage.path, (context) => HomePage(), initialRoute: true);
      router.route(
        ScanQRPage.path,
        (context) => ScanQRPage(),
        transition: PageTransitionType.leftToRightWithFade,
      );
      router.route(
        NFCPage.path,
        (context) => NFCPage(),
        transition: PageTransitionType.fade,
      );

      // Add your routes here

      // router.route(NewPage.path, (context) => NewPage(), transition: PageTransitionType.fade);
    });
