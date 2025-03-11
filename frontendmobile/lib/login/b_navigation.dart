import 'package:flutter/material.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/login/profile.dart';
import 'package:frontendmobile/login/sweethome.dart';
import 'package:frontendmobile/payment.dart/cart.dart';
import 'package:frontendmobile/process/historytour.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:google_fonts/google_fonts.dart';

class navigation extends StatefulWidget {
  const navigation({super.key});

  @override
  State<navigation> createState() => _NavigationState();
}

class _NavigationState extends State<navigation> {
  int touchedPage = 0;
  final PageController _pageController = PageController();

  final List<Widget> screens = [
    const Sweethome(),
    const otproducts(),
    cartee(key: UniqueKey()),
    const History(),
    const profilepage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      touchedPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 243, 62, 107),
        ),
        child: Container(
          height: height * 0.09,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 133, 131, 131),
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: touchedPage,
              unselectedLabelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: width * 0.02, color: Colors.white),
              ),
              onTap: onTabTapped,
              selectedItemColor: Colors.white,
              showSelectedLabels: true,
              unselectedIconTheme: const IconThemeData(color: Colors.white),
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: buildIcon(Icons.home_filled, 0),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: buildIcon(FontAwesomeIcons.fish, 1),
                  label: "Products",
                ),
                BottomNavigationBarItem(
                  icon: buildIcon(Icons.shopping_cart, 2),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: buildIcon(FontAwesomeIcons.truck, 3),
                  label: "Tracker",
                ),
                BottomNavigationBarItem(
                  icon: buildIcon(Icons.person, 4),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIcon(IconData icon, int index) {
    double width = MediaQuery.of(context).size.width;
    bool isSelected = touchedPage == index;
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.pink : Colors.white,
        size: width * 0.04,
      ),
    );
  }
}
