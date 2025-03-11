import 'package:flutter/material.dart';
import 'package:frontendmobile/address/getaddress.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:frontendmobile/login/profile.dart';
import 'package:frontendmobile/login/sweethome.dart';
import 'package:frontendmobile/payment.dart/cart.dart';
import 'package:frontendmobile/process/historytour.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {

 
  final String? userid;
  const homepage({super.key,  this.userid});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  

  late final String userid;

  String? ii;

     @override
    void initState() {
    super.initState();
    userid = widget.userid ?? ""; 
  }

  


  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
   Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
  }



   void opencart(BuildContext context) async {
  



  
    Navigator.push(context, MaterialPageRoute(builder: (context) => const cartee()));
  
}

    void profi(BuildContext context) async {
   
      Navigator.push(context, MaterialPageRoute(builder: (context) => const profilepage()));
    
    
  }


void getaaddress(BuildContext context) async {
  

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Getaddress()), 
  );
}




   void history(BuildContext context) async {
    
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => const History()));
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Center(
        child:Column(
          children: [
            ElevatedButton(onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Sweethome()));
              }  , child: const Text("home")),
            TextButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const otproducts()));
              },
              child: const Text('Skip'),
            ),
            ElevatedButton(onPressed: () => opencart(context), child: const Text("Cart")),
            ElevatedButton(onPressed: () => profi(context) , child: const Text("Profile")),
            ElevatedButton(onPressed: () => history(context) , child: const Text("Track")),
            
          ],
        ),
      ),
    );
  }
}