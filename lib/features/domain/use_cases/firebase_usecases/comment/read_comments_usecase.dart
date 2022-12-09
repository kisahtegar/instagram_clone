import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadCommentsUseCase {
  final FirebaseRepository repository;

  const ReadCommentsUseCase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComments(postId);
  }
}
