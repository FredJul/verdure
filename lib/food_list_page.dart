import 'package:ecoscore/food_detail_page.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'common/extensions.dart';
import 'common/widgets.dart';

class FoodListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return ListView(children: [
      ...foodsState.scannedFoods.reversed.map((food) => FoodCard(
            food: food,
            onTap: () => context.pushScreen(FoodDetailPage(food: food)),
          )),
      const Gap(48),
    ]);
  }
}
