import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/profile/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> data = ["assets/images/dali in the ocean.jpg", "assets/images/dali in the ocean.jpg", "assets/images/dali in the ocean.jpg"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                child: Image.asset("assets/images/slate logo.png",
                height: 35,),
              ),
              Text("SLATE", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 24))),

              Padding(
                padding: const EdgeInsets.only(left: 170.0),
                child: ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, EditProfile.routeName);
                },
                    child: Text("Edit profile", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 9))),

                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(77.0, 25.0)
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            )
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.white)
                        )
                    )
                ),
              ),
            ],
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: CircleAvatar(backgroundImage: AssetImage("assets/images/dali in the ocean.jpg"), radius: 60,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("Salvador Dali", style: GoogleFonts.inter(textStyle: TextStyle(color: Colors.white, fontSize: 24))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("salvador_dali", style: GoogleFonts.inter(textStyle: TextStyle(color: Colors.white, fontSize: 12))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: 250,
                    child: Text("Student studying graphic design in the University of Melbourne",
                      style: GoogleFonts.inter(textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                    textAlign: TextAlign.center)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 2,
                  width: 350,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text("Work", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 22))),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 500,
              width: 0,
              child: GridView.builder(
                physics: const ScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 10),
                  itemBuilder: (context, index) => Container(
                    height: 115,
                    width: 75,
                    child: Image.asset(data[index]),
                  )
              ),
            ),
          )
        ]
      ),
    );
  }
}
