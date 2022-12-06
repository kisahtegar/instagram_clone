import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class LikePostUseCase {
  final FirebaseRepository repository;

  const LikePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.likePost(post);
  }
}
