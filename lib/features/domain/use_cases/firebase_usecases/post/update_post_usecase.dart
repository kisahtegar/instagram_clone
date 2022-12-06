import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class UpdatePostUseCase {
  final FirebaseRepository repository;

  const UpdatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
