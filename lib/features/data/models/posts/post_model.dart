import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    String? postId,
    String? creatorUid,
    String? username,
    String? description,
    String? postImageUrl,
    String? userProfileUrl,
    List<String>? likes,
    num? totalLikes,
    num? totalComments,
    Timestamp? createAt,
  }) : super(
          postId: postId,
          creatorUid: creatorUid,
          username: username,
          description: description,
          postImageUrl: postImageUrl,
          userProfileUrl: userProfileUrl,
          likes: likes,
          totalLikes: totalLikes,
          totalComments: totalComments,
          createAt: createAt,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      postImageUrl: snapshot['postImageUrl'],
      userProfileUrl: snapshot['userProfileUrl'],
      likes: List.from(snap.get("likes")),
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "username": username,
        "description": description,
        "postImageUrl": postImageUrl,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
      };
}
