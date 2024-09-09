import 'package:booker/Screens/Profile_Screen.dart';
import 'package:booker/Screens/See_all_Screen.dart';
import 'package:booker/Widget/Brokers_List.dart';
import 'package:booker/Widget/Colors.dart';
import 'package:booker/Widget/carousel_slider.dart';
import 'package:booker/main.dart';
import 'package:booker/test.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        leading: Container(
          height: 40,
          width: 40,
          child: Image(
            image: AssetImage('assets/13-2-home-png-hd.png'),
            fit: BoxFit.cover,
          ),
        ),
        title: Text("bookerApp"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeeAll(),
                    ));
              },
              icon: Icon(
                Icons.search,
                size: 20,
              ))
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(15),
            CarouselSliderWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top brokers",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: tcolor),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeAll(),
                            ));
                      },
                      child: Text(
                        "See all",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: tcolor),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                children: [
                  Container(
                    color: bgcolor,
                    height: 340,
                    child: BrokersList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
