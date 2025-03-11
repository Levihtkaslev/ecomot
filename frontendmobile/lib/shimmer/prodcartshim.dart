import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class prorowshim extends StatelessWidget {
  const prorowshim({super.key});

  @override
  Widget build(BuildContext context) {

     // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
 body: SizedBox(
  height: width * 0.5,
  child: GlowingOverscrollIndicator(
    color: const Color.fromARGB(255, 245, 114, 157),
    axisDirection: AxisDirection.right,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
           onTap: (){ },
          child: Column(
            children: [
              
             SizedBox(height: width*0.02,),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 109, 107, 107),
                                highlightColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                  height: width*0.2,
                  width: width*0.2,
                  margin: EdgeInsets.symmetric(horizontal: width*0.03,),
                  padding: EdgeInsets.all(width*0.02),
                  
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 109, 107, 107),
                                highlightColor: Colors.white,
                    child: Container(
                      height: width*0.5,
                      width:  width*0.5,
                      color: Colors.grey,
                    ),
                  ),
                
                ),
              ),
             
              
              
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