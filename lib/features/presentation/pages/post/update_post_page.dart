import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

import '../profile/widgets/profile_form_widget.dart';

class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text('Edit Post'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.done, color: blueColor, size: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // NOTE : User image
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              sizeVer(10),
              // NOTE : Username
              const Text(
                "Username",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeVer(10),
              // NOTE : ?
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: secondaryColor),
              ),
              sizeVer(10),
              // NOTE : Description Page
              const ProfileFormWidget(
                title: "Description",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
