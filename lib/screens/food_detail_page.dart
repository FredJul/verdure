import 'package:dartx/dartx.dart';
import 'package:ecoscore/api/open_food_facts_api.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/food_widgets.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/colors.gen.dart';
import 'package:ecoscore/model/food.dart';
import 'package:ecoscore/model/providers.dart';
import 'package:ecoscore/translations/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'food_image_page.dart';

final _updatedFoodProvider = FutureProvider.family.autoDispose<Food?, String>((ref, barcode) async {
  final foodRepository = await ref.watch(foodRepositoryProvider.future);
  return foodRepository.refreshFood(barcode);
});

class FoodDetailPage extends ConsumerWidget {
  const FoodDetailPage({
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedFood = ref.watch(_updatedFoodProvider(food.barcode)).asData?.value ?? food;

    return Scaffold(
      body: Stack(
        children: [
          // Small hack to have white background on top (for status bar), and green background on bottom (for scrolling effect on iOS)
          Column(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: Container(
                  color: ColorName.primary[50],
                ),
              ),
            ],
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: ColorName.primary[900],
                ),
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: 236,
                title: DisapearingSliverAppBarTitle(child: Text(updatedFood.name)),
                flexibleSpace: FlexibleSpaceBar(
                  background: _FoodHeader(food: updatedFood),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(22),
                      _Environment(food: updatedFood),
                      const Gap(22),
                      _Nutrients(food: updatedFood),
                      const Gap(22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          Translation.current.alternatives,
                          style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(16),
                      _AlternativesList(food: updatedFood),
                      const Gap(32),
                      _AboutData(food: updatedFood),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        color: ColorName.primary[50],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 64, left: 24, right: 16, bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    food.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headline6?.copyWith(
                      color: ColorName.primary[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (food.brands != null || food.quantity != null)
                    Text(
                      '${food.brands ?? ''}${food.brands != null && food.quantity != null ? ' - ' : ''}${food.quantity ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                      ),
                    ),
                ],
              ),
            ),
            _LargeFoodIcon(food: food),
          ],
        ),
      ),
    );
  }
}

class _LargeFoodIcon extends StatefulWidget {
  const _LargeFoodIcon({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  _LargeFoodIconState createState() => _LargeFoodIconState();
}

class _LargeFoodIconState extends State<_LargeFoodIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _favAnimController = AnimationController(
    duration: 100.milliseconds,
    vsync: this,
  );
  late final Animation<double> _favAnimation = CurvedAnimation(
    parent: _favAnimController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();

    // We wait for the hero animation to be done before displaying the favorite button animation
    Future<void>.delayed(400.milliseconds).then((_) => _favAnimController.forward());
  }

  @override
  void dispose() {
    super.dispose();
    _favAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Hero(
              tag: widget.food.barcode,
              child: IgnorePointer(
                ignoring: widget.food.imageFrontUrl == null,
                child: GestureDetector(
                  onTap: () => context.pushScreen(FoodImagePage(imageUrl: widget.food.imageFrontUrl!)),
                  child: FoodIcon(food: widget.food, size: 136),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: ScaleTransition(
            scale: _favAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
                color: Colors.white.withAlpha(220),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final favFoods = ref.watch(favFoodsProvider).asData;
                  final foodRepository = ref.watch(foodRepositoryProvider).asData;

                  final isInFavorites = favFoods?.value.toList().indexWhere((e) => e.barcode == widget.food.barcode) != -1;

                  return Tap(
                    borderRadius: const BorderRadius.all(Radius.circular(36)),
                    onTap: () {
                      if (isInFavorites) {
                        foodRepository?.value.removeFavoriteFood(widget.food);
                      } else {
                        foodRepository?.value.addFavoriteFood(widget.food);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isInFavorites ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red[400],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Environment extends StatelessWidget {
  const _Environment({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    String? scoreToString(double? score) => score?.toInt().let((it) => '$it/100');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Translation.current.environmentalImpact,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(8),
              EcoscoreImage(
                grade: food.ecoscoreGrade,
                height: 36,
              ),
            ],
          ),
          const Gap(8),
          if (food.missingEcoscoreDataWarning)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[300]),
                  const Gap(8),
                  Expanded(child: Text(Translation.current.missingEcoscoreDataWarning, style: context.textTheme.caption)),
                ],
              ),
            ),
          if (food.ecoscoreGrade == Grade.notApplicable)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(Translation.current.notApplicableWarning, style: context.textTheme.caption),
            )
          else ...[
            _ImpactLevelIndicator(
              name: Translation.current.ingredients,
              value: scoreToString(food.ingredientsScore),
              level: food.ingredientsImpact,
            ),
            _ImpactLevelIndicator(
              name: Translation.current.transportation,
              value: null, // I don't want to display the score to let the user focus on the ingredients score
              level: food.transportationImpact,
            ),
            _ImpactLevelIndicator(
              name: Translation.current.packaging,
              value: null, // I don't want to display the score to let the user focus on the ingredients score
              level: food.packagingImpact,
            ),
          ],
        ],
      ),
    );
  }
}

class _Nutrients extends StatelessWidget {
  const _Nutrients({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    String? quantityToString(double? quantity) => quantity?.toShortString(context, 2).let((it) => '$it g');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Translation.current.nutritionalValues,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(8),
              NutriscoreImage(
                grade: food.nutriscoreGrade,
                height: 46,
              ),
            ],
          ),
          const Gap(8),
          if (food.nutriscoreGrade == Grade.notApplicable)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(Translation.current.notApplicableWarning, style: context.textTheme.caption),
            )
          else ...[
            _ImpactLevelIndicator(
              name: Translation.current.sugars,
              value: quantityToString(food.sugarsQuantity),
              level: food.sugarsLevel,
            ),
            _ImpactLevelIndicator(
              name: Translation.current.fat,
              value: quantityToString(food.fatQuantity),
              level: food.fatLevel,
            ),
            _ImpactLevelIndicator(
              name: Translation.current.saturatedFat,
              value: quantityToString(food.saturatedFatQuantity),
              level: food.saturatedFatLevel,
            ),
            _ImpactLevelIndicator(
              name: Translation.current.salt,
              value: quantityToString(food.saltQuantity),
              level: food.saltLevel,
            ),
          ],
          if (food.imageIngredientsUrl != null)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.pushScreen(FoodImagePage(imageUrl: food.imageIngredientsUrl!)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    Translation.current.seeIngredients,
                    style: context.textTheme.bodyText1?.copyWith(color: ColorName.primary[900], fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AlternativesList extends StatefulWidget {
  const _AlternativesList({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  _AlternativesListState createState() => _AlternativesListState();
}

class _AlternativesListState extends State<_AlternativesList> {
  var _alternatives = <Food>[];
  var _alternativesLoading = true;
  var _alternativesError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchAlternatives();
    });
  }

  Future<void> _fetchAlternatives() async {
    setState(() {
      _alternativesLoading = true;
    });

    try {
      final alternatives = await OpenFoodFactsApi.getAlternatives(widget.food);
      if (mounted) {
        setState(() {
          _alternativesLoading = false;
          _alternatives = alternatives;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _alternativesLoading = false;
          _alternativesError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FoodCard.minHeight,
      child: _alternativesLoading
          ? Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[100]!,
                highlightColor: Colors.white,
                child: SizedBox(
                  width: FoodCard.minWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            )
          : _alternativesError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _fetchAlternatives();
                        },
                        child: Text(Translation.current.retry),
                      ),
                    ],
                  ),
                )
              : _alternatives.isEmpty
                  ? Center(
                      child: Text(
                        Translation.current.noAlternativeFound,
                        style: context.textTheme.bodyText1?.copyWith(color: Colors.grey),
                      ),
                    )
                  : FadeInAppear(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _alternatives
                            .map(
                              (food) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: FoodCard.minWidth,
                                  child: FoodCard(
                                    food: food,
                                    onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
    );
  }
}

class _ImpactLevelIndicator extends StatelessWidget {
  const _ImpactLevelIndicator({
    Key? key,
    required this.name,
    required this.value,
    required this.level,
  }) : super(key: key);

  final String name;
  final String? value;
  final ImpactLevel? level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  level == ImpactLevel.low
                      ? Translation.current.lowImpact
                      : level == ImpactLevel.moderate
                          ? Translation.current.moderateImpact
                          : level == ImpactLevel.high
                              ? Translation.current.highImpact
                              : Translation.current.unknownImpact,
                  style: context.textTheme.caption,
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        if (value != null) Text(value!, style: context.textTheme.caption),
        const Gap(8),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: level == ImpactLevel.low
                ? Colors.green
                : level == ImpactLevel.moderate
                    ? Colors.yellow[600]
                    : level == ImpactLevel.high
                        ? Colors.red[400]
                        : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

class _AboutData extends StatelessWidget {
  const _AboutData({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        color: ColorName.primary[50],
      ),
      child: Tap(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        onTap: () async {
          try {
            await launch(OpenFoodFactsApi.getViewUrl(food));
          } catch (_) {
            final snackBar = SnackBar(content: Text(Translation.current.browserOpeningError));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translation.current.dataSource,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      Translation.current.dataModification,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorName.primary,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
