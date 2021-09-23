import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dartx/dartx.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/food_widgets.dart';
import 'package:ecoscore/common/search_bar.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/gen/colors.gen.dart';
import 'package:ecoscore/model/providers.dart';
import 'package:ecoscore/translations/gen/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import 'food_detail_page.dart';
import 'search_page.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedFoods = ref.watch(scannedFoodsProvider).data;
    final foodRepository = ref.watch(foodRepositoryProvider).data;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 112,
          centerTitle: true,
          title: DisapearingSliverAppBarTitle(child: Assets.logoFull.svg(height: 42)),
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Assets.logoFull.svg(height: 64),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent, // needed with IgnorePointer as child
                  onTap: () => context.pushScreen(const SearchPage()),
                  child: const IgnorePointer(
                    child: SearchBar(),
                  ),
                ),
                const Gap(24),
                const _FoodImpactExplanation(),
                const Gap(32),
                Text(
                  Translation.current.scannedProducts,
                  style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(12),
              ],
            ),
          ),
        ),
        if (scannedFoods != null)
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 96),
            sliver: scannedFoods.value.isNotEmpty
                ? SliverList(
                    delegate: SliverChildListDelegate(
                      scannedFoods.value.reversed
                          .map(
                            (food) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: FoodCard(
                                food: food,
                                onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                                onLongPress: () {
                                  showOkCancelAlertDialog(
                                    context: context,
                                    message: Translation.current.deleteScannedProductMessage,
                                  ).then((result) {
                                    if (result == OkCancelResult.ok) {
                                      foodRepository?.value.deleteScannedFood(food);
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: Center(
                        child: EmptyView(icon: Assets.genericFood, subtitle: Translation.current.noScannedFood),
                      ),
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
            final snackBar = SnackBar(content: Text(Translation.current.browserOpeningError));
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
                    Text(Translation.current.whyReduceImpactExplanation),
                    const Gap(8),
                    Text(
                      Translation.current.learnMore,
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
