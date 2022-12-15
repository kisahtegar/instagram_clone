import '../../../entities/posts/post_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadSinglePostUseCase {
  final FirebaseRepository repository;

  const ReadSinglePostUseCase({required this.repository});

  Stream<List<PostEntity>> call(String postId) {
    return repository.readSinglePost(postId);
  }
}
