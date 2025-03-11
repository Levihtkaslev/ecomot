import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:frontendmobile/login/b_navigation.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:frontendmobile/login/createlog.dart';
import 'package:frontendmobile/process/productdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class login extends StatefulWidget {

  final Map<String, dynamic>? prodet;
  const login({super.key, this.prodet});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  // const login({super.key});
  final TextEditingController usernum = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool forgetpass = false;
  bool dontshowpass = true;

  Future<void> loging(BuildContext context) async {
    final Url = Uri.parse('$backendurl/loging');
    final response = await http.post(
      Url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usernum': usernum.text,
        'pass': pass.text,
      }),
    );

    if(response.statusCode == 200) {
      SharedPreferences pref =await SharedPreferences.getInstance();
      pref.setString('phone', usernum.text);

      


      
      if(widget.prodet != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => productdetails(prodet : widget.prodet! )));
      }else{
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const navigation()),
                );
      }

       
    }else{
      final responsedata = json.decode(response.body);
          showTopSnackBar(
                              Overlay.of(context),
                               CustomSnackBar.error(
                                message:
                                    responsedata['message'] ?? 'Login Failed',
                              ),
                            );
    }
  }

  Future<void> registerdetail(BuildContext context) async {
    
    final Url = Uri.parse('$backendurl/forgetpass');
    final response = await http.post(
      Url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usernum' : usernum.text
       })
      );

      final responsedata = json.decode(response.body);

    if(response.statusCode == 200) {
      showbox(context, responsedata['email']?? "No email found", responsedata['time']?? "time found");
    }else {
          showTopSnackBar(
                              Overlay.of(context),
                               CustomSnackBar.error(
                                message:
                                    responsedata['message'] ?? 'User not found',
                              ),
                            );
    }

  }

  void showbox(BuildContext context, String mail, String time){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: "Password Info",
      desc: "We have sent password in $mail at $time. Please check it.",
       btnOkOnPress: () {
        closestate();  
      },
      btnOkText: "Ok",
      btnOkColor: Colors.blue,
    ).show();
  }

  void closestate() {
    setState(() {
      forgetpass = false;
      usernum.text = "";
    });
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
    return 

    GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); 
      },
      child: WillPopScope(
        onWillPop: () async {
          return await _showExitConfirmation();
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/wall1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width*0.09),
                  width: width * 0.9, 
                  padding: EdgeInsets.symmetric(horizontal: width*0.09, vertical: width*0.09),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      Container(
                        margin: EdgeInsets.symmetric(vertical: width*0.07 ),
                        
                        child: Text("Log In",textAlign: TextAlign.left, style: GoogleFonts.poppins(textStyle: TextStyle( color : Colors.white, fontSize: width*0.07, fontWeight: FontWeight.w400, ), ))),
                      
                      TextField(
                        controller: usernum,
                        cursorColor: Colors.white,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                        decoration: InputDecoration(
                          labelText: 'Phone Number*',
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
                            child: IconButton(onPressed: () {setState(() {
                              dontshowpass = !dontshowpass;
                            });} , icon: Icon(dontshowpass? Icons.visibility : Icons.visibility_off, color: Colors.white,) ),),
                          enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                          focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                          ),
                          
                      ),
                      SizedBox(height: width*0.09),
                                  
                                  
                      Padding(
                        padding:  EdgeInsets.only(left: width*0.07),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Color.fromARGB(255, 9, 143, 92), Color.fromARGB(255, 8, 119, 76)])
                          ),
                          child: ElevatedButton(
                            onPressed: () => loging(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(width*0.6, width*0.09)
                            ),
                            child: const Text('Log In'),
                          ),
                        ),
                      ),
                  
                      SizedBox(height: width*0.03),
                                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                forgetpass = true;
                              });
                            },
                            child: Text("Forget Password?", style: GoogleFonts.poppins(textStyle: TextStyle( color : Colors.white, fontSize: width*0.03))))
                          ,
                                  
                          TextButton(
                        onPressed: () {
                          if (widget.prodet != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Createacc(prodet: widget.prodet),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Createacc(),
                              ),
                            );
                          }
                        },
                        child: Text('Create Account?', style: GoogleFonts.poppins(textStyle: TextStyle( color : Colors.white, fontSize: width*0.03))),
                      ),
                        ],
                      ),
                                  
                   SizedBox(height: width*0.04),
                  
                      if (forgetpass)
                        Column(
                          children: [
                            TextField(
                              cursorColor: Colors.white,
                              controller: usernum,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: width*0.03),
                                prefixIcon: Padding(padding: EdgeInsets.only(right: width*0.05, left: width*0.02), child: const Icon(Icons.person, color: Colors.white,),),
                                
                                enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                                focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: Colors.white, width: width*0.003),),
                                ),
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: width*0.04),
                  
                            Row(
                              children: [
                                ElevatedButton(
                              onPressed: () => registerdetail(context),
                               style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                minimumSize: Size(width*0.2, width*0.09),
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0), 
                              ),
                              child: const Text("Submit"),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  forgetpass = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                minimumSize: Size(width*0.2, width*0.09),
                                foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                              ),
                              child: const Text("Cancel"),
                            ),
                              ],
                            )
                            
                          ],
                        ),
                  
                       SizedBox(height: width*0.05),
                  
                      Padding(
                        padding: EdgeInsets.only(left: width*0.07),
                        child: Ink(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const navigation()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 221, 0, 0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(width*0.6, width*0.09),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                            ),
                            child: Text('Skip',style: GoogleFonts.poppins(textStyle: TextStyle( fontSize: width*0.03))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

      }
}