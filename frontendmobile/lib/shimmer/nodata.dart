import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class Nodata extends StatefulWidget {
  const Nodata({super.key});

  @override
  State<Nodata> createState() => _NodataState();
}

class _NodataState extends State<Nodata> {

  late VideoPlayerController vcon;  

  @override
  void initState(){
    super.initState();
    vcon = VideoPlayerController.asset("asset/nodata.mp4")
    ..initialize().then((_){
      vcon.setLooping(true);
      vcon.play();
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
     // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: Colors.grey, spreadRadius: 1, blurRadius: 3
          )]
        ),
        height: width*0.4,
        width: width*0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Data found", style: GoogleFonts.redHatDisplay(textStyle: TextStyle(color: Colors.pink, fontSize: width*0.03)),),
            AspectRatio(
                    aspectRatio: vcon.value.aspectRatio,
                    child: VideoPlayer(vcon),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    vcon.dispose();
    super.dispose();
  }
}