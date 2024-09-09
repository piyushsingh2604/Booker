// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class EditScreen extends StatefulWidget {
//   @override
//   _EditScreenState createState() => _EditScreenState();
// }

// class _EditScreenState extends State<EditScreen> {
//   TextEditingController expController = TextEditingController();
//   TextEditingController prizeController = TextEditingController();

//   // Function to update the logged-in user's document in Firestore
//   Future<void> updateUserData() async {
//     try {
//       // Get the current logged-in user's UID
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         String uid = user.uid;

//         // Update the user's Firestore document
//         await FirebaseFirestore.instance.collection('users').doc(uid).update({
//           'exp': expController.text,
//           'prize': prizeController.text,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data updated successfully!')),
//         );
//       } else {
//         // Handle case when the user is not logged in
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('User is not logged in!')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update data: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit User Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: expController,
//               decoration: InputDecoration(
//                 hintText: "Experience",
//                 labelText: "Experience",
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: prizeController,
//               decoration: InputDecoration(
//                 hintText: "Prize",
//                 labelText: "Prize",
//               ),
//             ),
//             SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: updateUserData, // Call the update function
//               child: Text("Update"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
