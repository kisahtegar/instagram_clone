import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class LikePostUseCase {
  final FirebaseRepository firebaseRepository;

  const LikePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.likePost(post);
  }
}
