import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    String? commentId,
    String? postId,
    String? creatorUid,
    String? description,
    String? username,
    String? userProfileUrl,
    Timestamp? createAt,
    List<String>? likes,
    num? totalReplays,
  }) : super(
          commentId: commentId,
          postId: postId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalReplays: totalReplays,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get("likes")),
      totalReplays: snapshot['totalReplays'],
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "postId": postId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "createAt": createAt,
        "likes": likes,
        "totalReplays": totalReplays,
      };
}
