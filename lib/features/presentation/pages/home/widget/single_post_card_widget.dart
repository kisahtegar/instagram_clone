import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';

import '../../../../../consts.dart';
import '../../../cubit/post/post_cubit.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOTE : Picture, Username, more button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: profileWidget(
                        imageUrl: "${widget.post.userProfileUrl}",
                      ),
                    ),
                  ),
                  sizeHor(10),
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _openBottomModalSheet(context, widget.post);
                },
                child: const Icon(
                  Icons.more_vert,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          sizeVer(10),
          // NOTE : Container for video, foto, etc
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.30,
            child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
          ),
          sizeVer(10),
          // NOTE : Like, comment, share, saved button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Like
                  const Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                  sizeHor(10),
                  // Comment
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage);
                    },
                    child: const Icon(
                      Feather.message_circle,
                      color: primaryColor,
                    ),
                  ),
                  sizeHor(10),
                  // send share
                  const Icon(
                    Feather.send,
                    color: primaryColor,
                  ),
                ],
              ),
              // Save Button
              const Icon(Icons.bookmark_border, color: primaryColor)
            ],
          ),
          sizeVer(10),
          // NOTE : Like text
          Text(
            '${widget.post.totalLikes} likes',
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          sizeVer(10),
          // NOTE : Username and Description
          Row(
            children: [
              Text(
                "${widget.post.username}",
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeHor(10),
              Text(
                "${widget.post.description}",
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          sizeVer(10),
          // NOTE : View all comments
          Text(
            "View all ${widget.post.totalComments} comments",
            style: const TextStyle(color: darkGreyColor),
          ),
          sizeVer(10),
          // NOTE : Date Post
          Text(
            DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate()),
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }

  _openBottomModalSheet(BuildContext context, PostEntity post) {
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
                      onTap: _deletePost,
                      child: const Text(
                        "Delete Post",
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
                          PageConst.updatePostPage,
                          arguments: post,
                        );
                      },
                      child: const Text(
                        "Update Post",
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

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }
}
