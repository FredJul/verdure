import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';

import 'api/open_food_facts_api.dart';
import 'common/extensions.dart';
import 'common/food_card.dart';
import 'common/observer_state.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _betterFoodsError
          ? ElevatedButton(
              onPressed: () {
                _fetchBetterAlternatives();
              },
              child: Text('Retry'),
            )
          : SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _betterFoods
                    .map((food) => SizedBox(
                          width: 296,
                          child: FoodCard(
                            food: food,
                            onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                          ),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
