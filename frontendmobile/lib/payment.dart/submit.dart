import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/login/b_navigation.dart';
import 'package:frontendmobile/payment.dart/categgrid.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class submitpage extends StatefulWidget {
  final String? userid;
  final List cartitems;
  final Map? selectedAddress;

  const submitpage({super.key, required this.cartitems, required this.userid, required this.selectedAddress});

  @override
  State createState() => _submitpageState();
}

class _submitpageState extends State<submitpage> {
  double totalconprice = 0.0;
  double totaloff = 0.0;
  double hi1 = 0.0;
  
  Map? userpers;
  String personname = '';

  @override
  void initState() {
    super.initState();
    calculateTotal();
    fetchallper();
    calculateoffer();
    hi();
  }



void calculateoffer() {
  setState(() {
    totaloff = widget.cartitems.fold(0.0, (sum, item) {
      double offerPrice = 0.0;

      
      if (item['itemoffpr'] != null) {
        if (item['itemoffpr'] is int) {
          offerPrice = item['itemoffpr'].toDouble();
        } else if (item['itemoffpr'] is String) {
          offerPrice = double.tryParse(item['itemoffpr']) ?? 0.0;
        } else {
          offerPrice = item['itemoffpr'];
        }
      }

      return sum + offerPrice;
    });

    
  });
}


  void calculateTotal() {
    double total = 0.0;
    for (var item in widget.cartitems) {
      total += double.tryParse(item['itemorip'].toString()) ?? 0.0;
    }
    setState(() {
      totalconprice = total;
     
    }); 
  }

  Future fetchallper() async {
    try {
      final Uri url = Uri.parse("$backendurl/profile");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List userlist = json.decode(response.body);
        var filter = userlist.firstWhere(
            (user) => user['cusphonenumber'].toString() == widget.userid,
            orElse: () => null);
        if (filter != null) {
          setState(() {
            userpers = filter;
            personname = filter['cusname'];
          });
        } else {
          print("No user");
        }
      } else {
        print("Failed to fetch");
      }
    } catch (err) {
      print("Error fetching $err");
    }
  }

    void hi (){
    setState(() {
      hi1 = totalconprice + 65 + totaloff;
    });
  }

    void showorderconfirmation(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      title: "Confirm Order",
      desc: "Are you sure you want to taste order?",
      btnCancelText: "No",
      btnOkText: "Yesss!",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        sendorder(widget.userid, widget.cartitems, widget.selectedAddress, personname);
      },
    ).show();
  }


  Future clearCart(String? userid) async {
    try {
      final Uri url = Uri.parse("$backendurl/cart/$userid");
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("Cart cleared successfully!");
      } else {
        print("Failed to clear cart: ${response.body}");
      }
    } catch (error) {
      print("Error clearing cart: $error");
    }
  }

  Future sendorder(String? userid, List cartitems, Map? selectedAddress,
      String personname) async {
    if (cartitems.isEmpty) {
      print("Cart is empty!");
      return;
    }
    bool issingleitem = cartitems.length == 1;
    Map orderdata = issingleitem
        ? {
            "personname": personname,
            "personnumber": userid,
            "itemname": cartitems[0]['itemname'],
            "itemqty": cartitems[0]['qty'],
            "itemprice": cartitems[0]['itemorip'],
            "cartdetails": cartitems,
            "itemcategory": cartitems[0]['itemcategory'],
            "itemaddress": selectedAddress
          }
        : {
            "personname": personname,
            "personnumber": userid,
            "itemname": "Combo",
            "itemqty": 0,
            "itemprice": totalconprice,
            "cartdetails": cartitems,
            "itemcategory": "Combo",
            "itemaddress": selectedAddress
          };

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
              Text("Generating requst"),
            ],
          ),
        );
      },
    );
    try {

          
      final response = await http.post(
        Uri.parse("$backendurl/buy"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderdata),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        

        print("Order placed successfully: ${response.body}");
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success!',
              text: 'Request sent successfully',
            );

          await clearCartInDatabase(userid!);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const navigation()), 
            (route) => false, 
          );

          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success!',
              text: 'Request sent successfully',
            );
      } else {
        print("Failed to place order: ${response.body}");
         QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops!',
            text: 'Something went wrong',
          );
      }
    } catch (e) {
      print("Error placing order: $e");
       QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops!',
          text: 'Something went wrong',
        );
    }
  }

  Future<void> clearCartInDatabase(String userid) async {
  final deleteUrl = Uri.parse('$backendurl/cart/clear');
  await http.post(
    deleteUrl,
    headers: {"Content-Type": "application/json"},
    body: json.encode({"userid": userid}),
  );
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus(); 
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25), 
            ),
          ),
          title: const Text("Confirmation"),
          elevation: width * 0.02,
          toolbarHeight: width * 0.2,
          backgroundColor: const Color.fromARGB(255, 241, 51, 98),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          shadowColor:  const Color.fromARGB(255, 180, 185, 185),
        ),
        body: GlowingOverscrollIndicator(
          color: const Color.fromARGB(255, 245, 114, 157),
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Container(
              
              padding: EdgeInsets.only(top: width * 0.04,right: width * 0.04,left: width * 0.04, ),
              
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: width * 0.1),
            
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circle(width, Icons.verified, const Color.fromARGB(255, 4, 207, 180), Colors.white),
                          line(width),
                          circle(width, Icons.shopping_cart, const Color.fromARGB(255, 4, 207, 180), const Color.fromARGB(255, 255, 255, 255)),
                          line(width),
                          circle(width, Icons.system_security_update_good, const Color.fromARGB(255, 243, 159, 32), const Color.fromARGB(255, 255, 255, 255))
                            ],
                          ),
            
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Products"),
                              Text("Cart List"),
                              Text("Confirmation"),
                              
                            ],
                          ),
                      SizedBox(height: width * 0.1),
          
                      Container(
                        
                        padding: EdgeInsets.all(width * 0.05, ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 241, 51, 98), boxShadow: [BoxShadow(
                          color: Color.fromARGB(255, 241, 51, 98), spreadRadius: 1, blurRadius: 1
                        )]),
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Delivery to:", style: GoogleFonts.poppins(fontSize: width*0.03, color: Colors.white),),
                            Row(
                              children: [
                                
                                    Icon(FontAwesomeIcons.locationDot, size: width*0.03, color: Colors.white,),
                                    Text("No : ${widget.selectedAddress?['residentno']},",  style: GoogleFonts.poppins(fontSize: width*0.02, color: Colors.white, fontWeight: FontWeight.w500)),
                                    SizedBox(width: width*0.02,),
                                    Text("${widget.selectedAddress?['streetname']} Street...", style: GoogleFonts.poppins(fontSize: width*0.02, color: Colors.white), overflow: TextOverflow.ellipsis,),
                                    const Spacer(),
                                    InkWell(onTap: () => Navigator.pop(context), child: Row(
                                      children: [
                                        Text("Change",style: GoogleFonts.poppins(fontSize: width*0.02, color: Colors.white)),
                                        SizedBox(width: width*0.01,),
                                        Icon(FontAwesomeIcons.sync, size: width*0.02, color: Colors.white,),
                                      ],
                                    )),
                                    
                              ],
                            ),
                                
                                
                              ],
                            )
                          
                        ),
                      
          
                      SizedBox(height: width*0.1,),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("User Id : ", style:
                                GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03, color: const Color.fromARGB(255, 63, 63, 63))),),
                          Text(" ${widget.userid}",
                            style:
                                GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03, color: const Color.fromARGB(255, 2, 178, 201))),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Price: ", style:
                                GoogleFonts.poppins(textStyle: TextStyle(fontSize: width * 0.03, color: const Color.fromARGB(255, 63, 63, 63))),),
                          Text(
                            "₹${totalconprice.toStringAsFixed(2)} Rs/-",
                            style:
                                GoogleFonts.roboto(textStyle: TextStyle(fontSize: width * 0.03,color: const Color.fromARGB(255, 2, 178, 201))),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.02),
                      Container(
                        padding: EdgeInsets.all(width*0.01),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 247, 243, 250),
                                      
                                    boxShadow: const [BoxShadow(color: Color.fromARGB(255, 162, 165, 165), spreadRadius: 1, blurRadius: 6)],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                         height: width * 0.5,
                        child: GlowingOverscrollIndicator(
                        color: const Color.fromARGB(255, 245, 114, 157),
                        axisDirection: AxisDirection.down,
                          child: ListView.builder(
                            itemCount: widget.cartitems.length,
                            itemBuilder: (context, index) {
                              var item = widget.cartitems[index];
                              return ListTile(
                                title: Text(
                                  item['itemname'],
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(fontSize: width * 0.03, color: const Color.fromARGB(255, 51, 51, 51))),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    buildRow("single price",
                                        double.tryParse(item['itemorip2'].toString())
                                                ?.toStringAsFixed(2) ??
                                            "0.00"),
                                    buildRow("Item Total price",
                                        double.tryParse(item['itemorip'].toString())
                                                ?.toStringAsFixed(2) ??
                                            "0.00"),
                                    
                                    buildRow("Item Quantity",
                                        int.tryParse(item['qty'].toString())?.toString() ?? "0"),
                                    SizedBox(height: width * 0.02),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: const Color.fromARGB(255, 221, 215, 215),
                                              width: width * 0.002),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: width * 0.02),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.2,),
          
                      Container(
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Container(
                              padding: EdgeInsets.only(top: width*0.02, bottom: width*0.02, left: width*0.02),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color.fromARGB(255, 245, 37, 117),Color.fromARGB(255, 240, 61, 130),Color.fromARGB(255, 241, 84, 144),Color.fromARGB(255, 243, 100, 155), ], begin: Alignment.centerLeft),
                                border: Border(left:  BorderSide(
                                  color: Colors.blue, width: width*0.02
                                ))
                              ),
                              child: Text("What about the juicy category...", style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: width*0.03)),)
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            minimumSize: Size(width*0.03, width * 0.09),
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                          ),
                              child: Row(
                                children: [
                                  Text("More", style: GoogleFonts.poppins(textStyle: TextStyle( fontSize: width*0.03)),),
                                  SizedBox(width: width*0.01,),
                                  Icon(FontAwesomeIcons.plus, color: Colors.white, size: width*0.03,)
                                ],
                              ),
                            )
                          ],),
                          SizedBox(height: width * 0.03),
                            SizedBox(
                                    height: width*01,
                                    child: const Categgrid()),
                        ],),
                      ),
          
                     SizedBox(height: width*0.1,),
          
                     
                      Container(
                        padding: EdgeInsets.symmetric(horizontal :width*0.04, vertical: width*0.03),
                        
                        
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 247, 243, 250),
                                     
                                    boxShadow: const [BoxShadow(color: Color.fromARGB(255, 164, 166, 167), spreadRadius: 1, blurRadius: 2)],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Summary", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, fontWeight: FontWeight.w600, )),),
                               SizedBox(height: width * 0.01),
                               buildRow("Total Price",
                                      double.tryParse(hi1.toString())
                                              ?.toStringAsFixed(2) ??
                                          "0.00"),
                               buildRow("Offer price",
                                      double.tryParse(totaloff.toString())
                                              ?.toStringAsFixed(2) ??
                                          "0.00"),
                               buildRow("Delivery Fee(Free*)",
                                      double.tryParse("65".toString())
                                              ?.toStringAsFixed(2) ??
                                          "0.00"),
                              buildRow("Pay Amount",
                                      double.tryParse(totalconprice.toString())
                                              ?.toStringAsFixed(2) ??
                                          "0.00"),
                              Text("Currently available only pay on deleivery", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.02, color: Colors.grey)),)
                          ],),
                      ),
                      SizedBox(height: width*0.03,),
                      ElevatedButton(
                        onPressed: () =>
                            showorderconfirmation(context),
                         style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)),
                          minimumSize: Size(width * width, width * 0.09),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Send Request"),
                                    SizedBox(width: width*0.01,),
                                  FaIcon( FontAwesomeIcons.paperPlane,size: width*0.03,color: const Color.fromARGB(255, 255, 255, 255),)
                                ],
                              ),
                      ),
          
                      SizedBox(height: width*0.03,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(String property, String value) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          property,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: width * 0.03,
              color: const Color.fromARGB(255, 89, 90, 90),
            ),
          ),
        ),
        const Spacer(),
        
        Text(
          value,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: width * 0.03,
              color: const Color.fromARGB(255, 0, 190, 190),
            ),
          ),
        ),
      ],
    );
  }
                            Container line(double width) {
                                return Container(
                                   width: width*0.2,
                                   height: width*0.001,
                                   color: Colors.green,
                                 );
                                }

                            Container circle(double width, IconData no, Color back, Color front) {
                              return Container(
                                  width: width*0.07,
                                  height: width*0.07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all( color: const Color.fromARGB(255, 255, 255, 255)),
                                    shape: BoxShape.circle,
                                    color: back,
                                  ),
                                  child:  Icon(no, size: width*0.03, color: front,),
                                );
                              }
}