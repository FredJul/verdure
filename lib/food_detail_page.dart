import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/open_food_facts_api.dart';
import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/observer_state.dart';
import 'common/widgets.dart';
import 'gen/colors.gen.dart';
import 'model/food.dart';
import 'model/foods_state.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return Scaffold(
      backgroundColor: ColorName.primary[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ColorName.primary[900],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FoodHeader(food: food, foodsState: foodsState),
              const Gap(32),
              _Environment(food: food),
              const Gap(24),
              _Nutrients(food: food),
              const Gap(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  context.i18n.alternatives,
                  style: context.textTheme.subtitle1,
                ),
              ),
              const Gap(8),
              _AlternativesList(food: food, foodsState: foodsState),
              const Gap(32),
              _AboutData(food: food),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader({
    Key? key,
    required this.food,
    required this.foodsState,
  }) : super(key: key);

  final Food food;
  final FoodsState foodsState;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        color: ColorName.primary[50],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            _LargeFoodIcon(food: food, foodsState: foodsState),
          ],
        ),
      ),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.i18n.environmentalImpact,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.subtitle1,
                  ),
                ),
                EcoscoreImage(
                  grade: food.ecoscoreGrade,
                  height: 32,
                ),
              ],
            ),
            const Gap(8),
            _ImpactLevelIndicator(name: context.i18n.production, level: food.productionImpact),
            _ImpactLevelIndicator(name: context.i18n.transportation, level: food.transportationImpact),
            _ImpactLevelIndicator(name: context.i18n.packaging, level: food.packagingImpact),
          ],
        ),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.i18n.nutritionalValues,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.subtitle1,
                  ),
                ),
                NutriscoreImage(
                  grade: food.nutriscoreGrade,
                  height: 42,
                ),
              ],
            ),
            const Gap(8),
            _ImpactLevelIndicator(name: context.i18n.sugars, level: food.sugarsLevel),
            _ImpactLevelIndicator(name: context.i18n.fat, level: food.fatLevel),
            _ImpactLevelIndicator(name: context.i18n.saturatedFat, level: food.saturatedFatLevel),
            _ImpactLevelIndicator(name: context.i18n.salt, level: food.saltLevel),
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
    required this.foodsState,
  }) : super(key: key);

  final Food food;
  final FoodsState foodsState;

  @override
  _LargeFoodIconState createState() => _LargeFoodIconState();
}

class _LargeFoodIconState extends ObserverState<_LargeFoodIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: 100.milliseconds,
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();

    delay(400.milliseconds, () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInFavorites = widget.foodsState.favoriteFoods.indexWhere((e) => e.barcode == widget.food.barcode) != -1;

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
              child: FoodIcon(food: widget.food, size: 128),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: ScaleTransition(
            scale: _animation,
            child: Tap(
              borderRadius: const BorderRadius.all(Radius.circular(36)),
              onTap: () {
                if (isInFavorites) {
                  widget.foodsState.removeFavoriteFood(widget.food);
                } else {
                  widget.foodsState.addFavoriteFood(widget.food);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: const BorderRadius.all(Radius.circular(36)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isInFavorites ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red[400],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlternativesList extends StatefulWidget {
  const _AlternativesList({
    Key? key,
    required this.food,
    required this.foodsState,
  }) : super(key: key);

  final Food food;
  final FoodsState foodsState;

  @override
  _AlternativesListState createState() => _AlternativesListState();
}

class _AlternativesListState extends ObserverState<_AlternativesList> {
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

  void _fetchAlternatives() {
    setState(() {
      _alternativesLoading = true;
    });

    observeFuture<List<Food>>(OpenFoodFactsApi.getAlternatives(widget.food), (alternatives) {
      setState(() {
        _alternativesLoading = false;
        _alternatives = alternatives;
      });
    }, onError: (_) {
      setState(() {
        _alternativesLoading = false;
        _alternativesError = true;
      });
    });
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
                        child: Text(context.i18n.retry),
                      ),
                    ],
                  ),
                )
              : _alternatives.isEmpty
                  ? Center(
                      child: Text(
                        context.i18n.noAlternativeFound,
                        style: context.textTheme.bodyText1?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _alternatives
                          .map((food) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: FoodCard.minWidth,
                                  child: FoodCard(
                                    food: food,
                                    onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
    );
  }
}

class _ImpactLevelIndicator extends StatelessWidget {
  final String name;
  final ImpactLevel? level;

  const _ImpactLevelIndicator({
    Key? key,
    required this.name,
    required this.level,
  }) : super(key: key);

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
                      ? context.i18n.lowImpact
                      : level == ImpactLevel.moderate
                          ? context.i18n.moderateImpact
                          : level == ImpactLevel.high
                              ? context.i18n.highImpact
                              : context.i18n.unknownImpact,
                  style: context.textTheme.caption,
                ),
              ],
            ),
          ),
        ),
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
    return Tap(
      onTap: () async {
        try {
          await launch(OpenFoodFactsApi.getViewUrl(food));
        } catch (_) {
          final snackBar = SnackBar(content: Text(context.i18n.browserOpeningError));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
          color: ColorName.primary[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.i18n.dataSource,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      context.i18n.dataModification,
                      style: context.textTheme.subtitle2?.copyWith(
                        color: ColorName.primary[900],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
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
