import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/main_screen/main_screen.dart';
import 'package:instagram_clone/features/presentation/widgets/form_container_widget.dart';

import '../../widgets/button_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid Email and Passowrd");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return _bodyWidget(context);
                }
              },
            );
          }
          return _bodyWidget(context);
        },
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Padding(
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
          FormContainerWidget(
            controller: _usernameController,
            hintText: 'Username',
          ),
          sizeVer(15),
          // NOTE: FormContainerWidget for Email
          FormContainerWidget(
            controller: _emailController,
            hintText: 'Email',
          ),
          sizeVer(15),
          // NOTE: FormContainerWidget for Password
          FormContainerWidget(
            controller: _passwordController,
            hintText: 'Password',
            isPasswordField: true,
          ),
          sizeVer(15),
          // NOTE: FormContainerWidget for Bio
          FormContainerWidget(
            controller: _bioController,
            hintText: "Bio",
          ),
          sizeVer(15),
          // NOTE: ButtonContainerWidget for Sing Up
          ButtonContainerWidget(
            color: blueColor,
            text: "Sign Up",
            onTapListener: () {
              _signUpUser();
            },
          ),
          sizeVer(10),
          // NOTE: Please Wait loading animation
          _isSigningUp == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Please Wait',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sizeHor(10),
                    const CircularProgressIndicator(),
                  ],
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
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
    );
  }

  void _signUpUser() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            bio: _bioController.text,
            totalPosts: 0,
            totalFollowing: 0,
            followers: const [],
            totalFollowers: 0,
            profileUrl: "",
            website: "",
            following: const [],
            name: "",
            // NOTE: Not passing UID
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      _isSigningUp = false;
    });
  }
}
