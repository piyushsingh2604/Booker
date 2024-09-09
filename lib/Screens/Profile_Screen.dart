import 'dart:io';

import 'package:booker/Screens/Edit_Screen.dart';
import 'package:booker/Screens/view_image.dart';
import 'package:booker/Widget/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  ProfileScreen({
    required this.email,
    required this.name,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> imageUrls = [];
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadImages();
  }

  Future<void> _loadProfileImage() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('profileImageUrl')) {
          setState(() {
            profileImageUrl = data['profileImageUrl'];
          });
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('images')) {
          setState(() {
            imageUrls = List<String>.from(data['images']);
          });
        } else {
          setState(() {
            imageUrls = [];
          });
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<void> pickAndUploadImage({bool isProfileImage = false}) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images/$uid/${image.name}');
        UploadTask uploadTask = storageRef.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        if (isProfileImage) {
          // Store profile image URL separately
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'profileImageUrl': downloadUrl,
          });

          setState(() {
            profileImageUrl = downloadUrl;
          });
        } else {
          // Update Firestore document with the new image URL
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'images': FieldValue.arrayUnion([downloadUrl]),
          });

          // Update local state to reflect the new image
          setState(() {
            imageUrls.add(downloadUrl);
          });
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              child: Expanded(
                child: Container(
                  color: bgcolor,
                  height: 650,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImageScreen(
                                    imageUrl: imageUrls[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 160,
                              width: 190,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrls[index]),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(72, 158, 158, 158),
                                    blurRadius: 5,
                                    spreadRadius: 3,
                                  )
                                ],
                                color: bgcolor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                height: 230,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/istockphoto-1452775956-612x612.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: bgcolor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 45,
                      child: InkWell(
                        onTap: () => pickAndUploadImage(isProfileImage: true),
                        child: Container(
                          height: 95,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            color: Colors.green,
                            border: Border.all(color: Colors.white, width: 2),
                            image: profileImageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: profileImageUrl == null
                              ? Icon(Icons.camera_alt, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 160,
                      top: 77,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            color: bgcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Positioned(
                      left: 160,
                      top: 97,
                      child: Text(
                        widget.email,
                        style: TextStyle(
                            color: bgcolor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 186,
              left: 20,
              right: 20,
              child: InkWell(
                onTap: pickAndUploadImage,
                child: Container(
                  child: Center(
                    child: Text('Pick & Upload Image'),
                  ),
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(81, 158, 158, 158),
                          blurRadius: 4,
                          spreadRadius: 3)
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
