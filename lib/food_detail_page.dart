import 'package:ecoscore/model/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
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
  var _betterFoodsError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchBetterAlternatives();
    });
  }

  void _fetchBetterAlternatives() {
    observeFuture<List<Food>>(OpenFoodFactsApi.getBetterFoods(widget.food), (betterFoods) {
      setState(() {
        _betterFoods = betterFoods;
      });
    }, onError: (_) {
      _betterFoodsError = true;
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
            icon: Icon(
              isInFavorites ? Icons.favorite : Icons.favorite_outline,
              color: Colors.red[400],
            ),
            onPressed: () {
              if (isInFavorites) {
                foodsState.removeFavoriteFood(widget.food);
              } else {
                foodsState.addFavoriteFood(widget.food);
              }
            },
          ),
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
                      Hero(
                        tag: widget.food.barcode,
                        child: FoodIcon(food: widget.food, size: 128),
                      ),
                    ],
                  ),
                  const Gap(32),
                  Text(
                    context.i18n.environmentalImpact,
                    style: context.textTheme.subtitle1,
                  ),
                  const Gap(8),
                  SvgPicture.asset(
                    'assets/ecoscore-${widget.food.ecoscoreGrade ?? 'unknown'}.svg',
                    height: 24,
                  ),
                  const Gap(32),
                  Text(
                    context.i18n.nutritionalValues,
                    style: context.textTheme.subtitle1,
                  ),
                  const Gap(8),
                  SvgPicture.asset(
                    'assets/nutriscore-${widget.food.nutriscoreGrade ?? 'unknown'}.svg',
                    height: 32,
                  ),
                  const Gap(32),
                  Text(
                    context.i18n.betterFoods,
                    style: context.textTheme.subtitle1,
                  ),
                  const Gap(8),
                ],
              ),
            ),
            if (_betterFoodsError)
              ElevatedButton(
                onPressed: () {
                  _fetchBetterAlternatives();
                },
                child: Text('Retry'),
              )
            else
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _betterFoods
                      .map((food) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              width: 296,
                              child: FoodCard(
                                food: food,
                                onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
