import 'package:dartx/dartx.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/food_widgets.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/model/providers.dart';
import 'package:ecoscore/screens/food_detail_page.dart';
import 'package:ecoscore/translations/gen/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favFoods = ref.watch(favFoodsProvider).asData;

    return SafeArea(
      child: AnimatedCrossFade(
        firstChild: Center(
          child: EmptyView(icon: Assets.favorites, subtitle: Translation.current.noFavoriteFood),
        ),
        secondChild: ListView(
          shrinkWrap: true,
          children: [
            const Gap(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                Translation.current.favoriteTitle,
                style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Gap(8),
            if (favFoods != null)
              ...favFoods.value.reversed.map(
                (food) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: FoodCard(
                    food: food,
                    onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                  ),
                ),
              ),
            const Gap(48),
          ],
        ),
        crossFadeState: favFoods != null && favFoods.value.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: 200.milliseconds,
      ),
    );
  }
}
