import 'package:flutter/material.dart';

import '../../../../consts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Username",
          style: TextStyle(color: primaryColor),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.menu,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "0",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8),
                          const Text(
                            "Posts",
                            style: TextStyle(color: primaryColor),
                          )
                        ],
                      ),
                      sizeHor(25),
                      Column(
                        children: [
                          const Text(
                            "54",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          sizeVer(8),
                          const Text(
                            "Followers",
                            style: TextStyle(color: primaryColor),
                          )
                        ],
                      ),
                      sizeHor(25),
                      Column(
                        children: [
                          const Text(
                            "123",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          sizeVer(8),
                          const Text(
                            "Following",
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              sizeVer(10),
              const Text(
                "Name",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeVer(10),
              const Text(
                "The bio of user",
                style: TextStyle(color: primaryColor),
              ),
              sizeVer(10),
              GridView.builder(
                itemCount: 32,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: secondaryColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
