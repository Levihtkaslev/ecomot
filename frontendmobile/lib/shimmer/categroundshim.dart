import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class catround extends StatelessWidget {
  const catround({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GlowingOverscrollIndicator(
        
        axisDirection: AxisDirection.left,
        color: const Color.fromARGB(255, 245, 114, 157),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index){
             return Container(
              color: Color.fromARGB(255, 47, 223, 236),
               child: InkWell(
                onTap: (){},
               
                child: Column(children: [
                  Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 109, 107, 107),
                    highlightColor: Colors.white,
                    child: Container(
                      height: width*0.3,
                      width:width*0.3,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        
                          shape: BoxShape.circle),                
                    ),
                  ),
                    SizedBox(height: width*0.02,),
                   Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 109, 107, 107),
                    highlightColor: Colors.white,
                     child: Container(
                      height: width*0.02,
                      width: width*0.2,
                      color: Colors.grey,
                     ),
                   )
                ],),
               ),
             );
          }),
      )
    );
  }
}
