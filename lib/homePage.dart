import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/view/goal_feature/goal_grid_list.dart';
import 'package:habbits_manager/view/statistics_feature/main_stats_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    GoalList(),
    MainStatsPage(),
  ];

  void pageChanged(index) {
    setState(() {
      _selectedPage = index;
    });
  }

  final controller = PageController(
    initialPage: 0,
  );

  void _onTabTapped(int page) {
    setState(() {
      _selectedPage = page;
      controller.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: _widgetOptions,
        onPageChanged: (idx) => pageChanged(idx),
      ),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF481550),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.flag,
                size: 20.0,
              ),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.show_chart,
                size: 20.0,
              ),
              label: 'Statistics',
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Color(0xFFfdb561),
          unselectedItemColor: Colors.white,
          onTap: (page) => _onTabTapped(page),
        ),
      ),
    );
  }
}
