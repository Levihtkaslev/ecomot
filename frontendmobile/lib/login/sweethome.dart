import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/login/producthome.dart';
import 'package:frontendmobile/login/review.dart';
import 'package:frontendmobile/payment.dart/categround.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Sweethome extends StatefulWidget {
  const Sweethome({super.key});

  @override
  State<Sweethome> createState() => _SweethomeState();
}

class _SweethomeState extends State<Sweethome> {

  String? userid;
  Map<String, dynamic>? userpers;
  List<String> corousel = [];
  List<String> review = [];
  int activeindex = 0;
  List<Map<String, dynamic>> products = [];
  bool isloadn = true;
  final String facebookprofile = "https://www.facebook.com/people/Sam-Dboss/100025576996868/#"; 
  final String instagramprofile = "https://www.instagram.com/sam_d_boss_/";
  final String x = "https://x.com/Sakthi_fc";

  @override
  void initState() {
    super.initState();
    useridload();
    fetchallper();
    fetchallimages();
    getdata();
  }

    Future<void> urllaunch(String url) async{
      final Uri uri = Uri.parse(url);
      if(!await launchUrl(uri, mode: LaunchMode.externalApplication)){
        throw "Error happened ";
      }
    }

      Future<void> fetchallper() async {
        try{
          final Uri url = Uri.parse("$backendurl/profile");
          final response = await http.get(url);
          

        if(response.statusCode == 200){
          List<dynamic> userlist = json.decode(response.body);

          var filter = userlist.firstWhere((user) => user['cusphonenumber'].toString() == userid, orElse: () => null);
          
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

      Future<void> fetchallimages() async {
        final response = await http.get(Uri.parse("$backendurl/ad"));

        if(response.statusCode == 200){
          List <dynamic> data = json.decode(response.body);

          setState(() {
            corousel = data.where((e) => e['imagetype'] == 'core').map<String>((item) => item['image']).toList();
            review = data.where((e) => e['imagetype'] == 'review').map<String>((item) => item['image']).toList();
           
          });
        }else{
          throw Exception("Failed to load images");
        }
      } 

      Future<void> getdata() async{
        final producturl = Uri.parse("$backendurl/item"); 

        try{
          final productres = await http.get(producturl);
          
          if(productres.statusCode == 200){
            List<dynamic> productdata = json.decode(productres.body);

            setState(() {
              products = List<Map<String,dynamic>>.from(productdata);
              isloadn = false;
            });
          }
        }catch(e){
          print("Error :, $e");
        }
      }



    Future<void> useridload() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userid = prefs.getString('phone');
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
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: WillPopScope(
        onWillPop: () async {
          return await _showExitConfirmation();
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent.withOpacity(0.4),
                    statusBarBrightness: Brightness.light,
                  ),
                  foregroundColor: Colors.white,
                  expandedHeight: width * 0.6,
                  floating: false,
                  pinned: true,
                  shadowColor: const Color.fromARGB(31, 153, 147, 147),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero, 
                    title: Align(
                      alignment: Alignment.bottomLeft, 
                      child: Container(
                        width: double.infinity,
                        height: width*0.1,
                        color: Colors.black.withOpacity(0.4),
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width*0.001), 
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: width * 0.02,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: width * 0.03,
                                color: const Color.fromARGB(255, 61, 57, 57),
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              "Hi, ${userpers?['cusname'] ?? "Guest"}",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(fontSize: width * 0.02, color: Colors.white),
                              ),
                            ),
                        
                            const Spacer(),
                            Container(
                              height: width * 0.09,
                              width: width*0.3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage("asset/logo2.png"), fit: BoxFit.fill)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                       
                        image: DecorationImage(image: NetworkImage("https://t3.ftcdn.net/jpg/07/78/33/66/360_F_778336683_vaZeHHzwii7Hp8p4IzAGrKdghAzHPUtC.jpg"), fit: BoxFit.cover)
                      ),
                    ),
                  ),
                ),
        
        
              SliverToBoxAdapter(
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: const Color.fromARGB(255, 245, 114, 157),
                  child: Container(
                    child: Column(
                      children: [
                  
                  
                  
                        Row(
                          children: [
                            SizedBox(height: width*0.06,),
                            Text("Whats in your mind?", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.05, color: const Color.fromARGB(255, 57, 58, 57))),),
                            const Spacer(),
                            Container(
                             
                              height: width*0.001,
                              width: width*0.4,
                              color: const Color.fromARGB(255, 201, 196, 196),
                            ),
                             SizedBox(height: width*0.2,),
                          ],
                        ),
        
                           corousel.isNotEmpty? 
                            CarouselSlider(
                              options: CarouselOptions(
                                height: width * 0.5, 
                                autoPlay: true,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeindex = index;
                                  });
                                },
                              ),
                              items: corousel.map((url) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child:Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(image: NetworkImage(url),fit: BoxFit.fill)
                                    ),
                                  )
                                );
                              }).toList(),
                            ):Shimmer.fromColors(
                                baseColor: const Color.fromARGB(255, 109, 107, 107),
                                highlightColor: Colors.white,
                                child: Container(
                                  height: width * 0.5, 
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
        
        
                          SizedBox(height: width * 0.05),
                          if (corousel.isNotEmpty)
                            AnimatedSmoothIndicator(
                              activeIndex: activeindex,
                              count: corousel.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: width * 0.01,
                                dotWidth: width * 0.01,
                                activeDotColor: Colors.blue,
                              ),
                            ), 
                  
                  
                  
                          SizedBox(height: width * 0.1),
                             Container(
                              padding: EdgeInsets.all(width*0.03),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: const Color.fromARGB(255, 47, 223, 236),),
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                  SizedBox(height: width * 0.04),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Taste by category", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.05, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 255, 255, 255))),),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () => Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                        builder: (context) => const otproducts())),
                                        child: ElevatedButton(
                                          onPressed: () => Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                        builder: (context) => const otproducts())),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(2)),
                                            minimumSize: Size(width*0.01, width * 0.09),
                                            foregroundColor: const Color.fromARGB(255, 56, 55, 55),
                                          ),
                                          child: Row(
                                            children: [
                                              Text("See All",style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 66, 65, 65))),),
                                              SizedBox(width: width*0.02,),
                                              Icon(Icons.keyboard_arrow_right_sharp, color: const Color.fromARGB(255, 83, 82, 82), size: width*0.03,)
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text("From the shore to your door", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 255, 255, 255))),),
                                   SizedBox(height: width*0.1,),
                                   SizedBox(
                                    height: width*0.5,
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const otproducts())),
                                      child: const Categround()),
                                                         ),
                                 ],
                               ),
                             ),
                  
                  SizedBox(height: width * 0.1),
                  
                                    Container(
                                      height: width*0.1,
                                      width: width,
                                      margin: EdgeInsets.symmetric(vertical: width*0.03),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 0, 177, 138),
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 255, 255, 255), width: width*0.001
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [BoxShadow( color: Color.fromARGB(255, 194, 191, 191), offset: Offset(0, 5), spreadRadius: 1, blurRadius: 5)]
                                      ),
                                      child: Center(child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          DefaultTextStyle(
                                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: width*0.04)),
                                            child: AnimatedTextKit(animatedTexts: [
                                              TypewriterAnimatedText("Creates a text widge  text w", speed: const Duration(milliseconds: 100)),
                                               /* FadeAnimatedText('Hello, World!', ),
                                              ScaleAnimatedText('Hello, World!',),
                                               WavyAnimatedText('Hello, World!', ), */
                                            ]),
                                          ),
                                          Icon(FontAwesomeIcons.award, color: Colors.white, size: width*0.04,)
                                        ],
                                      )),
                                    ),
                  
                  
                       
                    SizedBox(height: width * 0.1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: width*0.08,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Bestsellers", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.05, color: const Color.fromARGB(255, 57, 58, 57))),),
                                const Spacer(),
                                ElevatedButton(onPressed: () => const otproducts(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  minimumSize: Size(width * 0.1, width * 0.09),
                                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                ), child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("More", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: Colors.white)),),
                                        SizedBox(width: width*0.02,),
                                        Icon(Icons.keyboard_arrow_right_sharp, color: Colors.white, size: width*0.03,)
                                      ],
                                ),
                                )
                              ],
                            ),
                            Text("Most popular products", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 75, 77, 75))),),
                            SizedBox(height: width*0.04,),
                            SizedBox(
                              height: width*0.7,
                              child: const Producthome()
                            ),
                           SizedBox(height: width*0.1,)
                          ],
                        ),
                  
                  
                  
                      Column(
                        children: [
                          
                          Row(
                            children: [
                              Container(
                              height: width*0.001,
                              width: width*0.2,
                              color:  const Color.fromARGB(255, 149, 150, 149),
                            ),
                              Text("Some of our testimonials",style: GoogleFonts.redHatDisplay(textStyle: TextStyle(fontSize: width*0.05, color: const Color.fromARGB(255, 57, 58, 57))),),
                            Container(
                              height: width*0.001,
                              width: width*0.2,
                              color:  const Color.fromARGB(255, 149, 150, 149),
                            ),
                            ],
                          ),
                          SizedBox(height: width*0.04,),
                          SizedBox(
                              height: width*01,
                              child: Review(),
                            ),
                            SizedBox(height: width*0.05,)
                        ],
                      ),
                  
                             
                      Container(
                        height: width*0.5,
                        padding: EdgeInsets.symmetric(vertical: width*0.04),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 243, 62, 107),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(19))
                        ),
                        child: Column(
                  
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Text("Thanks for chosing us", style: GoogleFonts.pacifico(textStyle: TextStyle(fontSize: width*0.05, color: Colors.white)),),
                              SizedBox(height: width*0.02,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Taste you want", style: GoogleFonts.pacifico(textStyle: TextStyle(fontSize: width*0.05,  color: Colors.white))),
                                  SizedBox(width: width*0.02,),
                                  Icon(FontAwesomeIcons.heart, color: Colors.white, size: width*0.05,)
                                ],
                              ),
                               SizedBox(height: width*0.04,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Touch with us", style: GoogleFonts.pacifico(textStyle: TextStyle(fontSize: width*0.05, color: Colors.white)),),
                                  SizedBox(width: width*0.02,),
                                  Icon(FontAwesomeIcons.thumbsUp, color: Colors.white, size: width*0.05,)
                                ],
                              ),
                            ],),  
                            SizedBox(height: width*0.02,),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                IconButton(onPressed: () => urllaunch(instagramprofile), icon: Icon(FontAwesomeIcons.instagram,  size: width*0.05, color:Colors.white,)),
                                IconButton(onPressed: () => urllaunch(facebookprofile), icon: Icon(Icons.facebook,  size: width*0.05, color:Colors.white,)),
                                IconButton(onPressed: () => urllaunch(x), icon: Icon(FontAwesomeIcons.twitter,  size: width*0.05, color:Colors.white,)),
                              ],),
                            SizedBox(height: width*0.02,)
                          ],
                        ),
                      )
                          
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}