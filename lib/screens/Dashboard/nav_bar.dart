import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/profile_page.dart';
import '../package_selection.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Home_page/new_home_page.dart';
import 'meals/meals.dart';
import 'notification/notification.dart';
import 'pack/pack.dart';

// Custom navigation bar item widget
class CustomNavItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final Color selectedBackgroundColor;

  const CustomNavItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    this.activeColor = const Color(0xffFFFDF9),
    this.inactiveColor = const Color(0xffFFFDF9),
    this.backgroundColor = const Color(0xff124734),
    this.selectedBackgroundColor = const Color(0xff0B3727),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: isSelected ? 10 : 5),
      decoration: BoxDecoration(
        color: isSelected ? selectedBackgroundColor : backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(imagePath, color: isSelected ? activeColor : inactiveColor),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Aeonik',
                  color: Color(0xffFFFDF9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class BottomNavbar extends StatefulWidget {
  final int selectedIndex;

  const BottomNavbar({Key? key, this.selectedIndex = 2}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const SelectedMeals(),
    const Packs(),
    NotificationsScreen(),
    const ProfileMenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable the back button
        return false;
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex), // Display the selected page
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Color(0xff124734),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _onItemTapped(0),
                  child: CustomNavItem(
                    imagePath: 'assets/images/nav_bar1.svg',
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onItemTapped(1),
                  child: CustomNavItem(
                    imagePath: 'assets/images/nav_bar2.svg',
                    label: 'Food',
                    isSelected: _selectedIndex == 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onItemTapped(2),
                  child: CustomNavItem(
                    imagePath: 'assets/icons/subscription.svg',
                    label: 'Pack',
                    isSelected: _selectedIndex == 2,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onItemTapped(3),
                  child: CustomNavItem(
                    imagePath: 'assets/images/nav_bar3.svg',
                    label: 'Alert',
                    isSelected: _selectedIndex == 3,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onItemTapped(4),
                  child: CustomNavItem(
                    imagePath: 'assets/images/nav_bar4.svg',
                    label: 'Profile',
                    isSelected: _selectedIndex == 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


