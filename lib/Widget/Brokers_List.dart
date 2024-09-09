import 'package:booker/Screens/About_Broker_Screen.dart';
import 'package:booker/Widget/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrokersList extends StatefulWidget {
  const BrokersList({super.key});

  @override
  State<BrokersList> createState() => _BrokersListState();
}

class _BrokersListState extends State<BrokersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('paid_users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final String username = user['name'];
              final String userId = user.id;
              final data = user.data() as Map<String, dynamic>?;
              final String? profileImageUrl =
                  data != null && data.containsKey('profileImageUrl')
                      ? data['profileImageUrl'] as String?
                      : null;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutBrokerScreen(userId: userId),
                      ),
                    );
                  },
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(217, 158, 158, 158),
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                              fontSize: 15,
                            ),
                          ),
                        ),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "/",
                                style: TextStyle(
                                  color: subTextcolor,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "week",
                                style: TextStyle(
                                  color: subTextcolor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
