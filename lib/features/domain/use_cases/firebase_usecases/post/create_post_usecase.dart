import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class CreatePostUseCase {
  final FirebaseRepository repository;

  const CreatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.createPost(post);
  }
}
