import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/model/food.dart';
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
import 'model/foods_state.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({
    required this.food,
  });

  final Food food;

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends ObserverState<FoodDetailPage> {
  var _betterFoods = <Food>[];
  var _betterFoodsLoading = true;
  var _betterFoodsError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchBetterFoods();
    });
  }

  void _fetchBetterFoods() {
    setState(() {
      _betterFoodsLoading = true;
    });

    observeFuture<List<Food>>(OpenFoodFactsApi.getBetterFoods(widget.food), (betterFoods) {
      setState(() {
        _betterFoodsLoading = false;
        _betterFoods = betterFoods;
      });
    }, onError: (_) {
      setState(() {
        _betterFoodsLoading = false;
        _betterFoodsError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();
    final isInFavorites = foodsState.favoriteFoods.indexWhere((e) => e.barcode == widget.food.barcode) != -1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              try {
                await launch(OpenFoodFactsApi.getEditUrl(widget.food));
              } catch (_) {
                final snackBar = SnackBar(content: Text(context.i18n.browserOpeningError));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.food.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (widget.food.brands != null || widget.food.quantity != null)
                              Text(
                                '${widget.food.brands ?? ''}${widget.food.brands != null && widget.food.quantity != null ? ' - ' : ''}${widget.food.quantity ?? ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.subtitle2,
                              ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Stack(
                        children: [
                          Container(
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
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: Tap(
                              borderRadius: const BorderRadius.all(Radius.circular(36)),
                              onTap: () {
                                if (isInFavorites) {
                                  foodsState.removeFavoriteFood(widget.food);
                                } else {
                                  foodsState.addFavoriteFood(widget.food);
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
                        ],
                      ),
                    ],
                  ),
                  const Gap(32),
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
                        grade: widget.food.ecoscoreGrade,
                        height: 32,
                      ),
                    ],
                  ),
                  const Gap(8),
                  _ImpactLevelIndicator(name: context.i18n.production, level: widget.food.productionImpact),
                  _ImpactLevelIndicator(name: context.i18n.transportation, level: widget.food.transportationImpact),
                  _ImpactLevelIndicator(name: context.i18n.packaging, level: widget.food.packagingImpact),
                  const Gap(24),
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
                        grade: widget.food.nutriscoreGrade,
                        height: 42,
                      ),
                    ],
                  ),
                  const Gap(8),
                  _ImpactLevelIndicator(name: context.i18n.sugars, level: widget.food.sugarsLevel),
                  _ImpactLevelIndicator(name: context.i18n.fat, level: widget.food.fatLevel),
                  _ImpactLevelIndicator(name: context.i18n.saturatedFat, level: widget.food.saturatedFatLevel),
                  _ImpactLevelIndicator(name: context.i18n.salt, level: widget.food.saltLevel),
                  const Gap(32),
                  Text(
                    context.i18n.betterFoods,
                    style: context.textTheme.subtitle1,
                  ),
                  const Gap(8),
                ],
              ),
            ),
            _buildBetterFoods(context),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  SizedBox _buildBetterFoods(BuildContext context) {
    return SizedBox(
      height: FoodCard.minHeight,
      child: _betterFoodsLoading
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
          : _betterFoodsError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _fetchBetterFoods();
                        },
                        child: Text(context.i18n.retry),
                      ),
                    ],
                  ),
                )
              : _betterFoods.isEmpty
                  ? Center(
                      child: Text(
                        context.i18n.noAlternativeFound,
                        style: context.textTheme.bodyText1?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _betterFoods
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
                    ? Colors.orange
                    : level == ImpactLevel.high
                        ? Colors.red
                        : Colors.grey,
          ),
        ),
      ],
    );
  }
}
