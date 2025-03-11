import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class subhis extends StatelessWidget {

  final List<dynamic> cartdetails;
  const subhis({super.key, required this.cartdetails});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); 
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25), // Adjust the curve here
            ),
          ),
          elevation: width * 0.02,
          toolbarHeight: width * 0.2,
          backgroundColor: const Color.fromARGB(255, 241, 51, 98),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          title:  Text("Cart Details", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white), fontSize: width*0.04 ))),
        body: GlowingOverscrollIndicator(
          color: const Color.fromARGB(255, 245, 114, 157),
          axisDirection: AxisDirection.down,
          child: Padding(padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: cartdetails.length,
            itemBuilder: (context, index){
              var item = cartdetails[index];
              return Container(
               margin: EdgeInsets.all(width*0.02),
              padding: EdgeInsets.all(width*0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 251, 244, 253),
                 boxShadow: const [BoxShadow(
                  color:  Color.fromARGB(255, 175, 174, 174), blurRadius: 4, spreadRadius: 1, offset: Offset(0, 3),
                )],
                ),
                  
                
                child: ListTile(
                  
                    subtitle: Column(
                      children: [
                        buildRow("Item Name", width * 0.04,item['itemname']),
                        buildRow("Item Name", width * 0.04,item['itemname']),
                        buildRow("Total price", width * 0.04, int.tryParse(item['itemorip'].toString())?.toString() ?? "0"),
                        buildRow("Offer price",width * 0.04, int.tryParse(item['itemoffpr'].toString())?.toString() ?? "0"),
                        buildRow("Category",width * 0.04, item['itemcategory']),
                        buildRow("Original price",width * 0.04, int.tryParse(item['itemorip2'].toString())?.toString() ?? "0"),
                        buildRow("Item id", width * 0.04,item['itemid']),
                        ],
                    )
                ),
              );
            }
            
            )
          ),
        ),
      ),
    );
  }

    Widget buildRow(String property,double spacing, String value) {
 
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(property, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:spacing  ,color: const Color.fromARGB(255, 58, 59, 59))),),
        const Spacer(),
        Text(value,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: spacing, color: const Color.fromARGB(255, 1, 202, 175)))),
      ],
    );
  }
}