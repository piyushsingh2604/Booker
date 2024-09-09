import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payments extends StatefulWidget {
  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  Razorpay _razorpay = Razorpay();

  Future<void> addDataToPaidUsers() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      String uid = user.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("User document does not exist.");
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance
          .collection('paid_users')
          .doc(uid)
          .set(data);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data added to paid_users collection.")));
    } catch (e) {
      print("Error adding data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding data to paid_users.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for responsiveness
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensure the column wraps tightly around its content
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns text in a straight line (left-aligned)
            children: [
              Text(
                'By pressing "Pay", you agree to the following terms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('1. You are purchasing special features.'),
              Text('2. No refunds will be provided after payment.'),
              Text('3. Features are provided immediately after purchase.'),
              Text('4. Payment will be processed securely.'),
              SizedBox(height: 20),
              Text(
                'Do you want to proceed?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        var options = {
                          'key': 'rzp_test_GcZZFDPP0jHtC4',
                          'amount': 10000, // amount in paise (₹100.00)
                          'name': 'Booker',
                          'description': '',
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com',
                          },
                        };

                        _razorpay.open(options);
                      },
                      child: Text("Pay")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Success");
    addDataToPaidUsers();
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    try {
      _razorpay.clear();
    } catch (e) {
      print(e);
    }
  }
}
