import 'package:ecoscore/food_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'common/extensions.dart';
import 'common/food_card.dart';
import 'model/foods_state.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return ListView(
      children: [
        const Gap(32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            context.i18n.favoriteTitle,
            style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const Gap(8),
        ...foodsState.favoriteFoods.reversed.map((food) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: FoodCard(
                food: food,
                onTap: () => context.pushScreen(FoodDetailPage(food: food)),
              ),
            )),
        const Gap(48),
      ],
    );
  }
}
