import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'common/extensions.dart';
import 'home_page.dart';
import 'model/food.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());

  const boxName = 'Foods';
  Box<Food> box;
  try {
    box = await Hive.openBox(boxName);
  } catch (_) {
    // In case of migration issue, we simply erase everything :)
    await Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox(boxName);
  }

  runApp(MyApp(box));
}

class MyApp extends StatelessWidget {
  final Box<Food> _box;

  const MyApp(this._box);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white70,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ChangeNotifierProvider(
      create: (_) => FoodsState(_box),
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
          primarySwatch: const Color(0xFF66b254).toMaterialColor(),
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Nunito',
        ),
        home: HomePage(),
      ),
    );
  }
}
