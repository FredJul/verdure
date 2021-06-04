import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'extensions.dart';

typedef OnQueryChangedCallback = void Function(String query);

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.autofocus = false,
    this.showBackButton = false,
    this.isSearching = false,
    this.debounceDelay = const Duration(seconds: 2),
    this.onTyping,
    this.onQueryChanged,
  }) : super(key: key);

  final bool autofocus;
  final bool showBackButton;
  final bool isSearching;
  final Duration debounceDelay;
  final VoidCallback? onTyping;
  final OnQueryChangedCallback? onQueryChanged;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    const tag = 'search_bar_key';

    return Hero(
      tag: tag,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Material(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TextField(
                textInputAction: TextInputAction.search,
                controller: _searchController,
                autofocus: widget.autofocus,
                onChanged: (query) {
                  EasyDebounce.cancel(tag);

                  setState(() {}); // Needed to update icons display

                  if (query.isEmpty) {
                    widget.onQueryChanged?.call(query);
                  } else {
                    widget.onTyping?.call();

                    EasyDebounce.debounce(
                      tag,
                      widget.debounceDelay,
                      () => widget.onQueryChanged?.call(query),
                    );
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  hintText: context.i18n.searchHint,
                  fillColor: Colors.grey[100],
                  prefixIcon: widget.showBackButton
                      ? IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.grey[800],
                          icon: Icon(Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Platform.isAndroid ? Icons.search : CupertinoIcons.search,
                            color: Colors.grey[800],
                          ),
                        ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          onPressed: () => setState(() {
                            EasyDebounce.cancel(tag);

                            _searchController.clear();
                            widget.onQueryChanged?.call('');
                          }),
                          color: Colors.grey[800],
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
              if (widget.isSearching)
                const SizedBox(
                  height: 2.75,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
