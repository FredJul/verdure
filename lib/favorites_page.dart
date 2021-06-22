import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/widgets.dart';
import 'food_detail_page.dart';
import 'gen/assets.gen.dart';
import 'model/providers.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favFoods = ref.watch(favFoodsProvider).data;

    return SafeArea(
      child: AnimatedCrossFade(
        firstChild: Center(
          child: EmptyView(icon: Assets.favorites, subtitle: context.i18n.noFavoriteFood),
        ),
        secondChild: ListView(
          shrinkWrap: true,
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
            if (favFoods != null)
              ...favFoods.value.reversed.map((food) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: FoodCard(
                      food: food,
                      onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                    ),
                  )),
            const Gap(48),
          ],
        ),
        crossFadeState: favFoods != null && favFoods.value.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: 200.milliseconds,
      ),
    );
  }
}
