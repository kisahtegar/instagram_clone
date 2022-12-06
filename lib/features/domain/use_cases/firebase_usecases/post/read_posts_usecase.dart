import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadPostsUseCase {
  final FirebaseRepository repository;

  const ReadPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return repository.readPosts(post);
  }
}
