import 'package:ecoscore/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/search_bar.dart';
import 'common/widgets.dart';
import 'food_detail_page.dart';
import 'gen/assets.gen.dart';
import 'gen/colors.gen.dart';
import 'model/foods_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 112,
          title: DisapearingSliverAppBarTitle(child: Assets.logoFull.svg(height: 32)),
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Assets.logoFull.svg(height: 64),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                GestureDetector(
                  behavior: HitTestBehavior.translucent, // needed with IgnorePointer as child
                  onTap: () => context.pushScreen(const SearchPage()),
                  child: IgnorePointer(
                    child: SearchBar(
                      onQueryChanged: (_) {},
                    ),
                  ),
                ),
                const Gap(24),
                const _FoodImpactExplanation(),
                const Gap(32),
                Text(
                  context.i18n.scannedProducts,
                  style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                if (foodsState.scannedFoods.isNotEmpty)
                  ...foodsState.scannedFoods.reversed.map((food) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        child: FoodCard(
                          food: food,
                          onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                        ),
                      ))
                else
                  EmptyView(icon: Assets.genericFood, subtitle: context.i18n.noScannedFood),
                const Gap(48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FoodImpactExplanation extends StatelessWidget {
  const _FoodImpactExplanation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen[50],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Tap(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () async {
          try {
            //TODO change the link when the app will be translated
            await launch('https://www.wwf.fr/agir-au-quotidien/alimentation');
          } catch (_) {
            final snackBar = SnackBar(content: Text(context.i18n.browserOpeningError));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Assets.earth.svg(height: 64),
              const Gap(12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.i18n.whyReduceImpactExplanation),
                    const Gap(8),
                    Text(
                      context.i18n.learnMore,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
