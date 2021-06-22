import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'model/food.dart';
import 'screens/main_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(GradeAdapter());
  Hive.registerAdapter(ImpactLevelAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Block rotation on small screens (smartphones) since current UI is not always adapted to small height
    final windowSize = MediaQueryData.fromWindow(window).size;
    if (min(windowSize.height, windowSize.width) < 600) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    return ProviderScope(
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
