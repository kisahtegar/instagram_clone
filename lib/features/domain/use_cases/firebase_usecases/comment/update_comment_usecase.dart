import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repository.dart';

class UpdateCommentUseCase {
  final FirebaseRepository repository;

  const UpdateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.updateComment(comment);
  }
}
