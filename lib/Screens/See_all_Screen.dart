import 'package:booker/Screens/About_Broker_Screen.dart';
import 'package:booker/Widget/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  // Controller to handle search input
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgcolor,
        title: Text(
          "All Brokers",
          style: TextStyle(fontWeight: FontWeight.w600, color: tcolor),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: tcolor,
            )),
      ),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value
                      .toLowerCase(); // Convert to lowercase for case-insensitive search
                });
              },
              decoration: InputDecoration(
                hintText: "Search Brokers",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final users = snapshot.data!.docs;

                // Filter users based on the search query
                final filteredUsers = users.where((user) {
                  final username = user['name'].toString().toLowerCase();
                  return username.contains(_searchQuery);
                }).toList();

                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final String username = user['name'];
                      final String userId = user.id;
                      final data = user.data() as Map<String, dynamic>?;
                      final String? profileImageUrl =
                          data != null && data.containsKey('profileImageUrl')
                              ? data['profileImageUrl'] as String?
                              : null;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AboutBrokerScreen(userId: userId),
                              ),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(158, 0, 0, 0)),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      image: profileImageUrl != null
                                          ? NetworkImage(profileImageUrl)
                                          : AssetImage(
                                                  'assets/istockphoto-1452775956-612x612.jpg')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 105,
                                    top: 15,
                                    child: Text(
                                      username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    )),
                                Positioned(
                                    top: 40,
                                    left: 105,
                                    child: Row(
                                      children: [
                                        Text(
                                          "20",
                                          style: TextStyle(
                                              color: subTextcolor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "/",
                                          style: TextStyle(
                                              color: subTextcolor,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "week",
                                          style: TextStyle(
                                              color: subTextcolor,
                                              fontSize: 11),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
