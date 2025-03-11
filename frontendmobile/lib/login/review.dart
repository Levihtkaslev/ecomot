import 'package:flutter/material.dart';
import 'package:frontendmobile/statics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {


  List<String> corousel = [];
  List<String> review = [];

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

  @override
  void initState(){
    super.initState();
    fetchallimages();
  }

  @override
  Widget build(BuildContext context) {
     // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GlowingOverscrollIndicator(
      color: const Color.fromARGB(255, 245, 114, 157),
      axisDirection: AxisDirection.down,
      child: Scaffold(
        body: review.isEmpty? Center(child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 109, 107, 107),
         highlightColor: Colors.white,
          child: Container(
                height: width*1,
                width: width*0.8,
                color: Colors.grey,
          ),
        ),) :  ListWheelScrollView(
          itemExtent: width*0.3, 
          diameterRatio: 2,
          physics: const FixedExtentScrollPhysics(),
          children: review.map((imageurl){
            return GlowingOverscrollIndicator(
              color: const Color.fromARGB(255, 245, 114, 157),
              axisDirection: AxisDirection.up,
              child: Container(
                height: width*0.01,
                width: width*0.8,
                
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(imageurl ),fit: BoxFit.cover,),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
            );
          }).toList()
        ),
      ),
    );
  }
}