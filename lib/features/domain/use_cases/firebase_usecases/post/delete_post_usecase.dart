import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class DeletePostUseCase {
  final FirebaseRepository firebaseRepository;

  const DeletePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.deletePost(post);
  }
}
