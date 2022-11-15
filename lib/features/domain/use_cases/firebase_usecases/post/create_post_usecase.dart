import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class CreatePostUseCase {
  final FirebaseRepository firebaseRepository;

  const CreatePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.createPost(post);
  }
}
