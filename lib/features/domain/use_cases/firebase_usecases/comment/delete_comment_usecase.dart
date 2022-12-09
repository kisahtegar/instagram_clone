import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repository.dart';

class DeleteCommentUseCase {
  final FirebaseRepository repository;

  const DeleteCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.deleteComment(comment);
  }
}
