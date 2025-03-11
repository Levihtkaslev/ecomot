import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/payment.dart/productrow.dart';
import 'package:frontendmobile/payment.dart/submit.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:frontendmobile/shimmer/nodata.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:convert';
import 'package:turn_page_transition/turn_page_transition.dart';

class cartee extends StatefulWidget {

  const cartee({super.key});

  @override
  State<cartee> createState() => _carteeState();
}

class _carteeState extends State<cartee> {
  List<dynamic> cartitems = [];
  double totalPrice = 0.0;
  List addresses = [];
  Map? selectedAddress;
  double totaloff = 0.0;
  var singleprice;
  String? userid;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getserid();
}

Future<void> getserid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedUserId = prefs.getString('phone');

  if (storedUserId != null) {
    setState(() {
      userid = storedUserId;
    });
    print("User ID: $userid");
    await fetchcart(); 
    await fetchAddresses();
  } else {
    print("No User ID Found!");
  }

  setState(() {
    isLoading = false;
  });
}


  
Future<void> fetchcart() async {
  try {
    final producturl = Uri.parse("$backendurl/item");
    final productres = await http.get(producturl);

    if (productres.statusCode != 200) {
      print("Failed to fetch products: ${productres.body}");
      return;
    }

    final List<dynamic> updatedItems = json.decode(productres.body);

    if (userid == null) {
      print("User ID is null, cannot fetch cart.");
      return;
    }

    final carturl = Uri.parse("$backendurl/cart/$userid");
    final res = await http.get(carturl);

    if (res.statusCode != 200) {
      print("Failed to fetch cart: ${res.body}");
      return;
    }

    final data = json.decode(res.body);

    if (data['usercart'] == null || data['usercart']['items'] == null) {
      print("No usercart found.");
      setState(() {
        cartitems = [];
      });
      return;
    }

    List<dynamic> cartItems = data['usercart']['items'];

    // Match cart items with product items
    List<dynamic> filteredCartItems = cartItems.where((cartItem) {
      return updatedItems.any((updatedItem) =>
          updatedItem['_id'].toString() == cartItem['itemid']);
    }).toList();

    setState(() {
      cartitems = filteredCartItems;
      calculateoffer();
    });

    print("Fetched cart items: $cartitems");

  } catch (e) {
    print("Error while fetching cart: $e");
  }
}



  Future fetchAddresses() async {
    final url = Uri.parse("$backendurl/address/$userid");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('useraddress') && data['useraddress'] is List) {
          setState(() {
            addresses = data['useraddress'];
          });
        } else {
          print("No addresses found");
        }
      } else {
        print("Failed to load addresses: ${response.body}");
      }
    } catch (error) {
      print("Error fetching addresses: $error");
    }
  }


  Future<void> deleteitem(String itemid, String? userid) async {
    final Uri url = Uri.parse('$backendurl/cart');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userid': userid, 'itemid': itemid}),
    );

    try {
      if (response.statusCode == 200) {
        setState(() {
          cartitems.removeWhere((item) => item['_id'] == itemid);
        });
        await fetchcart();
      }
    } catch (err) {
      print(err);
    }
  }

void updatePriceAndQty(String? userid, String itemid, double qty, Map item) async {
  try {
    final response = await http.put(
      Uri.parse('$backendurl/cart/qty_increase'),
      body: jsonEncode({
        'userid': userid,
        'itemid': itemid,
        'qty': qty,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final updatedItem = data['cart']['items'].firstWhere(
        (cartItem) => cartItem['itemid'] == itemid,
        orElse: () => null,
      );

      if (updatedItem != null) {
        setState(() {
          item['itemorip'] = updatedItem['itemtotalprice'].toString();
        });
      } else {
        print('Item not found in updated cart');
      }
    } else {
      print('Failed to update price and qty');
    }
  } catch (error) {
    print('Error updating price and qty: $error');
  }
}



  void calculateoffer() {
    setState(() {
      totaloff = cartitems.fold(0.0, (sum, item) {
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
        FocusScope.of(context).unfocus(); 
      },
      child: WillPopScope(
        onWillPop: () async {
          return await _showExitConfirmation();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: width*0.02,
            backgroundColor: Color.fromARGB(255, 243, 62, 107),
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(
            color: Colors.white,
            
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            
          ),
        
          body: GlowingOverscrollIndicator(
              color: const Color.fromARGB(255, 245, 114, 157),
              axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Container(
                
                padding: EdgeInsets.only(top: width * 0.04,right: width * 0.04,left: width * 0.04, ),
                
                child: userid == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
        
                          
        
                          SizedBox(width: width*0.1,),
                           Text("You have no items in cart See products.", style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: width*0.03) ),),
                  
                          Nodata(),
                          SizedBox(width: width*0.1,),
                          ElevatedButton(
        
                             style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              minimumSize: Size(width * width, width * 0.09),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const otproducts()));
                            },
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Explore Products", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03)),), SizedBox(width: width*0.01,),
                                Icon(Icons.send, color: Colors.white, size: width*0.03,)
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          cartitems.isEmpty
                              ? const Center(child: Nodata())
                              : GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.right,
                                color: const Color.fromARGB(255, 245, 114, 157),
                                child: Column(
                                          
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
        
                                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              
                              children: [
                                        SizedBox(height: width*0.03,),
                                Text("Congrats you earned ${totaloff.toString()}Rs through Cart Offer %", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(color: const Color.fromARGB(255, 255, 0, 242))),), SizedBox(width: width*0.01,),Icon(FontAwesomeIcons.gift, color: const Color.fromARGB(255, 241, 51, 98), size: width*0.04,)]),
                                          
                                        
                                    SizedBox(height: width*0.1,),
                                      
                                        
                                      
                                        
                                        
                                       
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          circle(width, Icons.verified,
                                              const Color.fromARGB(255, 4, 207, 180), const Color.fromARGB(255, 255, 255, 255)),
                                          line(width),
                                          circle(
                                              width,
                                              Icons.shopping_cart,
                                              const Color.fromARGB(255, 243, 159, 32),
                                              const Color.fromARGB(255, 255, 255, 255)),
                                          line(width),
                                          circle(
                                              width,
                                              Icons.system_security_update_good,
                                              const Color.fromARGB(255, 243, 159, 32),
                                              const Color.fromARGB(255, 255, 255, 255))
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
        
                                     
                                      SizedBox(
                                        height: width * 0.1,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(width*0.01),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 247, 243, 250),
                                          
                                        boxShadow: const [BoxShadow(color: Color.fromARGB(255, 195, 199, 201), spreadRadius: 1, blurRadius: 3)],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                        child: SizedBox(
                                          
                                          height: width * 0.5,
                                          child: GlowingOverscrollIndicator(
                                            axisDirection: AxisDirection.down,
                                                      color: const Color.fromARGB(255, 252, 41, 129).withOpacity(0.04),
                                            child: ListView.builder(
                                              itemCount: cartitems.length,
                                              itemBuilder: (context, index) {
                                                var item = cartitems[index];
                                                String url = item['itemimage'];
                                            
                                                return Padding(
                                                  padding:  EdgeInsets.all(width*0.02),
                                                  child: Card(
                                                    margin: EdgeInsets.all(width * 0.003),
                                                    color: const Color.fromARGB(255, 251, 245, 253),
                                                    shadowColor: Colors.lightBlueAccent,
                                                    borderOnForeground: true,
                                                    child: Column(children: [
                                                      SizedBox(
                                                        height: width * 0.2,
                                                        child: ListTile(
                                                            contentPadding:
                                                                EdgeInsets.all(width * 0.02),
                                                           
                                                            subtitle: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Container(
                                                                  height: width*0.2,
                                                                  width: width*0.1,
                                                                  decoration: BoxDecoration(
                                                                    shape:BoxShape.circle, 
                                                                    color: Colors.grey,
                                                                    image: DecorationImage(image: NetworkImage("$backendurl/ot/baseone/uploads/$url"))
                                                                    ),
                                                                ),
                                                                
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(item['itemname'], style: GoogleFonts.poppins(
                                                                              textStyle: TextStyle(
                                                                                  fontSize:
                                                                                      width * 0.03),
                                                                              color: const Color.fromARGB(255, 3, 146, 151)),),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "Price : ",
                                                                          style: GoogleFonts.poppins(
                                                                              textStyle: TextStyle(
                                                                                  fontSize:
                                                                                      width * 0.03),
                                                                              color: const Color.fromARGB(255, 84, 85, 84)),
                                                                        ),
                                                                        Text(
                                                                          "₹${item['itemorip']} -",
                                                                          style: GoogleFonts.roboto(
                                                                              textStyle: TextStyle(
                                                                                  fontSize:
                                                                                      width * 0.03),
                                                                              color: const Color
                                                                                  .fromARGB(255, 84, 85, 84)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                        
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                           "Qty : ",
                                                                           style: GoogleFonts.poppins(
                                                                               textStyle: TextStyle(
                                                                                   fontSize:
                                                                                       width * 0.03),
                                                                               color: const Color
                                                                                 .fromARGB(255, 84, 85, 84)),
                                                                         ),
                                                                         Text("${item['qty']} kg",
                                                                             style: GoogleFonts.poppins(
                                                                                 textStyle: TextStyle(
                                                                                     fontSize:
                                                                                         width *
                                                                                             0.03),
                                                                                 color: const Color
                                                                                     .fromARGB(255, 84, 85, 84))),
                                                                      ],
                                                                    ),
                                                        
                                                        
                                                                    SizedBox(
                                                                      height: width * 0.02,
                                                                    ),
                                                                    
                                                                   
                                                                  ],
                                                                ),
                                                        
                                                        
                                                        
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                        
                                                                    InkWell(
                                                                      onTap: () => deleteitem(item['itemid'], userid),
                                                                      child: Row(
                                                                        children: [
                                                                          Text("Remove", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: Colors.deepOrange)),),
                                                                          Icon(FontAwesomeIcons.trash, color: Colors.deepOrange, size: width*0.03,)
                                                                        ],
                                                                      )),
                                                                    SizedBox(height: width*0.03,),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: width * 0.1,
                                                                          child:
                                                                              DropdownButton<
                                                                                  double>(
                                                                            value: double.tryParse(
                                                                                    item['qty']
                                                                                            ?.toString() ??
                                                                                        "1.0") ??
                                                                                1.0,
                                                                            items: generateqty(
                                                                                    double.tryParse(item['qty']?.toString() ??
                                                                                            "1.0") ??
                                                                                        1.0,
                                                                                    double.tryParse(item['maxqty']?.toString() ??
                                                                                            "10.0") ??
                                                                                        10.0)
                                                                                .map((qty) {
                                                                              return DropdownMenuItem(
                                                                                value: qty,
                                                                                child: Text(qty
                                                                                    .toString()),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged:
                                                                                (newQty) {
                                                                              if (newQty !=
                                                                                  null) {
                                                                                setState(() {
                                                                                  item['qty'] =
                                                                                      newQty;
                                                                                });
                                                                                                                                    
                                                                                updatePriceAndQty(
                                                                                    userid,
                                                                                    item[
                                                                                        'itemid'],
                                                                                    newQty,
                                                                                    item);
                                                                              }
                                                                            },
                                                                            underline:
                                                                                Container(
                                                                              height: width *
                                                                                  0.0001,
                                                                            ),
                                                                            icon: const Icon(
                                                                                Icons
                                                                                    .arrow_drop_down,
                                                                                color: Color
                                                                                    .fromARGB(
                                                                                    255,
                                                                                    0,
                                                                                    226,
                                                                                    204),
                                                                                size: 30),
                                                                            style: GoogleFonts.poppins(
                                                                                textStyle: TextStyle(
                                                                                    fontSize:
                                                                                        width *
                                                                                            0.03,
                                                                                    color: const Color
                                                                                        .fromARGB(
                                                                                        255,
                                                                                        77,
                                                                                        77,
                                                                                        77))),
                                                                          ),
                                                                        ),
                                                        
                                                                                 SizedBox(
                                                                                 width:
                                                                                     width * 0.01),
                                                                             Text(
                                                                               "Kg",
                                                                               style: GoogleFonts
                                                                                   .poppins(
                                                                                       color: const Color
                                                                                           .fromARGB(
                                                                                           136,
                                                                                           32,
                                                                                           32,
                                                                                           32),
                                                                                       fontSize:
                                                                                           width *
                                                                                               0.03),
                                                                             )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                        
                                                        
                                                        
                                                              ],
                                                            ),
                                                           ),
                                                      ),
                                                    ]),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
            
                          SizedBox(height: width*0.1,),
                          Column(children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text("Buy More?", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, color: const Color.fromARGB(255, 241, 51, 98))),),
                              ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 241, 51, 98),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              minimumSize: Size(width*0.01, width * 0.09),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            ), child: Row(
                                children: [
                                  Text("Add More",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03, )),),
                                  SizedBox(width: width*0.01,),
                                  Icon(FontAwesomeIcons.circlePlus, color: Colors.white, size: width*0.03,)
                                ],
                              ),)
                            ],),
            
                            SizedBox(height: width*0.04,),
            
                            SizedBox(
                                    height: width*0.5,
                                    child: const prorow()),
            
                             
                          ],),
            
                           SizedBox(height: width*0.1,),
              
                            
                           SizedBox(
                            height: width*0.3,
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.9,
                              minChildSize: 0.7,
                              maxChildSize: 0.9,
                              expand:
                                  false,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 248, 239, 250),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Choose Location",
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 0, 182, 158),
                                              fontSize: width * 0.03,
                                            ),
                                          ), SizedBox(width: width*0.01,),
                                          Icon(FontAwesomeIcons.locationDot, size: width*0.03, color: const Color.fromARGB(255, 0, 182, 158),)
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Loading Indicator if address list is empty
                                      if (addresses.isEmpty)
                                        Center(child: Column(
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(255, 109, 107, 107),
                                              highlightColor: Colors.white,
                                              child: Container(
                                                  height: width*0.02,
                                                  width: width*02,
                                                  color: Colors.grey,
                                                ),
                                            ),
                                              Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(255, 109, 107, 107),
                                              highlightColor: Colors.white,
                                              child: Container(
                                                  height: width*0.02,
                                                  width: width*03,
                                                  color: Colors.grey,
                                                ),
                                            ), SizedBox(height: width*0.02,),
                                              Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(255, 109, 107, 107),
                                              highlightColor: Colors.white,
                                              child: Container(
                                                  height: width*0.02,
                                                  width: width*02,
                                                  color: Colors.grey,
                                                ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(255, 109, 107, 107),
                                             highlightColor: Colors.white,
                                              child: Container(
                                                height: width*0.02,
                                                width: width*03,
                                                color: Colors.grey,
                                              ),
                                            ),SizedBox(height: width*0.02,),
                                          ],
                                        ))
                                      else
                                        Expanded(
                                          child: ListView.builder(
                                            controller: scrollController,
                                            itemCount: addresses.length,
                                            itemBuilder: (context, index) {
                                              final address = addresses[index];
                                              return RadioListTile(
                                                title: Text(address['areaname']),
                                                subtitle: Text(
                                                    "${address['lat']}, ${address['state']}"),
                                                value: address,
                                                groupValue: selectedAddress,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedAddress = value as Map;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ), 
                          
                          
            
                            ElevatedButton(
                            onPressed: () {
                              if(selectedAddress== null){
                                showTopSnackBar(
                                  Overlay.of(context),
                                   CustomSnackBar.error(
                                    message:
                                        "Please Choose address before proceeding",
                                  ),
                                );
                              }else{
                                Navigator.push(
                                  context,
                                   PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 700),
                                      pageBuilder: (_, __, ___) => submitpage(
                                        userid: userid,
                                        cartitems:cartitems,
                                        selectedAddress:selectedAddress,
                                      ),
                                      transitionsBuilder: (_, animation, __, child) {
                                        return TurnPageTransition(
                                          animation: animation,
                                          overleafColor: const Color.fromARGB(255, 249, 244, 250),
                                          child: child,
                                        );
                                      },
                                    ),);
                              }
                            },
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
                                 Text("Next"),
                                 SizedBox(width: width*0.02,),
                                 Icon(FontAwesomeIcons.forward, color: Colors.white, size: width*0.03,)
                              ],
                            ),
                          ),
            
                           SizedBox(height: width*0.03,),
                             
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container line(double width) {
    return Container(
      width: width * 0.2,
      height: width * 0.001,
      color: Colors.green,
    );
  }

  Container circle(double width, IconData no, Color back, Color front) {
    return Container(
      width: width * 0.07,
      height: width * 0.07,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
        shape: BoxShape.circle,
        color: back,
      ),
      child: Icon(
        no,
        size: width * 0.03,
        color: front,
      ),
    );
  }

  List<double> generateqty(double start, double end) {
    List<double> option = [];
    for (double i = start; i <= end; i += 0.5) {
      option.add(i);
    }
    return option;
  }
}
