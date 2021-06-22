import 'package:dartx/dartx.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'favorites_page.dart';
import 'home_page.dart';
import 'scan_page.dart';

final _currentPageProvider = StateProvider((ref) => 0);

final _pageControllerProvider = Provider<PageController>((ref) {
  final pageController = PageController();
  pageController.addListener(() {
    ref.read(_currentPageProvider).state = pageController.page?.toInt() ?? 0;
  });

  return pageController;
});

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.read(_pageControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false, // To avoid the FAB to be visible when the keyboard is up
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(), // Avoid a gesture conflict with the search bar
        children: [
          HomePage(),
          FavoritesPage(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 16),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 0,
          child: Row(
            children: [
              _BottomBarItem(idx: 0, icon: CupertinoIcons.house_fill, name: context.i18n.homeTitle),
              const Gap(76),
              _BottomBarItem(idx: 1, icon: Icons.favorite, name: context.i18n.favoriteTitle),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(155),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () => context.pushScreen(ScanPage()),
          child: Assets.scanner.svg(height: 24),
        ),
      ),
    );
  }
}

class _BottomBarItem extends ConsumerWidget {
  final int idx;
  final IconData icon;
  final String name;

  const _BottomBarItem({Key? key, required this.idx, required this.icon, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.read(_pageControllerProvider);
    final currentPage = ref.watch(_currentPageProvider).state;

    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () => pageController.animateToPage(idx, duration: 300.milliseconds, curve: Curves.easeInOut),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: currentPage == idx ? Theme.of(context).primaryColor : Colors.black26),
              Text(
                name,
                style: context.textTheme.subtitle2?.copyWith(
                  color: currentPage == idx ? Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
