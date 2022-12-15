import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/post/comment/widget/single_comment_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({super.key, required this.appEntity});

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);
    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Comments"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostLoaded) {
                  debugPrint("CommentMainWidget[build]: GetSinglePostLoaded");
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        debugPrint("CommentMainWidget[build]: CommentLoaded");
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOTE: Column of Username and Description
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile and Username
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: profileWidget(
                                            imageUrl: singlePost.userProfileUrl,
                                          ),
                                        ),
                                      ),
                                      sizeHor(10),
                                      Text(
                                        "${singlePost.username}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizeVer(10),
                                  // Description
                                  Text(
                                    "${singlePost.description}",
                                    style: const TextStyle(color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            sizeVer(10),
                            const Divider(color: secondaryColor),
                            sizeVer(10),
                            // NOTE: User comment output
                            Expanded(
                              child: ListView.builder(
                                itemCount: commentState.comments.length,
                                itemBuilder: (context, index) {
                                  final singleComment =
                                      commentState.comments[index];
                                  return SingleCommentWidget(
                                    comment: singleComment,
                                    onLongPressListener: () {
                                      _openBottomModalSheet(
                                        context: context,
                                        comment: commentState.comments[index],
                                      );
                                    },
                                    onLikeClickListener: () {
                                      debugPrint(
                                          "CommentMainWidget[onLikeClickListener]: Tapping!!");
                                      _likeComment(
                                          comment:
                                              commentState.comments[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                            // NOTE: User Comment Form
                            _commentSection(currentUser: singleUser),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
                debugPrint("CommentMainWidget[build]: GetSinglePostLoading");
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: currentUser.profileUrl),
              ),
            ),
            sizeHor(10),
            // TextFormField comment
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: primaryColor),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Post your comment...",
                  hintStyle: TextStyle(color: secondaryColor),
                ),
              ),
            ),
            // Post button
            InkWell(
              onTap: () {
                debugPrint("CommentMainWidget[PostButton]: Tap!!");
                _createComment(currentUser);
              },
              child: const Text(
                "Post",
                style: TextStyle(fontSize: 15, color: blueColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    debugPrint("CommentMainWidget[_createComment]: Passing!!");
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      comment: CommentEntity(
        totalReplays: 0,
        commentId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        username: currentUser.username,
        userProfileUrl: currentUser.profileUrl,
        description: _descriptionController.text,
        creatorUid: currentUser.uid,
        postId: widget.appEntity.postId,
      ),
    )
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentEntity comment}) {
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
                    child: InkWell(
                      onTap: () {
                        _deleteComment(
                          commentId: comment.commentId!,
                          postId: comment.postId!,
                        );
                      },
                      child: const Text(
                        "Delete Comment",
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageConst.updateCommentPage,
                          arguments: comment,
                        );
                      },
                      child: const Text(
                        "Update Comment",
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

  _deleteComment({required String commentId, required String postId}) {
    debugPrint("CommentMainWidget[_deleteComment]: Passing!!");
    BlocProvider.of<CommentCubit>(context).deleteComment(
        comment: CommentEntity(commentId: commentId, postId: postId));
  }

  _likeComment({required CommentEntity comment}) {
    debugPrint("CommentMainWidget[_likeComment]: Passing!!");
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }
}
