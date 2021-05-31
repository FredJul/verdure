import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'main_page.dart';
import 'model/food.dart';
import 'model/foods_state.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(GradeAdapter());
  Hive.registerAdapter(ImpactLevelAdapter());

  Future<Box<Food>> openBox(String boxName) async {
    Box<Food> box;
    try {
      box = await Hive.openBox(boxName);
    } catch (_) {
      // In case of migration issue, we simply erase everything :)
      await Hive.deleteBoxFromDisk(boxName);
      box = await Hive.openBox(boxName);
    }

    return box;
  }

  runApp(MyApp(await openBox('scanned_foods'), await openBox('fav_foods')));
}

class MyApp extends StatelessWidget {
  final Box<Food> _scannedFoodsBox;
  final Box<Food> _favFoodsBox;

  const MyApp(this._scannedFoodsBox, this._favFoodsBox);

  @override
  Widget build(BuildContext context) {
    // Current design does not fit really well with the status bar, so it is hidden for now
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white70,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Block rotation on small screens (smartphones) since current UI is not always adapted to small height
    final windowSize = MediaQueryData.fromWindow(window).size;
    if (min(windowSize.height, windowSize.width) < 600) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    return ChangeNotifierProvider(
      create: (_) => FoodsState(_scannedFoodsBox, _favFoodsBox),
      child: MaterialApp(
        title: 'Verdure',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', ''),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: ColorName.primary,
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: FontFamily.nunito,
        ),
        home: MainPage(),
      ),
    );
  }
}
