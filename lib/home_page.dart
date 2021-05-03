import 'package:ecoscore/food_list_page.dart';
import 'package:ecoscore/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'common/extensions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var _currentPage = 0;
  final PageController _pageController = PageController();
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(begin: 64, end: 72).animate(_animationController);
    _animationController.repeat(reverse: true);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logo_full.svg',
          height: 64,
        ),
        backgroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FoodListPage(),
          const Center(
            child: Text('Fav to come'),
          ),
        ], // Comment this if you need to use Swipe.
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0,
        color: Colors.grey[200],
        child: Row(
          children: [
            _buildBottomBarItem(idx: 0, icon: Icons.history),
            const Gap(76),
            _buildBottomBarItem(idx: 1, icon: Icons.favorite),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return SizedBox(
            width: _animation.value,
            height: _animation.value,
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () => context.pushScreen(ScanPage()),
              backgroundColor: Colors.lightGreen,
              shape: CircleBorder(side: BorderSide(color: Colors.lightGreen[100]!, width: 6)),
              child: SvgPicture.asset(
                'assets/scanner.svg',
                height: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBarItem({required int idx, required IconData icon}) => Expanded(
        child: IconButton(
          icon: Icon(icon, color: _currentPage == idx ? Colors.lightGreen : Colors.grey),
          onPressed: () =>
              _pageController.animateToPage(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
        ),
      );
}
