import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../../consts.dart';
import '../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../cubit/post/post_cubit.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  bool _isLikeAnimating = false;
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage[build]: Building!!");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOTE : Picture, Username, more button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.singleUserProfilePage,
                    arguments: widget.post.creatorUid,
                  );
                },
                child: Row(
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
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModalSheet(context, widget.post);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ),
                    )
                  : const SizedBox(height: 0, width: 0),
            ],
          ),
          sizeVer(10),
          // NOTE : Container for video, foto, etc
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Content Box
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                // Like animation
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                    duration: const Duration(milliseconds: 300),
                    isLikeAnimating: _isLikeAnimating,
                    onLikeFinish: () {
                      setState(() {
                        _isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          sizeVer(10),
          // NOTE : Like, comment, share, saved button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Like
                  GestureDetector(
                    onTap: _likePost,
                    child: Icon(
                      widget.post.likes!.contains(_currentUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: widget.post.likes!.contains(_currentUid)
                          ? Colors.red
                          : primaryColor,
                    ),
                  ),
                  sizeHor(10),
                  // Comment
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.commentPage,
                        arguments: AppEntity(
                          uid: _currentUid,
                          postId: widget.post.postId,
                        ),
                      );
                    },
                    child: const Icon(
                      FontAwesomeIcons.message,
                      color: primaryColor,
                    ),
                  ),
                  sizeHor(10),
                  // send share
                  const Icon(
                    FontAwesomeIcons.share,
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageConst.commentPage,
                arguments: AppEntity(
                  uid: _currentUid,
                  postId: widget.post.postId,
                ),
              );
            },
            child: Text(
              "View all ${widget.post.totalComments} comments",
              style: const TextStyle(color: darkGreyColor),
            ),
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
      post: PostEntity(
        postId: widget.post.postId,
        creatorUid: widget.post.creatorUid,
      ),
    );
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
      post: PostEntity(postId: widget.post.postId),
    );
  }
}
