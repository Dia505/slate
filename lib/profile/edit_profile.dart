import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/widget/common_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const String routeName = "/editProfile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final database = FirebaseDatabase.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();


  @override
  void initState() {

// _nameController.text =  await prefs.getString('email');
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 50.0),
                  child: Image.asset("assets/images/slate logo.png",
                    height: 35,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text("SLATE", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 24))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55.0, left: 220.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      // Navigator.p(context, ProfileScreen.routeName);
                    },
                      child: Image.asset("assets/images/cross.png", height: 30.0,)),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: CircleAvatar(backgroundImage: AssetImage("assets/images/dali in the ocean.jpg"), radius: 60,),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(onPressed: () {},
                  child: Text("Edit", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 14))),

                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                          Size(49.0, 24.0)
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
            
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 300.0),
              child: Text("Name", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 20))),
            ),
            CommonTextField(
              controller: _nameController,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 300.0),
              child: Text("Username", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 20))),
            ),
            CommonTextField(
              controller: _userNameController,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 300.0),
              child: Text("About", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 20))),
            ),
            CommonTextField(
              controller: _aboutController,
            ),

            ElevatedButton(onPressed: () {},
                child: Text("Confirm changes", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 14, color: Colors.black))),

                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(145.0, 32.0)
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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

            //StreamBuilder listens and updates data as soon as there is event change
            //FutureBuilder only listens once
            //stream listens to the object of database
            //the listened data goes in snapshot after passing context in builder
            // StreamBuilder(stream: database.ref("User").onValue, builder: (context, snapshot) {
            //   if(snapshot.hasData) {
            //     //Map: key-value, dynamic defines any data type
            //     Map<dynamic,dynamic> data1 = snapshot.data!.snapshot.value as dynamic;
            //     List<dynamic> value = data1.values.toList();
            //     List<dynamic> key = data1.keys.toList();
            //     print(data1);
            //     print(value);
            //
            //     return Column(
            //       children: [
            //         ...List.generate(value.length, (index) {
            //           return ListTile(
            //             title: Text(value[index]["email"], style: TextStyle(color: Colors.white),),
            //             trailing: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   IconButton(onPressed: () async{
            //
            //
            //                     //Are you sure u want to delete?
            //                     await showDialog(context: context,
            //                         builder: (context) => AlertDialog(
            //                           title: Text("Edit data"),
            //                           content: Container(
            //                             height: 600,
            //                             child: Column(
            //                               children: [
            //                                 Text("name"),
            //                                 TextFormField(
            //                                     initialValue: value[index]["fullname"],
            //                                     controller: _fullNameController)
            //                               ],
            //                             ),
            //                           ),));
            //                   }, icon:Icon(Icons.edit), color: Colors.white,),
            //
            //                   //DELETE CODE
            //                   IconButton(onPressed: () async {
            //                     await database
            //                         .ref("User")
            //                         .child(key[index])
            //                         .remove()
            //                         .then((value) {
            //                       ScaffoldMessenger.of(context).showSnackBar(
            //                           SnackBar(content: Text("Deletion successful")));
            //                     }).onError((error, stackTrace) {
            //                       ScaffoldMessenger.of(context).showSnackBar(
            //                           SnackBar(content: Text("Deletion failed")));
            //                     });
            //                   }, icon:Icon(Icons.delete), color: Colors.white,),
            //                 ]
            //             ),
            //           );
            //         })
            //       ],
            //     );
            //   }
            //   else if(snapshot.hasError) {
            //     return Text(snapshot.error.toString());
            //   }
            //   return Align(
            //       alignment: Alignment.center,
            //       child: CircularProgressIndicator());
            // },
            // ),
          ],
        ),
      ),

    );
  }
}
