import 'package:ecoscore/food_list_page.dart';
import 'package:ecoscore/scan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'common/extensions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // To avoid the FAB to be visible when the keyboard is up
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Avoid a gesture conflict with the search bar
        children: [
          FoodListPage(),
          const Center(
            child: Text('Fav to come'),
          ),
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
              _buildBottomBarItem(idx: 0, icon: CupertinoIcons.house_fill, name: 'Accueil'),
              const Gap(76),
              _buildBottomBarItem(idx: 1, icon: CupertinoIcons.heart_fill, name: 'Favorite'),
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
          child: SvgPicture.asset(
            'assets/scanner.svg',
            height: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem({required int idx, required IconData icon, required String name}) => Expanded(
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () => _pageController.animateToPage(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: _currentPage == idx ? Theme.of(context).primaryColor : Colors.black26),
                Text(
                  name,
                  style: context.textTheme.subtitle2?.copyWith(
                    color: _currentPage == idx ? Theme.of(context).primaryColor : Colors.black26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
