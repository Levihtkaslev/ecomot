import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendmobile/address/address.dart';
import 'package:frontendmobile/login/login.dart';
import 'package:frontendmobile/shimmer/nodata.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendmobile/statics.dart';

class Getaddress extends StatefulWidget {

  final String? userid;
  const Getaddress({super.key, this.userid});

  @override
  State<Getaddress> createState() => _GetaddressState();
}

class _GetaddressState extends State<Getaddress> {

   List<dynamic> addresses = [];

     @override
    void initState() {
    super.initState();
    fetchaddresse();  
  }


Future<void> fetchaddresse() async {
  try {
    final response = await http.get(
      Uri.parse("$backendurl/address/${widget.userid}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      
      if (data.containsKey('useraddress') && data['useraddress'] is List) {
        setState(() {
          addresses = data['useraddress'];
        });
      } else {
        print("No addresses found");
      }
    } else {
      print("Failed to fetch addresses: ${response.body}");
    }
  } catch (e) {
    print("Error fetching addresses: $e");
  }
}

  Future<void> deleaddress(String deleteid) async{
      final Uri url = Uri.parse('$backendurl/${widget.userid}/$deleteid');
      final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    try{
      if(response.statusCode == 200){
          await fetchaddresse();  
      }
    }catch(err){
      print(err);
    }
}
  
  
  void getaaddress(BuildContext context) async {
   await Navigator.push(context, MaterialPageRoute(builder: (context) => CusAddress(userid: widget.userid)));
   await fetchaddresse();
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
      child: Scaffold(
         appBar: AppBar(
           shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25), // Adjust the curve here
            ),
          ),
          title: const Text("Your Address"),
          elevation: width*0.02,
          toolbarHeight: width*0.2,
          backgroundColor: const Color.fromARGB(255, 241, 51, 98),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          shadowColor:  const Color.fromARGB(255, 176, 177, 177) ,
          actions: [
           
            InkWell(
              onTap: () => getaaddress(context) ,
              child: Padding(
                padding:  EdgeInsets.all(width*0.02),
                child: Row(
                  children: [
                    Text("Add Location", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: width*0.03),),),
                    SizedBox(width: width*0.01,),
                     Icon(FontAwesomeIcons.locationDot, size: width*0.03, color: const Color.fromARGB(255, 243, 243, 243)),
                  ],
                )))
          ],
         ),
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.right,
            color: const Color.fromARGB(255, 245, 114, 157),
          child: widget.userid == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Please log in to view your address."),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const login()));
                        } 
                        ,
                        child: const Nodata(),
                      ),
                    ],
          
          ) : Container(
            margin: EdgeInsets.all(width*0.03),
              
            
            child: Column(
              children: [
                
                
                Expanded(
                  child: SizedBox(
                    
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return Container(
                          margin: EdgeInsets.all(width*0.03),
                          padding: EdgeInsets.all(width*0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 251, 244, 253),
                             boxShadow: const [BoxShadow(color: Color.fromARGB(255, 189, 188, 188),spreadRadius: 1, blurRadius: 3),]
                           ),
                          
                          child: ListTile(
                            
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width*0.05),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Resident/ Room no/ Building no",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['residentno']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Street",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['streetname']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Area",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['areaname']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("City",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['city']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Pincode",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['pincode']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Landmark",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['landmark']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
            
            
                                      Text("State",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['state']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Country",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['country']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Lattitude",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['lat']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
            
                                      Text("Longitude",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['longi']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
                  
                                      
                                      Text("Whatsapp",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 61, 61, 61), fontSize: width*0.03)),
                                      SizedBox(height: width*0.02,),
                                      Text("${address['whatsapp']}",style: GoogleFonts.poppins(color: const Color.fromARGB(255, 92, 92, 92), fontSize: width*0.02)),
                                      SizedBox(height: width*0.03,),
            
            
                                    ],
                                  )
                                ),
                                
                             
                              ],
                            ),
                            trailing: ElevatedButton(onPressed: () => deleaddress(address['_id']), child: Icon(Icons.delete, color: Colors.red, size: width*0.03,))
                          ),
                        );
                      },
                    ),
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