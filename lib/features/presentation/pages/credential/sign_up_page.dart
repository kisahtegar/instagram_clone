import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/presentation/widgets/form_container_widget.dart';

import '../../widgets/button_container_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            // NOTE: Instagram Logo
            Center(
              child: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
              ),
            ),
            sizeVer(15),
            // NOTE: Profile Picture add
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset('assets/profile_default.png'),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizeVer(30),
            // NOTE: FormContainerWidget for Username
            const FormContainerWidget(
              hintText: 'Username',
            ),
            sizeVer(15),
            // NOTE: FormContainerWidget for Email
            const FormContainerWidget(
              hintText: 'Email',
            ),
            sizeVer(15),
            // NOTE: FormContainerWidget for Password
            const FormContainerWidget(
              hintText: 'Password',
              isPasswordField: true,
            ),
            sizeVer(15),
            // NOTE: FormContainerWidget for Bio
            const FormContainerWidget(
              hintText: "Bio",
            ),
            sizeVer(15),
            // NOTE: ButtonContainerWidget for Sing Up
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign Up",
              onTapListener: () {},
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            const Divider(color: secondaryColor),
            // NOTE: Button to Sign In Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageConst.signInPage,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
