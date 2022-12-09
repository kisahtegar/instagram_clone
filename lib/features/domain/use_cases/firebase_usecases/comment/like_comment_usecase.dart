import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repository.dart';

class LikeCommentUseCase {
  final FirebaseRepository repository;

  const LikeCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.likeComment(comment);
  }
}
