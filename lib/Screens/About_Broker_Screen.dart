import 'package:booker/Screens/view_image.dart';
import 'package:booker/Widget/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutBrokerScreen extends StatelessWidget {
  final String userId;

  AboutBrokerScreen({required this.userId});

  Future<Map<String, dynamic>?> _getUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Broker",
          style: TextStyle(
              fontSize: 17, color: tcolor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _getUserData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('User data not found'));
            }

            final userData = snapshot.data!;
            final String username = userData['name'];
            final String number = userData['number'];
            final String mail = userData['email'];
            final String? pfimage = userData['profileImageUrl'];

            final List<String> imageUrls = userData['images'] != null
                ? List<String>.from(userData['images'])
                : [];

            return Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          child: Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: pfimage != null
                                              ? NetworkImage(pfimage)
                                              : AssetImage(
                                                  'assets/istockphoto-1452775956-612x612.jpg'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Positioned(
                                    left: 90,
                                    top: 5,
                                    child: Text(
                                      username,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Positioned(
                                    left: 90,
                                    top: 30,
                                    child: Text(
                                      "+91 ${number}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                            "About",
                            style: TextStyle(
                                color: tcolor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 110,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        child: Icon(
                                          Icons.support_agent_rounded,
                                          size: 27,
                                        ),
                                      ),
                                      Positioned(
                                          left: 40,
                                          top: 0,
                                          child: Text(
                                            "Service fee",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          )),
                                      Positioned(
                                          top: 16,
                                          left: 40,
                                          child: Row(
                                            children: [
                                              Text(
                                                "20",
                                                style: TextStyle(
                                                    color: tcolor,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "/",
                                                style: TextStyle(
                                                    color: tcolor,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "week",
                                                style: TextStyle(
                                                    color: tcolor,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Gap(40),
                                VerticalDivider(
                                  indent: 8,
                                  endIndent: 16,
                                  color: Colors.grey[200],
                                  thickness: 1.5,
                                ),
                                Gap(40),
                                Container(
                                  height: 70,
                                  width: 110,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 5,
                                        child: Icon(
                                          Icons.work_outline_rounded,
                                          size: 27,
                                        ),
                                      ),
                                      Positioned(
                                          left: 40,
                                          top: 0,
                                          child: Text(
                                            "Location",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          )),
                                      Positioned(
                                          top: 16,
                                          left: 40,
                                          child: Text(
                                            "India",
                                            style: TextStyle(
                                                color: tcolor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          indent: 23,
                          endIndent: 15,
                          color: Colors.grey[200],
                          thickness: 1.6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  child: Icon(
                                    Icons.email_outlined,
                                    size: 27,
                                  ),
                                ),
                                Positioned(
                                    left: 40,
                                    top: 0,
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    )),
                                Positioned(
                                    top: 16,
                                    left: 40,
                                    child: Text(
                                      mail,
                                      style: TextStyle(
                                          color: tcolor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          indent: 23,
                          endIndent: 15,
                          color: Colors.grey[200],
                          thickness: 1.6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  child: Icon(
                                    Icons.home_outlined,
                                    size: 27,
                                  ),
                                ),
                                Positioned(
                                    left: 40,
                                    top: 0,
                                    child: Text(
                                      "Results",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    )),
                                Positioned(
                                    top: 16,
                                    left: 40,
                                    child: Text(
                                      "Houses sold by him",
                                      style: TextStyle(
                                          color: tcolor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 25), // Added bottom padding
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: imageUrls.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImageScreen(
                                          imageUrl: imageUrls[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrls[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(80)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 550,
                  bottom: 20,
                  child: Container(
                    height: 50,
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            launchUrlString("tel://${number}");
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      color: const Color.fromARGB(
                                          142, 158, 158, 158))
                                ],
                                color: const Color.fromARGB(187, 0, 0, 0),
                                borderRadius: BorderRadius.circular(9)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: const Color.fromARGB(
                                        224, 255, 255, 255),
                                  ),
                                  Gap(8),
                                  Text(
                                    "Call now",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            224, 255, 255, 255)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
