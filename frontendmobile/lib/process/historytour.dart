import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:frontendmobile/process/subhistory.dart';
import 'package:frontendmobile/shimmer/nodata.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {

  
  const History({super.key, });

  @override
  State<History> createState() => _historyState();
}

class _historyState extends State<History> {

  List<Map<String, dynamic>> cartlist = [];
  bool load = true;
   String? userid;
  

  @override
  void initState(){
    super.initState();
    getserid();
  }

    Future<void> getserid() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserId = prefs.getString('phone');

      if (storedUserId != null) {
          setState(() {
            userid = storedUserId;
          });
        print("User ID: $userid");
        await fetchbuyhistory();
      } else {
        print("No User ID Found!");
      }
      setState(() {
        load = false; 
      });
    }

  Future<void> fetchbuyhistory() async{

   final Uri url = Uri.parse("$backendurl/buy?userid=$userid");
  

    try{
      final history = await http.get(url);

      if(history.statusCode == 200){
        List<dynamic> history1 = json.decode(history.body);
        
        setState(() {
          cartlist = List<Map<String, dynamic>>.from(history1);
          load = false;
        });

       

      }else{
        print("Error fetchin details history");
      }
    }catch(e){
      print("Error fetchin details history $e");
    }
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
              Navigator.of(context).pop(true); 
            },
          ).show();

          return exitConfirmed ?? false;
        }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
         onTap: () {
        FocusScope.of(context).unfocus(); 
      },
        child: WillPopScope(
          onWillPop: () async {
          return await _showExitConfirmation();
        },
          child: Scaffold(
            appBar: AppBar(
              title:  Text("History",style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.06 )),
              iconTheme: const IconThemeData(
              color: Colors.white,
             ),
             shadowColor:  const Color.fromARGB(255, 176, 177, 177) ,
             backgroundColor: const Color.fromARGB(255, 241, 51, 98),
             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
              bottom:  TabBar(
                
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.white,
                labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.04)),
                tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Tab(text: "Pending",), 
                  SizedBox(width: width*0.04,),
                  Icon(FontAwesomeIcons.solidHourglassHalf, size: width*0.05,)]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Tab(text: "Complete"),
                    SizedBox(width: width*0.04,),
                  Icon(FontAwesomeIcons.circleCheck, size: width*0.05,)
                  ],
                ),
                Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Tab(text: "canceled"),
                    SizedBox(width: width*0.04,),
                    Icon(FontAwesomeIcons.triangleExclamation, size: width*0.05,)
                  ],
                ),
              ]),
              ),
          
            body: userid == null?  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Nodata(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              minimumSize: Size(width *0.5, width * 0.09),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const otproducts()));
                        } 
                        ,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Eplore Products to track "),
                                SizedBox(width: width*0.01,),
                        Icon(Icons.login_rounded, color: Colors.white, size: width*0.03,)
                          ],
                        )
                      ),
                    ],
          
              ) : load? const Center(child: Nodata(),)
            
                                      :
            
                  GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.right,
                    color: const Color.fromARGB(255, 245, 114, 157),
                    child: Container(
                      padding: EdgeInsets.all(width*0.03),
                      child: TabBarView(children: [
                        buildbody('pending'),
                        buildbody('complete'),
                        buildbody('canceled'),
                      ]),
                    ),
                  )
            ,
            ),
        ),
      )
    );
  }

  Widget buildbody(String status){
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Map<String, dynamic>> filtered = cartlist.where((item) => item['itemstatus'] == status).toList();

     if (filtered.isEmpty) {
      return Center(child: Nodata());
    }

    return ListView.builder(
      
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        var item = filtered[index];

        return Container(
          margin: EdgeInsets.all(width*0.03),
          padding: EdgeInsets.all(width*0.03),
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(
              color:  Color.fromARGB(255, 175, 174, 174), blurRadius: 4, spreadRadius: 1, offset: Offset(0, 3),
            )],
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 251, 244, 253
            ),),
          child: ListTile(
            title: Text(item["itemname"], style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.04, color: const Color.fromARGB(255, 85, 85, 85))),),
            subtitle: Row(
              children: [
                Text("Time: ${item["itemtime"]}",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 85, 85, 85)))),
                SizedBox(width: width*0.02,),
                Icon(FontAwesomeIcons.calendar, size: width*0.03,color: const Color.fromARGB(255, 85, 85, 85))
              ],
            ),
            trailing: Icon(FontAwesomeIcons.chevronRight, color: const Color.fromARGB(255, 241, 51, 98), size: width*0.04,),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => subhis(cartdetails : item['cartdetails']) ));
            },
          ),
        );
      }
      );
  }
}