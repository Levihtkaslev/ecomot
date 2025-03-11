import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/process/productdetail.dart';
import 'package:frontendmobile/shimmer/producthhomeshi.dart';
import 'package:frontendmobile/statics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Producthome extends StatefulWidget {
  const Producthome({super.key});

  @override
  State<Producthome> createState() => _ProducthomeState();
}

class _ProducthomeState extends State<Producthome> {

    List<Map<String, dynamic>> products = [];
    bool isloadn = true;


      @override
      void initState() {
        super.initState();
        getdata();
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
  @override
  Widget build(BuildContext context) {
       // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:      products.isEmpty? const Center(child: Produmesh(),):  
      
                  Container(
                    child: SizedBox(
                      height: width*0.6,
                      child: GlowingOverscrollIndicator(
                        color: const Color.fromARGB(255, 245, 114, 157),
                        axisDirection: AxisDirection.right,
                        child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: products.length,
                           itemBuilder: (context, index){
                            final thispro = products[index];
                            String imageurl = thispro['itemimage'];
                            return InkWell(
                              onTap: (){
                                        Navigator.of(context, rootNavigator: false).push(
                                          
                                          MaterialPageRoute(
                                            builder: (context) => productdetails(prodet: thispro),
                                          ),
                                        );
                                      },
                              child: Container(
                                 height: width*0.3, width : width*0.4,
                                 margin: EdgeInsets.all(width*0.02),
                                 padding: EdgeInsets.all(width*0.01),
                                 decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 248, 243, 250), 
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.circular(30)),
                                  boxShadow: [BoxShadow(
                                    color: Color.fromARGB(255, 182, 179, 179), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 5), 
                                  )]
                                  ),
                                child: Column(
                                  
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: width*0.3, width : width*0.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                         image: DecorationImage(image: NetworkImage(imageurl ), fit: BoxFit.fill) ,
                                         color: Colors.lightBlueAccent
                                        ),
                                      ),
                                    ),
                                                  
                                     SizedBox(height: width*0.03,),
                                     Text("${thispro['itemname']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 231, 9, 131), overflow:TextOverflow.ellipsis )),),
                                     SizedBox(height: width*0.03,),
                                                  
                                     Padding(
                                       padding:  EdgeInsets.symmetric(horizontal: width*0.03),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(width: width*0.01,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                             Row(
                                              children: [
                                                 Text("1kg", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 77, 76, 76),))),
                                                 SizedBox(width: width*0.01,),
                                                 
                                                 
                                                 Icon(Icons.two_wheeler_rounded, size: width*0.02,  color: const Color.fromARGB(255, 121, 119, 119),),
                                                 SizedBox(width: width*0.01,),
                                                 Text("Free", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.02, color: const Color.fromARGB(255, 121, 119, 119),))),
                                              ],
                                             ),
                                                    
                                             Row(
                                              children: [
                                                Text("₹${thispro['itemoffpr'].toString()}", style: GoogleFonts.roboto(fontSize: width*0.03,color: const Color.fromARGB(255, 75, 71, 71), decoration: TextDecoration.lineThrough, decorationColor: const Color.fromARGB(255, 255, 0, 0)), overflow: TextOverflow.ellipsis,),
                                                SizedBox(width: width*0.02,),
                                                Text("₹${thispro['itemorip'].toString()} ", style: GoogleFonts.roboto(fontSize: width*0.03, color: const Color.fromARGB(255, 2, 207, 190)),overflow: TextOverflow.ellipsis),
                                              ],
                                             )
                                            ],
                                          ),const Spacer(),
                                         Row(
                                          children: [
                                             Icon(FontAwesomeIcons.plus, size: width*0.03, color: const Color.fromARGB(255, 245, 16, 104),),
                                          SizedBox(width: width*0.001,),
                                          Text("Add", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 245, 16, 104))),)
                                          ],
                                         ),
                                          SizedBox(width: width*0.02,),
                                                    
                                        ],
                                       ),
                                     )
                                  ],
                                ),
                              ),
                            );
                           },
                        ),
                      ),
                    ),
                  ),
    );
  }
}