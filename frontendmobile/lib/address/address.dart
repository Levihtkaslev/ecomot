import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:frontendmobile/statics.dart';

class CusAddress extends StatefulWidget {
  final String? userid;
  const CusAddress({super.key, required this.userid});

  @override
  State<CusAddress> createState() => _CusAddressState();
}

class _CusAddressState extends State<CusAddress> {

  final TextEditingController streetname = TextEditingController();
  final TextEditingController residentno = TextEditingController();
  final TextEditingController areaname = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController landmark = TextEditingController();
  final TextEditingController whatsapp = TextEditingController();
  final TextEditingController lat = TextEditingController();
  final TextEditingController longi = TextEditingController();

  LatLng? selectedLocation; // Store selected location

  void confirmation (){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: "Add Address",
      desc: "Create Location?",
      btnCancelText: "oopse!",
      btnOkText: "Yaa..",
      btnCancelOnPress: (){},
      btnOkOnPress: (){
        addaddress();
      }
    ).show();
  }

  Future<void> addaddress() async {
    final response = await http.post(
      Uri.parse("$backendurl/address"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userid": widget.userid,
        "useraddress": {
          "userid": widget.userid,
          "streetname": streetname.text,
          "residentno": residentno.text,
          "areaname": areaname.text,
          "city": city.text,
          "pincode": pincode.text,
          "state": state.text,
          "country": country.text,
          "contact": contact.text,
          "landmark": landmark.text,
          "whatsapp": whatsapp.text,
          "lat": lat.text,
          "longi": longi.text
        }
      }),
    );

    try {
      if (response.statusCode == 201) {
           
        Navigator.pop(context);
         QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success!',
              text: 'Address addedd successfully',
            );
      }
    } catch (e) {
      print("Error: ${response.body}");
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops!',
          text: 'Address got error',
        );
    }
  }

  // Open the map to select a location
  Future<void> openMap() async {
    // Open Map Screen to select the location
    LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null) {
      setState(() {
        selectedLocation = result;
        lat.text = result.latitude.toString();
        longi.text = result.longitude.toString();
      });
    }
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
          title: const Text("Add Address"),
          shadowColor:  const Color.fromARGB(255, 169, 170, 170) ,
          elevation: width*0.02,
          toolbarHeight: width*0.2,
          backgroundColor: const Color.fromARGB(255, 241, 51, 98),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),),
        body: SingleChildScrollView(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.right,
            color: const Color.fromARGB(255, 245, 114, 157),
            child: Container(
              margin: EdgeInsets.all(width*0.03),
              padding: EdgeInsets.all(width*0.05),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 253, 240, 255), borderRadius: BorderRadius.circular(15), boxShadow: const [
                BoxShadow(color: Color.fromARGB(255, 186, 187, 187), spreadRadius: 2, blurRadius: 3)
              ]),
              child: Column(
                children: [
                  newMethod(streetname, width*0.03, "street*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.0,),
                  newMethod(residentno, width*0.03, "Resident no*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(areaname, width*0.03, "Area*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(city, width*0.03, "city*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(pincode, width*0.03, "Pincode*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(state, width*0.03, "State", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(country, width*0.03, "Country", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(contact, width*0.03, "Contact", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(landmark, width*0.03, "Landmark*", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(whatsapp, width*0.03, "Whatsapp", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.04,),
                  ElevatedButton(
                    onPressed: openMap, 
                    style: ElevatedButton.styleFrom(
                       backgroundColor: const Color.fromARGB(255, 0, 183, 196),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                  minimumSize: Size(width*0.2, width*0.09),
                                  foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                    ), 
                    child: const Text("Pick Location on Map"),),
                  newMethod(lat, width*0.03, "Latitude", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.03,),
                  newMethod(longi, width*0.03, "Longitude", width*0.03, width*0.003,),
                  SizedBox(height:  width*0.07,),
                  
              
                  ElevatedButton(
                    onPressed: confirmation,
                    style: ElevatedButton.styleFrom(
                       backgroundColor: const Color.fromARGB(255, 0, 194, 145),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                  minimumSize: Size(width*0.2, width*0.09),
                                  foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                    ), 
                    child: const Text("Save Address"),
                   
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField newMethod(controll, double width1, String label, double width2, double width3) {
    return TextField(
            controller: controll,
            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 63, 63, 63), fontSize: width1), 
            decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.poppins(color: const Color.fromARGB(255, 59, 59, 59), fontSize: width2),
                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color: const Color.fromARGB(255, 9, 201, 201).withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder( borderSide: BorderSide(color: const Color.fromARGB(255, 24, 236, 226), width: width3),), contentPadding: EdgeInsets.symmetric(horizontal: width2)
                          ),
            );
  }
}



class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController mapController = MapController();
  LatLng? currentLocation; // Store the user's current location
  LatLng selectedPosition = const LatLng(37.7749, -122.4194); // Default position (San Francisco)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch the user's location when the screen loads
  }

  // Fetch the user's current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        selectedPosition = currentLocation!; 
      });// Set the selected position to the current location
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator()) 
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                 
                minZoom: 2.0, 
                maxZoom: 18.0, 
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedPosition = point; 
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedPosition, 
                       child:const Icon(Icons.location_on, color: Colors.red), 
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, selectedPosition); 
        },
      ),
    );
  }
}