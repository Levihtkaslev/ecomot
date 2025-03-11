import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Produmesh extends StatelessWidget {
  const Produmesh({super.key});

  @override
  Widget build(BuildContext context) {
       // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:      
      
                  Container(
                    child: SizedBox(
                      height: width*0.6,
                      child: GlowingOverscrollIndicator(
                        color: const Color.fromARGB(255, 245, 114, 157),
                        axisDirection: AxisDirection.right,
                        child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: 10,
                           itemBuilder: (context, index){
                           
                            return InkWell(
                              onTap: (){},
                              child: Shimmer.fromColors(
                                baseColor: const Color.fromARGB(255, 109, 107, 107),
                                highlightColor: Colors.white,
                                child: Container(
                                   height: width*0.3, width : width*0.4,
                                   margin: EdgeInsets.all(width*0.02),
                                   padding: EdgeInsets.all(width*0.01),
                                   decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 248, 243, 250), 
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.circular(30)),
                                  
                                    ),
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