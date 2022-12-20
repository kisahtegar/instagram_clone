import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/features/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../../consts.dart';
import '../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../cubit/post/post_cubit.dart';
import '../../../cubit/user/cubit/get_single_other_user_cubit.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleUserProfileMainWidget({
    Key? key,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSingleOtherUserCubit>(context)
        .getSingleOtherUser(otherUid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, userState) {
        if (userState is GetSingleOtherUserLoaded) {
          final singleUser = userState.otherUser;
          debugPrint("SingleUserProfileMainWidget: currentUser($singleUser)");
          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              backgroundColor: backGroundColor,
              title: Text(
                "${singleUser.username}",
                style: const TextStyle(color: primaryColor),
              ),
              actions: [
                _currentUid == singleUser.uid
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: InkWell(
                          onTap: () {
                            _openBottomModalSheet(
                              context: context,
                              currentUser: singleUser,
                            );
                          },
                          child: const Icon(
                            Icons.menu,
                            color: primaryColor,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOTE: Picture, post, followers, Following
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:
                                profileWidget(imageUrl: singleUser.profileUrl),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${singleUser.totalPosts}",
                                  style: const TextStyle(
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
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  PageConst.followersPage,
                                  arguments: singleUser,
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${singleUser.totalFollowers}",
                                    style: const TextStyle(
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
                            ),
                            sizeHor(25),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  PageConst.followingPage,
                                  arguments: singleUser,
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${singleUser.totalFollowing}",
                                    style: const TextStyle(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    sizeVer(10),
                    // NOTE: Name
                    Text(
                      "${singleUser.name == "" ? singleUser.username : singleUser.name}",
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sizeVer(10),
                    // NOTE: Bio
                    Text(
                      "${singleUser.bio}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(10),
                    // NOTE: Following Button
                    _currentUid == singleUser.uid
                        ? Container()
                        : ButtonContainerWidget(
                            text: singleUser.followers!.contains(_currentUid)
                                ? "UnFollow"
                                : "Follow",
                            color: singleUser.followers!.contains(_currentUid)
                                ? secondaryColor.withOpacity(.4)
                                : blueColor,
                            onTapListener: () {
                              BlocProvider.of<UserCubit>(context)
                                  .followUnFollowUser(
                                      user: UserEntity(
                                uid: _currentUid,
                                otherUid: widget.otherUserId,
                              ));
                            },
                          ),
                    sizeVer(10),
                    // NOTE: Picture, video, etc
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts
                              .where((post) =>
                                  post.creatorUid == widget.otherUserId)
                              .toList();
                          return GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.postDetailPage,
                                    arguments: posts[index].postId,
                                  );
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: profileWidget(
                                    imageUrl: posts[index].postImageUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required UserEntity currentUser}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "More Options",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  sizeHor(8),
                  const Divider(thickness: 1, color: secondaryColor),
                  sizeHor(8),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          PageConst.editProfilePage,
                          arguments: currentUser,
                        );
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  sizeVer(7),
                  const Divider(thickness: 1, color: secondaryColor),
                  sizeVer(7),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<AuthCubit>(context).loggedOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          PageConst.signInPage,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  sizeVer(7),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
