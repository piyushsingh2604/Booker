import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController name = TextEditingController();
  TextEditingController prise = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: name,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: prise,
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(onPressed: addbutton, child: Text("Next"))
        ],
      ),
    );
  }

  Future<void> addbutton() async {
    CollectionReference collref =
        FirebaseFirestore.instance.collection("Brokers");
    await collref.add({"name": name.text, "prise": prise.text});
  }
}
