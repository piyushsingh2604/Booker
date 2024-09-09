import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  Future<List<String>> loaddata() async {
    final prefe = await SharedPreferences.getInstance();
    return prefe.getStringList("favList") ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loaddata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            var favlist = snapshot.data!;

            return ListView.builder(
              itemCount: favlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favlist[index]),
                );
              },
            );
          } else {
            return Center(
              child: Text("no data"),
            );
          }
        },
      ),
    );
  }
}
