import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {

  final String facebookprofile = "https://www.facebook.com/people/Sam-Dboss/100025576996868/#"; 
  final String instagramprofile = "https://www.instagram.com/sam_d_boss_/";
  final String x = "https://x.com/Sakthi_fc";
  final String mail = "sams47999@gmail.com";
  final String whatsapp = "916382209943";
  final String latitude = "37.7749";
  final String longitude = "-122.4194";
  final String phone ="916382209943";

  Future<void> urllaunch(String url) async{
    final Uri uri = Uri.parse(url);
    if(!await launchUrl(uri, mode: LaunchMode.externalApplication)){
      throw "Error happened ";
    }
  }

Future<void> mailto(String mail) async {
  final Uri mailtoo = Uri(
    scheme: 'mailto',
    path: mail,  
    queryParameters: {
      'subject': "Need help",
      'body': "Hi, need help with..."
    }
  ); 

  if (!await launchUrl(mailtoo)) {
    throw 'Could not launch $mailtoo';
  }
} 

  Future<void> sendwhatsapp(String whatsapp) async{
    final Uri whatsappurl = Uri.parse("https://wa.me/$whatsapp?text=Hello!");

    if(await canLaunchUrl(whatsappurl)){
      await launchUrl(whatsappurl, mode: LaunchMode.externalApplication);
    }else{
      throw 'failed to launch $whatsappurl';
    }
  }

  Future<void> location() async{
    final Uri latlong = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if(await canLaunchUrl(latlong)){
      await launchUrl(latlong, mode: LaunchMode.externalApplication);
    }else{
      throw "Error launching";
    }
  }

    Future<void> dialpad() async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phone';
    }
  }





  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width*0.04),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 51, 98),
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Color.fromARGB(255, 189, 188, 188),spreadRadius: 1, blurRadius: 3),]
        ),
        child: Column(
          children: [
        
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("For support and Enquiry", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.04, color:  Colors.white)),),
                SizedBox(width: width*0.01,),
                Icon(FontAwesomeIcons.circleQuestion, size: width*0.04, color:Colors.white ,)
              ],
            ),
            SizedBox(height: width*0.01,),
            Row(children: [
              Text("Contact : ",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
              Text(phone,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
              
              IconButton(onPressed: dialpad, icon: Icon(FontAwesomeIcons.phone, color: Colors.white, size: width*0.04,))
            ],),
            Row(
              children: [
                Text("Mail us : ",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
                Text(mail,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
            
                IconButton(onPressed: () => mailto(mail), icon: Icon(Icons.mail, color: Colors.white, size: width*0.04,)),
              ],
            ),
        
            Row(
              children: [
                Text("Chat with us ",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
                IconButton(onPressed: () => sendwhatsapp(whatsapp), icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: width*0.04,)),
              ],
            ),
            SizedBox(height: width*0.02,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text("Address: ",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white))),
                    Text("No 89/io, helen street,",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.02, color:  Colors.white))),
                    Text("K K Nagar, Chennai",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.02, color:  Colors.white))),
                    Text("632 114 - Tamil Nadu",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.02, color:  Colors.white)))
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () => location(),
                  child: Text("Open Map",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color:  Colors.white)))),
                IconButton(onPressed: () => location, icon: Icon(FontAwesomeIcons.locationDot, size: width*0.04, color:Colors.white,)),
              ],
            ),
            SizedBox(height: width*0.02,),
          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              IconButton(onPressed: () => urllaunch(instagramprofile), icon: Icon(FontAwesomeIcons.instagram,  size: width*0.05, color:Colors.white,)),
              IconButton(onPressed: () => urllaunch(facebookprofile), icon: Icon(Icons.facebook,  size: width*0.05, color:Colors.white,)),
              IconButton(onPressed: () => urllaunch(x), icon: Icon(FontAwesomeIcons.twitter,  size: width*0.05, color:Colors.white,)),
            ],),
        
        
            
           
            
          ],
        ),
      ),
    );
  }
}