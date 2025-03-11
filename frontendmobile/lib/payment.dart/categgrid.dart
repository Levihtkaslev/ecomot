import 'package:flutter/material.dart';
import 'package:frontendmobile/process/products.dart';
import 'package:frontendmobile/statics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Categgrid extends StatefulWidget {
  const Categgrid({super.key});

  @override
  State<Categgrid> createState() => _CateggridState();
}

class _CateggridState extends State<Categgrid> {

List<dynamic> categlist = [];
final List<String> caticon = [
    "https://indianexpress.com/wp-content/uploads/2018/07/fish-sustainanbel-759.jpg",
     "https://img.etimg.com/thumb/msid-94857105,width-650,height-488,imgsize-227384,resizemode-75/fish-lead-story-.jpg", 
     "https://images.unsplash.com/photo-1601314002592-b8734bca6604?q=80&w=1936&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 
     "https://img.freepik.com/free-photo/baked-fish-dorado-with-lemon-fresh-salad-white-plate_2829-11062.jpg" 
   /* "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxummbQVaFLUEXZtnojyx0CEPbfeB2SuJ82xzwAX9cFPWQscrWtgM4Gz3KjKfEfG_0-pA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxummbQVaFLUEXZtnojyx0CEPbfeB2SuJ82xzwAX9cFPWQscrWtgM4Gz3KjKfEfG_0-pA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxummbQVaFLUEXZtnojyx0CEPbfeB2SuJ82xzwAX9cFPWQscrWtgM4Gz3KjKfEfG_0-pA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxummbQVaFLUEXZtnojyx0CEPbfeB2SuJ82xzwAX9cFPWQscrWtgM4Gz3KjKfEfG_0-pA&usqp=CAU"*/
     
];

@override
void initState(){
  super.initState();
  fetchcart();
}

Future<void> fetchcart () async{
  final url = await http.get(Uri.parse('$backendurl/web/category'));

  if(url.statusCode == 200){
    setState(() {
      categlist = json.decode(url.body);
    });

    
  }else{
    print("Failed to load categories");
  }
}
  
  @override
  Widget build(BuildContext context) {

    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: categlist.isEmpty? const Center(child: CircularProgressIndicator(),) : Padding(padding: 
       const EdgeInsets.all(8.0),
       child: GlowingOverscrollIndicator(
          color: const Color.fromARGB(255, 245, 114, 157),
          axisDirection: AxisDirection.left,
         child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            ), 
          itemCount: 4,
          itemBuilder: (context, index){
            var cat = categlist[index];
            var catimage = caticon[index];
            return InkWell(
              onTap: ()=> Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const otproducts())),
              child: Container(
                
              
                decoration: BoxDecoration(
                         boxShadow: const [BoxShadow(color: Color.fromARGB(255, 170, 172, 172), spreadRadius: 1, blurRadius: 5)],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                         
                          
                          borderRadius: BorderRadius.circular(10),
                        ),
                      height: width*0.3,
                      color: Colors.red,
                      child: Image.network(catimage, fit: BoxFit.fill,),
                      ),
                    Spacer(),
                    Text(cat['categname'], style: GoogleFonts.poppins(color: const Color.fromARGB(221, 66, 66, 66), fontSize: width*0.04),),
                  ],
                ),
              ),
            );
          }),
       ),
      ),
    );
  }
}