import 'package:booker/Widget/Colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastScreen = prefs.getString('lastScreen');

    if (lastScreen != null) {
      // Navigate to the last screen
      Navigator.of(context).pushReplacementNamed(lastScreen);
    } else {
      // Navigate to the initial selection screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeSelectionScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class HomeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgcolor,
        centerTitle: true,
        title: Text(
          'Booker',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shopping_cart_outlined,
            size: 90,
            color: Colors.yellow,
          ),
          Gap(50),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.blue[100],
                ),
                onPressed: () {
                  _navigateToHome(context, '/userHome');
                },
                child: Text('User'),
              ),
            ),
          ),
          Gap(30),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.blue[100],
                ),
                onPressed: () {
                  _navigateToHome(context, '/shopHome');
                },
                child: Text('Broker'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context, String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', routeName);

    Navigator.of(context).pushReplacementNamed(routeName);
  }
}
