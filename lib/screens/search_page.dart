import 'package:dartx/dartx.dart';
import 'package:ecoscore/api/open_food_facts_api.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/food_widgets.dart';
import 'package:ecoscore/common/observer_state.dart';
import 'package:ecoscore/common/search_bar.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'food_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ObserverState<SearchPage> {
  var _hasEmptyQuery = true;
  var _isSearching = false;
  var _hasError = false;
  List<Food>? _searchResults;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
              child: SearchBar(
                autofocus: true,
                showBackButton: true,
                isSearching: _isSearching,
                onTyping: () => setState(() {
                  _isSearching = true;
                }),
                onQueryChanged: (query) {
                  setState(() {
                    _isSearching = query.isNotEmpty;

                    if (query.isEmpty) {
                      _hasEmptyQuery = true;
                      _isSearching = false;
                      _searchResults = [];
                    } else {
                      _hasEmptyQuery = false;
                      _isSearching = true;
                      observeFuture<List<Food>>(
                        OpenFoodFactsApi.search(query),
                        (foods) => setState(() {
                          _searchResults = foods;
                          _scrollController.jumpTo(0);
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
                      subtitle: _hasError
                          ? context.i18n.searchError
                          : _searchResults == null || _hasEmptyQuery
                              ? ''
                              : context.i18n.noSearchResult),
                ),
                secondChild: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 4, left: 24, right: 24, bottom: 24),
                  children: _searchResults
                          ?.map((food) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: FoodCard(
                                  food: food,
                                  onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                                ),
                              ))
                          .toList() ??
                      [],
                ),
                crossFadeState: _hasError || _hasEmptyQuery || _searchResults.isNullOrEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: 200.milliseconds,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
