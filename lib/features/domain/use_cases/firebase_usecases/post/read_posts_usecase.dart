import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadPostsUseCase {
  final FirebaseRepository firebaseRepository;

  const ReadPostsUseCase({required this.firebaseRepository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return firebaseRepository.readPosts(post);
  }
}
