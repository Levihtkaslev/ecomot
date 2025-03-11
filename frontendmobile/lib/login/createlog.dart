import 'package:flutter/material.dart';
import 'package:frontendmobile/login/personal.dart';
import 'package:frontendmobile/statics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Createacc extends StatefulWidget {

  final Map<String, dynamic>? prodet;
  const Createacc({super.key, this.prodet});

  @override
  State<Createacc> createState() => _CreateaccState();
}

class _CreateaccState extends State<Createacc> {
  final TextEditingController usernum = TextEditingController();

  final TextEditingController pass = TextEditingController();

  final TextEditingController mail = TextEditingController();

  final TextEditingController conpass = TextEditingController();

  bool dontshowpass = true;

  Future<void> register(BuildContext context) async {
    if(pass.text != conpass.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password not as confirm pass"),));
      return;
    }


    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text("Creating account..."),
            ],
          ),
        );
      },
    );

    final Url = Uri.parse('$backendurl/user');
    final response = await http.post(
      Url,
      headers: {"Content-Type":"application/json"},
      body: json.encode({
        "usernum" : usernum.text,
        "pass" : pass.text,
        "mail" : mail.text
      })
    );

    Navigator.pop(context);
    
    if (response.statusCode == 201){
      
        Navigator.push(context, MaterialPageRoute(builder: (context) => Personall(usernum : usernum.text, prodet : widget.prodet)));
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success!',
              text: 'Account created Successfully',
            );
      
    }else {
      final responsedata = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responsedata['message'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
        // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
     bool dontshowpass = true;
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            side: BorderSide(color: Color.fromARGB(255, 255, 0, 0), width: 2,)
          ),
          
      
          centerTitle: true,
          title: Text("Create Account", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.03 ),),
          
          ),
          
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
                height: 500,
                width: width * 0.9, 
                padding: EdgeInsets.symmetric(horizontal: width*0.09, vertical: width*0.09),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: width*0.07 ),
                      
                      child: Text("Create Account",textAlign: TextAlign.left, style: GoogleFonts.poppins(textStyle: TextStyle( color : Colors.white, fontSize: width*0.07, fontWeight: FontWeight.w400, ), ))),
                    TextField(
                      controller: usernum,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Phone Number(Your ID)*',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.person, color: Colors.white,),),
                        
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
      
                    SizedBox(height: width*0.04),
                    
                    TextField(
                      controller: pass,
                      cursorColor: Colors.white,
                      obscureText: dontshowpass,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Password*',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.shield_sharp, color: Colors.white,),),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: width*0.01, left: width*0.02), 
                          child: IconButton(onPressed: () {
                            setState(() {
                            dontshowpass = !dontshowpass;
                          // ignore: dead_code
                          });} , icon: Icon(dontshowpass? Icons.visibility : Icons.visibility_off, color: Colors.white,) ),),
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
      
                    
                    TextField(
                      controller: conpass,
                      cursorColor: Colors.white,
                      obscureText: dontshowpass,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password*',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.shield_sharp, color: Colors.white,),),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: width*0.01, left: width*0.02), 
                          child: IconButton(onPressed: () {setState(() {
                            dontshowpass = !dontshowpass;
                          });} , icon: Icon(dontshowpass? Icons.visibility : Icons.visibility_off, color: Colors.white,) ),),
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
      
                    SizedBox(height: width*0.04),
      
                    TextField(
                      controller: mail,
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                      decoration: InputDecoration(
                        labelText: 'Mail ID(optional)',
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.mail , color: Colors.white,),),
                        
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                        ),
                    ),
      
                    Text("(We will send your ID and password to your Mail-ID if you provided)", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.02),),
                     SizedBox(height: width*0.05),
                    Padding(
                      padding: EdgeInsets.only(left: width*0.07),
                      child: Ink(
                        child: ElevatedButton(onPressed: () => register(context), 
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 221, 0, 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(width*0.6, width*0.09),
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                          ),
                        child: Text("Create", style: GoogleFonts.poppins(textStyle: TextStyle( fontSize: width*0.03))))),
                    )
                  ],
                ),
              ),
            ),]
        ),
      ),
    );
  }
}