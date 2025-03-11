import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/address/getaddress.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:frontendmobile/login/social.dart';
import 'package:frontendmobile/process/historytour.dart';
import 'package:frontendmobile/shimmer/nodata.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class profilepage extends StatefulWidget {


  const profilepage({super.key,});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {

  Map<String, dynamic>? user;
  Map<String, dynamic>? userpers;
  String? userid;
  bool isLoading = true;

  @override
  void initState(){
    getserid();
    super.initState();
  }

  Future<void> getserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('phone');

    if (storedUserId != null) {
        setState(() {
          userid = storedUserId;
        });
      print("User ID: $userid");
      await fetchallacc();
      await fetchallper();
    } else {
      print("No User ID Found!");
    }
     setState(() {
      isLoading = false; 
    });
  }

  Future<void> fetchallacc() async {
    if (userid == null) return;
    try{
      final Uri url = Uri.parse("$backendurl/user");
      final response = await http.get(url);
    
    print(userid);

    if(response.statusCode == 200){
      List<dynamic> userlist = json.decode(response.body);

      var filter = userlist.firstWhere((user) => user['usernum'].toString() == userid, orElse: () => null);

      if(filter != null){
        setState(() {
          user = filter;
        });
      }else{
        print("No user");
      }

    }else{
      print("Failed to etch");
    }
    }catch(err){
      print("Error fecthing  $err");
    }
  }

  void confirmation (BuildContext context){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: "Log Out",
      desc: "Are sure to log out?",
      btnCancelText: "Nope!",
      btnOkText: "Yaa..",
      btnCancelOnPress: (){},
      btnOkOnPress: (){
        logout(context);
      }
    ).show();
  }



    Future<void> fetchallper() async {
    try{
      final Uri url = Uri.parse("$backendurl/profile");
      final response = await http.get(url);
      

    if(response.statusCode == 200){
      List<dynamic> userlist = json.decode(response.body);

      var filter = userlist.firstWhere((user) => user['cusphonenumber'].toString() == userid, orElse: () => null);
      print(filter);
      if(filter != null){
        setState(() {
          userpers = filter;
        });
      }else{
        print("No user");
      }

    }else{
      print("Failed to etch");
    }
    }catch(err){
      print("Error fecthing  $err");
    }
  }

    Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
  }

  Future<bool> _showExitConfirmation() async {
          bool? exitConfirmed = await AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            title: 'Exit Confirmation',
            desc: 'Are you sure you want to exit?',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.of(context).pop(true); // Exit
            },
          ).show();

          return exitConfirmed ?? false;
        }


@override
Widget build(BuildContext context) {
  // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  return GestureDetector(
     onTap: () {
        FocusScope.of(context).unfocus(); 
      },
    child: WillPopScope(
      onWillPop: () async {
          return await _showExitConfirmation();
        },
      child: Scaffold(
        appBar: AppBar(
          shadowColor:  const Color.fromARGB(255, 180, 185, 185) ,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25), // Adjust the curve here
              ),
            ),
          title: const Text("Personal Page"),
          elevation: width*0.02,
          toolbarHeight: width*0.2,
          backgroundColor: const Color.fromARGB(255, 241, 51, 98),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          
        ),
        body: isLoading? const Center(child: Text("Loading....Please wait")) : userpers == null?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Nodata(),
            SizedBox(height: width*0.03,),
            ElevatedButton(onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const login()));},
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      minimumSize: Size(width *0.2, width * 0.09),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login or Create Account to Explore", style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: width*0.03,) ),),
                SizedBox(width: width*0.01,),
                Icon(Icons.login_rounded, color: Colors.white, size: width*0.03,)
              ],
            ),)
          ],
        )):
        
        SingleChildScrollView(
          child: user == null
              ? const Center(child: CircularProgressIndicator()) 
              : Padding(
                  padding:  const EdgeInsets.all(16),
                  child: Container(
                    margin: EdgeInsets.all(width*0.02),
                    padding: EdgeInsets.all(width*0.04),
                    width: width,
                    decoration: BoxDecoration(
                     color: const Color.fromARGB(255, 251, 248, 252),
                     
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 172, 170, 170,), spreadRadius: 1, blurRadius: 3
                        )
                      ],
                      borderRadius: BorderRadius.circular(width*0.02)
                    ),
                    child: Column(
                      
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: width*0.2,
                            
                            backgroundColor: const Color.fromARGB(255, 0, 212, 240),
                            child: Icon(Icons.person ,size: width*0.2, color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        
                        Text("${userpers?['cusname'] ?? 'Not available'}", style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color.fromARGB(255, 90, 90, 90), fontSize: width*0.04))),
                        Text("${user!['mail']}",style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color.fromARGB(255, 90, 90, 90), fontSize: width*0.03))),
                        SizedBox(height: width*0.04,),
                        
                        each(Icons.call ,"${user!['usernum']}"),
                        each(Icons.person ,"${userpers!['cusgender']}"),
                        each(FontAwesomeIcons.house ,"${userpers!['cuscity']}"),
                        InkWell(
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => Getaddress(userid: userid)));
                          },
                          child: each(Icons.location_pin ,"Address")),
                        InkWell(
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const History()));
                          },
                          child: each(Icons.track_changes,"Tracker")),
                        InkWell(
                          onTap: () => confirmation(context),
      
                           child: each(Icons.logout,"Log Out")),
                        SizedBox(height: width*0.1,),
                        SizedBox(
                          height: width*0.8,
                          child: const Social())
                        
          
                        
                       
                      ],
                    ),
                  ),
                ),
        ),
      ),
    ),
  );
}

            Container each(IconData icon, String title ) {
              // ignore: unused_local_variable
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;
              return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 247, 255),
                    
                    boxShadow: const [BoxShadow(color: Color.fromARGB(255, 187, 184, 184),spreadRadius: 1,  offset: Offset(0, 3),
                    blurRadius: 5, )],
                    borderRadius: BorderRadius.circular(50)
                  ),
                  margin: EdgeInsets.all(width*0.03),
                  padding: EdgeInsets.all(width*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: width*0.05, color: const Color.fromARGB(255, 241, 51, 98),),
                      SizedBox(width: width*0.02),
                      Text(title,style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color.fromARGB(255, 119, 117, 117), fontSize: width*0.03))),
                    ],
                  ),
                );
              }

}