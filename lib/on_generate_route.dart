import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/pages/credential/sign_in_page.dart';
import 'package:instagram_clone/features/presentation/pages/credential/sign_up_page.dart';
import 'package:instagram_clone/features/presentation/pages/post/comment/comment_page.dart';
import 'package:instagram_clone/features/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:instagram_clone/features/presentation/pages/post/post_detail/post_detail_page.dart';
import 'package:instagram_clone/features/presentation/pages/post/update_post_page.dart';
import 'package:instagram_clone/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:instagram_clone/features/presentation/pages/profile/followers_page.dart';
import 'package:instagram_clone/features/presentation/pages/profile/following_page.dart';
import 'package:instagram_clone/features/presentation/pages/profile/single_user_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(currentUser: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(UpdatePostPage(post: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(EditCommentPage(comment: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.commentPage:
        {
          if (args is AppEntity) {
            return routeBuilder(CommentPage(appEntity: args));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.postDetailPage:
        {
          if (args is String) {
            return routeBuilder(PostDetailPage(postId: args));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.singleUserProfilePage:
        {
          if (args is String) {
            return routeBuilder(SingleUserProfilePage(otherUserId: args));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.followingPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowingPage(user: args));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.followersPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowersPage(user: args));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageConst.signInPage:
        {
          return routeBuilder(const SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      default:
        {
          const NoPageFound();
        }
    }
    return null;
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
