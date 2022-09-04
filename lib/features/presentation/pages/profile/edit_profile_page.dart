import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/presentation/pages/profile/widgets/profile_form_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Profile"),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, size: 32),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.done, color: blueColor, size: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            // NOTE: Image Profile
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
            sizeVer(15),
            const Center(
              child: Text(
                'Change profile photo',
                style: TextStyle(
                  color: blueColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            sizeVer(15),
            // NOTE: Name Form
            const ProfileFormWidget(
              title: 'Name',
            ),
            sizeVer(15),
            // NOTE: Username Form
            const ProfileFormWidget(
              title: 'Username',
            ),
            sizeVer(15),
            // NOTE: Website Form
            const ProfileFormWidget(
              title: 'Website',
            ),
            sizeVer(15),
            // NOTE: Bio Form
            const ProfileFormWidget(
              title: 'Bio',
            ),
          ],
        ),
      ),
    );
  }
}
