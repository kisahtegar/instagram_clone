import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class DeletePostUseCase {
  final FirebaseRepository repository;

  const DeletePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.deletePost(post);
  }
}
