import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/process/productdetail.dart';
import 'package:frontendmobile/shimmer/prodcartshim.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class prorow extends StatefulWidget {
  const prorow({super.key});

  @override
  State<prorow> createState() => _prorowState();
}

class _prorowState extends State<prorow> {

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
 body: products.isEmpty? const Center(child: prorowshim(),): SizedBox(
  height: width * 0.5,
  child: GlowingOverscrollIndicator(
    color: const Color.fromARGB(255, 245, 114, 157),
    axisDirection: AxisDirection.right,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      itemBuilder: (context, index) {
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
          child: Column(
            children: [
               Text("MRP ₹${thispro['itemorip'].toString()} Rs", style: GoogleFonts.roboto(fontSize: width*0.03, color: const Color.fromARGB(255, 2, 207, 190)),overflow: TextOverflow.ellipsis),
              Text("MRP ₹${thispro['itemoffpr'].toString()} Rs", style: GoogleFonts.roboto(fontSize: width*0.03,color: const Color.fromARGB(255, 75, 71, 71), decoration: TextDecoration.lineThrough, decorationColor: const Color.fromARGB(255, 255, 0, 0)), overflow: TextOverflow.ellipsis,),
             SizedBox(height: width*0.02,),
              Container(
                height: width*0.2,
                width: width*0.2,
                margin: EdgeInsets.symmetric(horizontal: width*0.03,),
                padding: EdgeInsets.all(width*0.02),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 240, 247),
                  borderRadius: BorderRadius.circular(25),
                   boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 71, 71, 71).withOpacity(0.2), 
                        spreadRadius: 1, 
                        blurRadius: 5, 
                        offset: const Offset(0, 5), 
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(255, 71, 71, 71).withOpacity(0.2), 
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(-3, 0),
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(255, 71, 71, 71).withOpacity(0.2), 
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(3, 0), 
                      ),
                    ],
                ),
               
                child: Container(
                  height: width*0.5,
                  width:  width*0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(imageurl ),fit: BoxFit.cover,),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              
              ),
              SizedBox(height: width*0.02,),
              Text("${thispro['itemname']}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 68, 67, 67), overflow:TextOverflow.ellipsis )),),
              SizedBox(height: width*0.02,),
              ElevatedButton(onPressed: (){},
               style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 51, 98),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)),
               
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ), child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, )),),
                  SizedBox(width: width*0.02,),
                  Icon(FontAwesomeIcons.cartShopping, size: width*0.03, color: Colors.white,)
                ],
              ),
              )
            ],
          ),
        );
      },
    ),
  ),
),

    );
  }
}