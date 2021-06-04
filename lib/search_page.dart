import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api/open_food_facts_api.dart';
import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/observer_state.dart';
import 'common/search_bar.dart';
import 'common/widgets.dart';
import 'food_detail_page.dart';
import 'gen/assets.gen.dart';
import 'model/food.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ObserverState<SearchPage> {
  var _hasEmptyQuery = true;
  var _isSearching = false;
  var _hasError = false;
  var _searchResults = List<Food>.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 8,
            ),
            child: SearchBar(
              autofocus: true,
              showBackButton: true,
              isSearching: _isSearching,
              onQueryChanged: (query) {
                setState(() {
                  _isSearching = query.isNotEmpty;

                  if (query.isEmpty) {
                    _hasEmptyQuery = true;
                    _isSearching = false;
                    _searchResults.clear();
                  } else {
                    _hasEmptyQuery = false;
                    _isSearching = true;
                    observeFuture<List<Food>>(
                      OpenFoodFactsApi.search(query),
                      (foods) => setState(() {
                        _searchResults = foods;
                        _isSearching = false;
                        _hasError = false;
                      }),
                      onError: (_) => setState(() {
                        _isSearching = false;
                        _hasError = true;
                      }),
                    );
                  }
                });
              },
            ),
          ),
          Expanded(
            child: AnimatedCrossFade(
              firstChild: Center(
                child: EmptyView(
                    icon: Assets.search,
                    subtitle: _hasEmptyQuery
                        ? ''
                        : _hasError
                            ? context.i18n.searchError
                            : context.i18n.noSearchResult),
              ),
              secondChild: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                children: _searchResults
                    .map((food) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: FoodCard(
                            food: food,
                            onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                          ),
                        ))
                    .toList(),
              ),
              crossFadeState:
                  _hasError || _hasEmptyQuery || _searchResults.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: 200.milliseconds,
            ),
          ),
        ],
      ),
    );
  }
}
