import 'dart:async';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/shimmer/productshim.dart';
import 'package:flutter/material.dart';
import 'package:frontendmobile/process/productdetail.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class otproducts extends StatefulWidget {
  const otproducts({super.key});

  @override
  State<otproducts> createState() => _otproductsState();
}

class _otproductsState extends State<otproducts> with SingleTickerProviderStateMixin{
  late TabController tabee;
  List<String> category = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredproducts = [];
  bool isloadn = true;
  String searchquery = '';
  bool issearching = false;

  List<String> suggestions = [
  "Left fish",
  "Right fish",
  "bottom fish",
  "upper fish",
  "all fish"
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    getdata();
    Timer.periodic(const Duration(seconds: 2), (timer){
      setState(() {
        index = (index + 1) % suggestions.length;
      });
    });
  }



  Future<void> getdata() async{
    final producturl = Uri.parse("$backendurl/item"); 
    final categoryurl = Uri.parse("$backendurl/web/category");

    try{
      final productres = await http.get(producturl);
      final categoryres = await http.get(categoryurl);

      if(productres.statusCode == 200 && categoryres.statusCode == 200){
        List<dynamic> productdata = json.decode(productres.body);
        List<dynamic> categorydata = json.decode(categoryres.body);

        setState(() {
          products = List<Map<String,dynamic>>.from(productdata);
          filteredproducts = List<Map<String, dynamic>>.from(productdata);
          category = categorydata.map((cat) => cat['categname'].toString()).toList();
          tabee = TabController(length: category.length, vsync: this);
          isloadn = false;
        });
      }
    }catch(e){
      print("Error :, $e");
    }
  }

  List<Map<String, dynamic>> getproducts(String e){
    return filteredproducts.where((pro) => pro['itemcategory'] == e).toList();
  }

    void moveToCategory(String selectedCategory) {
    int index = category.indexOf(selectedCategory);
    if (index != -1) {
      setState(() {
        tabee.animateTo(index); 
      });
    }
  }

    void filterProducts(String query) {
    setState(() {
      searchquery = query;
      filteredproducts = products.where((product) {
        return product['itemname'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void stopsearch() {
  setState(() {
    issearching = false;
    searchquery = '';
  });
}

void startsearch(){
  setState(() {
    issearching = true;
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
    if(isloadn){
      return const Scaffold(body: Center(child: proshim(),),);
    }
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: WillPopScope(
        onWillPop: () async {
          return await _showExitConfirmation();
        },
        child: Scaffold(
          appBar: AppBar(
             title: Text("Products",style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.06 )),
             iconTheme: const IconThemeData(
              color: Colors.white,
             ),
             backgroundColor: const Color.fromARGB(255, 243, 62, 107),
             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
             bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white,
              
              labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.04)),
              tabs: category.map((e) => Tab(text: e, )).toList(),  controller: tabee,),
                 actions: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.filter),
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    title: "Select Category",
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: category.map((e) {
                        return ListTile(
                          leading: const Icon(Icons.circle, color: Color.fromARGB(255, 74, 139, 252)),
                          title: Text(e, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03))),
                          onTap: () {
                            moveToCategory(e);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ).show();
                },
              ),
            ],
          ),
        
          body: GlowingOverscrollIndicator(
            color: const Color.fromARGB(255, 245, 114, 157),
            axisDirection: AxisDirection.down,  
            child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
             child: Column(
             children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         issearching
                             ? Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: const Color.fromARGB(255, 0, 200, 207),width: width*0.001)),
                              width: width*0.9,
                              height: width*0.1,
                              padding: EdgeInsets.only(bottom: width*0.01,top: width*0.01,  left: width*0.02, right: width*0.02),
                                 child: TextField(
                                  
                                   autofocus: true,
                                   decoration:  InputDecoration(
                                     hintText: 'Search by product name...',
                                     suffixIcon: IconButton(onPressed:  stopsearch, icon: const Icon(Icons.clear, color: Colors.red,)),
                                     border: InputBorder.none
                                   ),
                                   onChanged: filterProducts,
                                 ),
                                 
                               )
                             : 
                                 Container(
              width: width * 0.9,
              margin: EdgeInsets.symmetric(vertical: width * 0.03, horizontal: width * 0.03),
              padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: width * 0.01),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 247, 255),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
            BoxShadow(color: Color.fromARGB(255, 243, 62, 107), blurRadius: 3, spreadRadius: 1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Slide animation from bottom to top
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 1), // Start from bottom
                    end: const Offset(0, 0),   // Move to normal position
                  ).animate(animation);
            
                  // Color animation from gray to normal
                  final colorAnimation = ColorTween(
                    begin: Colors.grey,  // Start fading as gray
                    end: Colors.black,   // End as normal color
                  ).animate(animation);
            
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: slideAnimation,
                        child: Text(
                          suggestions[index],
                          key: ValueKey<String>(suggestions[index]), // Avoid flickering
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: colorAnimation.value, // Apply animated color
                              fontSize: width * 0.03,
                              
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  suggestions[index], 
                  key: ValueKey<String>(suggestions[index]),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 126, 124, 124), 
                      fontSize: width * 0.03,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: issearching ? stopsearch : startsearch,
              icon: Icon(issearching ? Icons.clear : Icons.search),
            ),
                ],
              ),
            ),
            
            
            
                                   
                               
                        
                       ],
                     ),
                   ),
                       Expanded(
                   child: issearching
                       ? ListView.builder(
                           itemCount: filteredproducts.length,
                           itemBuilder: (context, index) {
                             final thispro = filteredproducts[index];
                             return ListTile(
                               title: Text(thispro['itemname']),
                               
                                onTap: () {
                                                     Navigator.of(context, rootNavigator: false).push(
                                                       
                                                       MaterialPageRoute(
                                                         builder: (context) => productdetails(prodet: thispro),
                                                       ),
                                                     );
                                                   },
                             );
                           },
                         )
                       : TabBarView(
                           controller: tabee,
                           children: category.map((e) {
                             List<Map<String, dynamic>> filteredpro = getproducts(e);
                             return ListView.builder(
                               itemCount: filteredpro.length,
                               itemBuilder: (context, index) {
                                 final thispro = filteredpro[index];
                                 String imageurl = thispro['itemimage'];
                   
                                       return GlowingOverscrollIndicator(
                                        color: const Color.fromARGB(255, 245, 114, 157),
                                        axisDirection: AxisDirection.up,
                                         child: Padding(
                                             padding:  EdgeInsets.only(top:width*0.04 ), 
                                             child: Container(
                                               height: width*0.3,
                                               margin: EdgeInsets.all(width * 0.02),
                                               decoration: BoxDecoration(
                                                 color: const Color.fromARGB(255, 252, 246, 255),
                                                 borderRadius: BorderRadius.circular(10),
                                                 boxShadow: [
                                                   BoxShadow(
                                                     color: const Color.fromARGB(255, 243, 62, 107).withOpacity(0.2),
                                                     spreadRadius: 2,
                                                     blurRadius: 5,
                                                     offset: const Offset(0, 3), 
                                                   ),
                                                 ],
                                               ),
                                               child: Stack(
                                                 clipBehavior: Clip.none,
                                                 children: [
                                                    Positioned(
                                                      
                                                      child: Container(
                                                        height: width*0.2, width :width*0.2,
                                                        margin: EdgeInsets.only(left:width*0.7, top: width*0.01, bottom: width*0.03),
                                                        decoration: const BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("asset/wall3.png"), fit: BoxFit.fill)
                                                        ),
                                                      ),
                                                    ),
                                                 
                                                   ListTile(
                                                     
                                                 
                                                     
                                                     
                                                 
                                                 
                                                 
                                                 
                                                     subtitle: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                       children: [
                                                 
                                                            Container(
                                                              margin: EdgeInsets.only(bottom: width*0.03),
                                                         decoration: BoxDecoration(
                                                         color: Colors.white,
                                                         borderRadius: BorderRadius.circular(10),
                                                         boxShadow: [
                                                           BoxShadow(
                                                             color: const Color.fromARGB(255, 243, 62, 107).withOpacity(0.3),
                                                             spreadRadius: 1,
                                                             blurRadius: 5,
                                                             offset: const Offset(0, 3),
                                                           ),
                                                         ],
                                                       ),
                                                       child: Hero(
                                                        tag: imageurl,
                                                         child: Container(
                                                              width: width * 0.2,
                                                              height: width * 0.2,
                                                              decoration: BoxDecoration( image: DecorationImage(image: NetworkImage(imageurl), fit: BoxFit.fill),
                                                              borderRadius: BorderRadius.circular(10),
                                                              ),
                                                         )
                                                       ),
                                                     ),
                                                 
                                                     
                                                 
                                                         Column(
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: [
                                                            SizedBox(height: width*0.03,),
                                                            Text(
                                                       thispro['itemname'],
                                                       style: GoogleFonts.poppins(
                                                         fontSize: width * 0.04,
                                                       ),overflow: TextOverflow.ellipsis,
                                                     ),
                                                             Row(
                                                               children: [
                                                                 Text(" ₹${thispro['itemorip'].toString()} Rs", style: GoogleFonts.roboto(textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: width*0.04, color: const Color.fromARGB(255, 0, 199, 182)),)),
                                                                 SizedBox(width: width*0.02,),
                                                                 Text(" ₹${thispro['itemoffpr'].toString()} /- Rs", style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: width*0.03, color: Colors.red.withOpacity(0.5), decoration: TextDecoration.lineThrough,overflow: TextOverflow.ellipsis, decorationColor: const Color.fromARGB(255, 0, 0, 0))),),
                                                               
                                                               
                                                                 
                                                               ],
                                                             ),
                                                             Text(" Pieces ${thispro['itempice']} (apprx)", style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: width*0.03,overflow: TextOverflow.ellipsis,),),),
                                                             Row(
                                                               children: [
                                                               Text(" Ready to cook", style: GoogleFonts.roboto(textStyle: TextStyle(overflow: TextOverflow.ellipsis,fontSize: width*0.03, color: const Color.fromARGB(255, 0, 199, 182)),)),
                                                               SizedBox(width: width*0.01,),
                                                               FaIcon(FontAwesomeIcons.circleCheck, color: const Color.fromARGB(255, 0, 199, 182), size: width * 0.03),
                                                               ],
                                                             ),
                                                             
                                                           ],
                                                         ),
                                                 
                                                         Container(
                                                      
                                                       height: width*0.1,
                                                       width: width*0.3,
                                                       // ignore: sort_child_properties_last
                                                       child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("Add", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.03),),
                                                          SizedBox(width: width*0.02,),
                                                          Icon(Icons.shopping_cart, color: Colors.white, size: width*0.04,)
                                                        ],
                                                       ),
                                                       decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(10),
                                                       boxShadow: [
                                                        BoxShadow(
                                                             color: const Color.fromARGB(255, 4, 245, 233).withOpacity(0.3),
                                                             spreadRadius: 3,
                                                             blurRadius: 5,
                                                             offset: const Offset(0, 3),
                                                           ), ],
                                                        gradient: const LinearGradient(colors: [Color.fromARGB(255, 243, 62, 107),Color.fromARGB(255, 236, 76, 116),])),
                                                     ),
                                                 
                                                       ],
                                                     ),
                                                     onTap: () {
                                                       Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                           builder: (context) => productdetails(prodet: thispro),
                                                         ),
                                                       );
                                                     },
                                                   ),
                                                 
                                                 ],
                                               ),
                                             ),
                                           ),
                                       );
                   
                                       },
                             );
                           }).toList(),
                         ),
                       ),
                     
                     
             ],
                     ),
                      ),
          ),
        
        ),
      ),
    );
  }
}