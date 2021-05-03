import 'package:ecoscore/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
          Locale('en', ''),
          Locale('fr', ''),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Nunito',
        ),
        home: HomePage(),
      ),
    );
  }
}
