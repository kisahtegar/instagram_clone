import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';

class ReplayModel extends ReplayEntity {
  const ReplayModel({
    String? creatorUid,
    String? replayId,
    String? commentId,
    String? postId,
    String? description,
    String? username,
    String? userProfileUrl,
    List<String>? likes,
    Timestamp? createAt,
  }) : super(
          creatorUid: creatorUid,
          replayId: replayId,
          commentId: commentId,
          postId: postId,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          likes: likes,
          createAt: createAt,
        );

  factory ReplayModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplayModel(
      creatorUid: snapshot['creatorUid'],
      replayId: snapshot['replayId'],
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      likes: List.from(snap.get("likes")),
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "creatorUid": creatorUid,
        "replayId": replayId,
        "commentId": commentId,
        "postId": postId,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "createAt": createAt,
      };
}
