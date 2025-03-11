import 'package:flutter/material.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Personall extends StatefulWidget {
  final String usernum;
  final Map<String, dynamic>? prodet;


  const Personall({super.key, required this.usernum, this.prodet});

  @override
  State<Personall> createState() => _PersonallState();
}

class _PersonallState extends State<Personall> {
  final TextEditingController cusname = TextEditingController();
  String cusgender = "";
  final TextEditingController cuscity = TextEditingController();
  final TextEditingController cusphonenumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    cusphonenumber.text = widget.usernum;
  }

  Future<void> createprofile(BuildContext context) async {
    print("${cusname.text} $cusgender ${cuscity.text} ${cusphonenumber.text}");

    if (cusname.text.isEmpty ||
        cusgender.isEmpty ||
        cuscity.text.isEmpty ||
        cusphonenumber.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please Fill All Fields")));
      return;
    }

    final url = Uri.parse("$backendurl/profile");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "cusname": cusname.text,
          "cusgender": cusgender,
          "cuscity": cuscity.text,
          "cusphonenumber": cusphonenumber.text,
        }),
      );

      print(response.body);

      if (response.statusCode == 201) {
        if (mounted) {
          
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => login(prodet : widget.prodet)));
        }
      } else {
        final responsedata = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responsedata['message'] ?? 'Profile failed')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to connect to server")));
    }
  }

  @override
  Widget build(BuildContext context) {

         // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
          backgroundColor: Colors.black,
        appBar: AppBar( iconTheme: const IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            side: BorderSide(color: Color.fromARGB(255, 255, 0, 0), width: 2,)
          ),
          
      
          centerTitle: true,
          title:Text("Create Account", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.03 ),),),
        
        body: Stack(
         children: [ 
      
             Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image : AssetImage("asset/wall2.jpg"),fit: BoxFit.cover,)
              ),
            ),
      
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width*0.09,),
                height: 700,
                width: width * 0.9, 
                padding: EdgeInsets.symmetric(horizontal: width*0.09, vertical: width*0.09),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: width*0.06 ),
                      
                      child: Text("Personal Info",textAlign: TextAlign.left, style: GoogleFonts.poppins(textStyle: TextStyle( color : Colors.white, fontSize: width*0.07, fontWeight: FontWeight.w400, ), ))),
                    TextField(
                      controller: cusphonenumber,
                      readOnly: true,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.phone_android, color: Colors.white,),),
                        
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
                    SizedBox(height: width*0.04),
                    TextField(
                      controller: cusname,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Name*',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.person, color: Colors.white,),),
                        
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
                
                    SizedBox(height: width*0.04),
                
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: width*0.02),
                        child: Text("Gender(optional)", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.03)),
                      ),
                       RadioListTile(
                      title: Text("Male",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: width*0.03))),
                      value: "Male",
                      groupValue: cusgender,
                      onChanged: (value) {
                        setState(() {
                          cusgender = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Female",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: width*0.03))),
                      value: "Female",
                      groupValue: cusgender,
                      onChanged: (value) {
                        setState(() {
                          cusgender = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Others",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: width*0.03))),
                      value: "Others",
                      groupValue: cusgender,
                      onChanged: (value) {
                        setState(() {
                          cusgender = value!;
                        });
                      },
                    ),
                    ],
                  ),
                   
                
                    SizedBox(height: width*0.04),
                    TextField(
                      controller: cuscity,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'City*',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.location_on_sharp, color: Colors.white,),),
                        
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
                
                    SizedBox(height: width*0.06),
                
                    Padding(
                      padding:  EdgeInsets.only(left: width*0.07),
                      child: Ink(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Color.fromARGB(255, 9, 143, 92), Color.fromARGB(255, 8, 119, 76)])
                          ),
                        child: ElevatedButton(
                          onPressed: () => createprofile(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(width*0.6, width*0.09)
                          ),
                          child: const Text("Create Profile"),
                        ),
                      ),
                    ),
                
                     SizedBox(height: width*0.05),
                
                     Padding(
                       padding: EdgeInsets.only(left: width*0.07),
                       child: Ink(
                         child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const login()) );
                          },
                           style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 221, 0, 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(width*0.6, width*0.09),
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                          ),
                          child: Text("Skip",style: GoogleFonts.poppins(textStyle: TextStyle( fontSize: width*0.03))),
                                           ),
                       ),
                     ),
                  ],
                ),
              ),
            ),]
        ),
      ),
    );
  }
}
