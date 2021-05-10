import 'package:ecoscore/model/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.food.name,
                          style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.food.brands ?? ''}${widget.food.brands != null && widget.food.quantity != null ? ' - ' : ''}${widget.food.quantity ?? ''}',
                          style: context.textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  FoodIcon(food: widget.food, size: 96),
                ],
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
      ),
    );
  }
}
