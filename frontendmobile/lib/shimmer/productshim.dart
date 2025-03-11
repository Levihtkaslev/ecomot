import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class proshim extends StatelessWidget {
  const proshim({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(width * 0.03),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin:  EdgeInsets.only(top: width*0.06),
              child: ListTile(
                leading: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 109, 107, 107),
                  highlightColor: Colors.white,
                  child: Container(
                    height: width * 0.3,
                    width: width * 0.3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,  // Add color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                title: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 109, 107, 107),
                  highlightColor: Colors.white,
                  child: Container(
                    height: width * 0.05,
                    width: width * 0.3,
                    color: Colors.grey, // Add color
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 109, 107, 107),
                      highlightColor: Colors.white,
                      child: Container(
                        height: width * 0.03,
                        width: width * 0.4,
                        color: Colors.grey, // Add color
                      ),
                    ),
                    const SizedBox(height: 5), // Add spacing
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 109, 107, 107),
                      highlightColor: Colors.white,
                      child: Container(
                        height: width * 0.03,
                        width: width * 0.3,
                        color: Colors.grey, // Add color
                      ),
                    ),
                    const SizedBox(height: 5), // Add spacing
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 109, 107, 107),
                      highlightColor: Colors.white,
                      child: Container(
                        height: width * 0.03,
                        width: width * 0.2,
                        color: Colors.grey, // Add color
                      ),
                    ),
                  ],
                ),
                trailing: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 109, 107, 107),
                  highlightColor: Colors.white,
                  child: Container(
                    height: width * 0.04,
                    width: width * 0.06,
                    color: Colors.grey, // Add color
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
