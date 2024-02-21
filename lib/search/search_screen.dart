import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slate/view_model/user_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<UserViewModel>(context, listen: false)
          .fetchUserDataByUsername(query)
          .then((_) {
        print('Search results: ${Provider.of<UserViewModel>(context, listen: false).searchResults}');
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                child: Image.asset(
                  "assets/images/slate logo.png",
                  height: 35,
                ),
              ),
              Text("SLATE",
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(color: Colors.white, fontSize: 24))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: "Search username",
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white, width: 2))),
            onChanged: (value) {
              _performSearch(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Consumer<UserViewModel>(
            builder: (context, userViewModel, _) {
              if (userViewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              else if (userViewModel.searchResults.isEmpty) {
                return Center(child: Text("No users found"));
              }
              else {
                return Column(
                  children: userViewModel.searchResults.map((user) {
                    return Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: CircleAvatar(
                                backgroundImage: user?.profileImage != null
                                    ? NetworkImage(user!.profileImage!)
                                    : AssetImage("assets/images/profile.png") as ImageProvider,
                                radius: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(user.username ?? "", style: TextStyle(color: Colors.white, fontSize: 17)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        )

      ],
    ));
  }
}
