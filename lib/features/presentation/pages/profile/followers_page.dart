import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../widgets/profile_widget.dart';

class FollowersPage extends StatelessWidget {
  final UserEntity user;

  const FollowersPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text("Followers"),
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: user.followers!.isEmpty
                  ? _noFollowersWidget()
                  : ListView.builder(
                      itemCount: user.followers!.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<List<UserEntity>>(
                            stream: di
                                .sl<GetSingleUserUseCase>()
                                .call(user.followers![index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final singleUserData = snapshot.data!.first;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.singleUserProfilePage,
                                    arguments: singleUserData.uid,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: profileWidget(
                                            imageUrl:
                                                singleUserData.profileUrl),
                                      ),
                                    ),
                                    sizeHor(10),
                                    Text(
                                      "${singleUserData.username}",
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _noFollowersWidget() {
    return const Center(
      child: Text(
        "No Followers",
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
