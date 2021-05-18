import 'package:easy_debounce/easy_debounce.dart';
import 'package:ecoscore/api/open_food_facts_api.dart';
import 'package:ecoscore/common/observer_state.dart';
import 'package:ecoscore/food_detail_page.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'model/foods_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ObserverState<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = FloatingSearchBarController();
  var _isLoading = false;
  var _searchResults = List<Food>.empty();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _searchController.close();
    });

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible && _searchController.query.isEmpty) {
        _searchController.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return Portal(
      child: ListView(
        controller: _scrollController,
        children: [
          const Gap(24),
          Assets.logoFull.svg(height: 64),
          const Gap(24),
          PortalEntry(
            portalAnchor: Alignment.topLeft,
            childAnchor: Alignment.topLeft,
            portal: _buildSearchBar(context),
            child: const Gap(72),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen[50],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
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
                          Text(context.i18n.learnMore),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              context.i18n.scannedProducts,
              style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(8),
          ...foodsState.scannedFoods.reversed.map((food) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: FoodCard(
                  food: food,
                  onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                ),
              )),
          const Gap(48),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) => FloatingSearchBar(
        margins: const EdgeInsets.symmetric(horizontal: 24),
        controller: _searchController,
        backgroundColor: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        elevation: 0,
        backdropColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
        scrollPadding: const EdgeInsets.only(top: 8, bottom: 232),
        onQueryChanged: (query) {
          EasyDebounce.cancel('search_key');

          if (query.isEmpty) {
            setState(() {
              _isLoading = false;
              _searchResults = [];
            });
          } else {
            setState(() {
              _isLoading = true;
            });

            EasyDebounce.debounce(
              'search_key',
              const Duration(seconds: 2),
              () => observeFuture<List<Food>>(
                OpenFoodFactsApi.search(query),
                (foods) => setState(() {
                  _searchResults = foods;
                  _isLoading = false;
                }),
                onError: (_) {
                  //TODO
                },
              ),
            );
          }
        },
        progress: _isLoading,
        transition: CircularFloatingSearchBarTransition(),
        hint: context.i18n.searchHint,
        builder: (context, transition) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: _searchResults
                .map((food) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: FoodCard(
                        food: food,
                        onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                      ),
                    ))
                .toList(),
          );
        },
      );
}
