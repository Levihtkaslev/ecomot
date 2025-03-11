import 'package:flutter/material.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:frontendmobile/payment.dart/buy.dart';
import 'package:frontendmobile/payment.dart/cart.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class productdetails extends StatefulWidget {
  final Map<String, dynamic> prodet;
  const productdetails({super.key, required this.prodet});

  @override
  State<productdetails> createState() => _productdetailsState();
}

class _productdetailsState extends State<productdetails> with SingleTickerProviderStateMixin {

 
 
  List<dynamic> cartees = [];
  bool ItemInCart = false;

    @override
  void initState() {
    super.initState();
    fetchcart();
  }

  

void checklogin(BuildContext context, String action, String itemid, int qty) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userid = prefs.getString('phone');

  if (userid == null || userid.isEmpty) {
    print("User not logged in! Redirecting to login...");
    Navigator.push(context, MaterialPageRoute(builder: (context) => login(prodet: widget.prodet)));
    return;
  }

  bool logcheck = await checktheloging();

  if (logcheck) {
    if (action == "buydaa") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const buynow()));
    } else if (action == "cartdaa") {
      try {
        final Url = Uri.parse("$backendurl/cart");

        final response = await http.post(
          Url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "userid": userid,
            "itemid": itemid,
            "qty": qty
          }),
        );

        if (response.statusCode == 200) {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const cartee()),
          );
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  } else {
    
    print("User not logged in! Redirecting...");
    Navigator.push(context, MaterialPageRoute(builder: (context) => login(prodet: widget.prodet)));
  }
}




Future<void> fetchcart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('phone');

      try{

          final carturl = Uri.parse("$backendurl/cart/$userid");
        final res = await http.get(carturl);

          if (res.statusCode == 200) {
            final data = json.decode(res.body);
            List<dynamic> cartItems = data['usercart']['items'];

            setState(() {
              cartees = cartItems;
            
              ItemInCart = cartItems.any((item) => item['itemid'].toString() == widget.prodet['_id'].toString());

              print("see : $ItemInCart");
            });
            }
            else {
            print("Failed to fetch cart");
          }

      }catch(e){
        print("Error ahaa ahaa");
      }
  } 



  

  Future<bool> checktheloging() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");
    return phone != null && phone.isNotEmpty;
  }
  

  @override
  Widget build(BuildContext context) {
         // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final String url = widget.prodet['itemimage'];
    return  Scaffold(
  
  body: GestureDetector(
     onTap: () {
        FocusScope.of(context).unfocus(); 
      },
    child: CustomScrollView(
      slivers: [
    
        SliverAppBar(
          expandedHeight: width * 0.5,
          floating: false,
          pinned: true,
          elevation: width * 0.2,
          foregroundColor: Colors.white,
          shadowColor: const Color.fromARGB(31, 112, 110, 110),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "${widget.prodet['itemname']}",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontSize: width * 0.03),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
    
        SliverToBoxAdapter(
          child :Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GlowingOverscrollIndicator(
                  color: const Color.fromARGB(255, 247, 97, 147),
                  axisDirection: AxisDirection.down,
                  child: Container(
                    
                    width: width,
                    padding: EdgeInsets.only(top: width * 0.3, left: width * 0.03, right: width * 0.03),
                    margin: EdgeInsets.only(top: width * 0.3, bottom: width*0.03, left: width * 0.03, right: width * 0.03),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 251, 241, 255),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(width * 0.1),bottom: Radius.circular(width * 0.03)),
                      boxShadow: const [BoxShadow(color: Color.fromARGB(255, 200, 205, 206), blurRadius: 5, spreadRadius: 1)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.prodet['itemname']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.06))),
                        SizedBox(height: width * 0.03),
                        Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 194, 247, 247),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [BoxShadow(color: Color.fromARGB(255, 144, 246, 252), offset: Offset(0, 5), blurRadius: 2, spreadRadius: 1)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.weightHanging , color: Colors.green, size: width * 0.02),
                                  SizedBox(width: width*0.01,),
                                  Text("Qty : ${widget.prodet['qty']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.02))),
                                ],
                              ),
                        
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.puzzlePiece , color: Colors.green, size: width * 0.02),
                                  SizedBox(width: width*0.01,),
                                  Text("Pieces : ${widget.prodet['itempice']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.02))),
                                ],
                              ),
                              Row(
                                children: [
                                   FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: width * 0.02),
                                   SizedBox(width: width*0.01,),
                                  Text("Ready to cook", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.02))),
                                 
                                ],
                              ),
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.tags , color: Colors.green, size: width * 0.02),
                                  SizedBox(width: width*0.01,),
                                  Text("${widget.prodet['itemcategory']} Family", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.02))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: width * 0.02),
                        Text("(You can increase or decrease qty from 500g in the cart)", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.02))),
                        SizedBox(height: width * 0.08),
                        
                      Container(
                        height: width*0.08,
                        width: width*0.6,
                        padding: EdgeInsets.all( width*0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 243, 62, 107),
                            Color.fromARGB(255, 241, 83, 122),
                            Color.fromARGB(255, 251, 241, 255)
                          ], begin: Alignment.centerLeft, end: Alignment.centerRight)
                        ),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.heartCirclePlus, size: width*0.03, color: const Color.fromARGB(255, 255, 255, 255),),
                            SizedBox(width: width*0.01,),
                            Text("Health information", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03, color: Colors.white))),
                          ],
                        )),
                      SizedBox(height: width * 0.02),
                        Row(children: [
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.green, size: width * 0.03),
                              SizedBox(width: width*0.01,),
                              Text("Healthy for : ", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03))),
                            ],
                          ),
                          Text("${widget.prodet['itemfor']}", style: GoogleFonts.poppins(color: Colors.green, textStyle: TextStyle(fontSize: width * 0.03))),
                        ],),
                        SizedBox(height: width * 0.02),
                        Row(children: [
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.running , color: Colors.green, size: width * 0.03),
                              SizedBox(width: width*0.01,),
                              Text("Nutrition : ", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03))),
                            ],
                          ),
                          Text("${widget.prodet['itemtopnut']} ", style: GoogleFonts.poppins(color: Colors.green, textStyle: TextStyle(fontSize: width * 0.03))),
                        ],),
                            
                      SizedBox(height: width * 0.04),
                        Text("Description", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.04))),
                        Text("${widget.prodet['itemdescr']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03))),
                        SizedBox(height: width * 0.03),
                            
                            
                            
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: width * 0.1,
                  left: width * 0.3,
                  child: 
                   Hero(
                    tag: url,
                     child: Container(
                        height: width * 0.4,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Color.fromARGB(255, 119, 117, 117), spreadRadius: 1, blurRadius: 4, offset: Offset(0, 5)),],
                          shape: BoxShape.circle, 
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                   ),
                ),
              ],
            ),
          ],
        ),
            ),
        )
      ],
      
    ),
  ),
bottomNavigationBar: BottomAppBar(
  color: const Color.fromARGB(0, 0, 194, 219), 
  shape: const AutomaticNotchedShape(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  elevation: 5, // Adds shadow
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color.fromARGB(255, 251, 241, 255), Color.fromARGB(255, 251, 241, 255)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15)), 
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 119, 122, 122),
          blurRadius: 5,
          spreadRadius: 1,
          offset: Offset(0, 5)
        ),
      ],
      
    ),
    padding: EdgeInsets.symmetric(horizontal: width*0.01, vertical: width*0.01),
    child: ItemInCart
        ?  Text("Already added", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:  const TextStyle(color: Color.fromARGB(255, 243, 62, 107))))
        : SizedBox(
            width: double.infinity,
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "₹${widget.prodet['itemoffpr']}Rs/-", 
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: width * 0.04,
                          color: const Color.fromARGB(255, 0, 184, 184), 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: width*0.02),
                    Text(
                      "₹${widget.prodet['itemorip']}Rs/-",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: width * 0.03,
                          color: const Color.fromARGB(179, 255, 38, 38),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: const Color.fromARGB(255, 22, 22, 22)  
                        ),
                      ),
                    ),
                  ],
                ),

                // Add to Cart Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: const Color.fromARGB(255, 122, 122, 122),
                    backgroundColor: const Color.fromARGB(255, 243, 62, 107), 
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => checklogin(context, "cartdaa", widget.prodet['_id'], widget.prodet['qty']),
                  child: Row(
                    children: [
                      Text("Add to Cart", style: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 255, 255, 255))),
                      SizedBox(width: width*0.01,),
                      Icon(Icons.shopping_cart, size: width*0.03, color: Colors.white,)
                    ],
                  ),
                ),
              ],
            ),
          ),
  ),
),

);

  }
}