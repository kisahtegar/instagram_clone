import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class UpdatePostUseCase {
  final FirebaseRepository firebaseRepository;

  const UpdatePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.updatePost(post);
  }
}
