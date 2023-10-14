import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/activity/activity_page.dart';
import 'package:instagram_clone/features/presentation/pages/post/upload_post_page.dart';
import 'package:instagram_clone/features/presentation/pages/profile/profile_page.dart';
import 'package:instagram_clone/features/presentation/pages/search/search_page.dart';

import '../home/home_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;

  const MainScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          // debugPrint("MainScreen: currentUser($currentUser)");
          return Scaffold(
            backgroundColor: backGroundColor,
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                const HomePage(),
                const SearchPage(),
                UploadPostPage(currentUser: currentUser),
                const ActivityPage(),
                ProfilePage(currentUser: currentUser),
              ],
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: backGroundColor,
              onTap: navigationTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.house,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.circlePlus,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
