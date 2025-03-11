import 'package:flutter/material.dart';
import 'package:frontendmobile/login/b_navigation.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<Offset> animation;
  
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    
    animation = Tween<Offset>(
      begin: const Offset(0, 1), 
      end: Offset.zero, 
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');

     await Future.delayed(const Duration(seconds: 4));
    
    if (phone != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const navigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: SlideTransition(
        position: animation,
        child:  Container(
          height: height,
          width: width,
           decoration: BoxDecoration(
             image: DecorationImage(image: AssetImage("asset/splashrestore.jpeg", ), fit: BoxFit.cover,)
           ),
        )
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}