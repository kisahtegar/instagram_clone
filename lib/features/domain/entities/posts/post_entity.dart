import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final String? userProfileUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;

  const PostEntity({
    required this.postId,
    required this.creatorUid,
    required this.username,
    required this.description,
    required this.postImageUrl,
    required this.userProfileUrl,
    required this.likes,
    required this.totalLikes,
    required this.totalComments,
    required this.createAt,
  });

  @override
  List<Object?> get props => [
        postId,
        creatorUid,
        username,
        description,
        postImageUrl,
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
