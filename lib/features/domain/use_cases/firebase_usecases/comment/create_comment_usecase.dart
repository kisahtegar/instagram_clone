import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repository.dart';

class CreateCommentUseCase {
  final FirebaseRepository repository;

  const CreateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}
