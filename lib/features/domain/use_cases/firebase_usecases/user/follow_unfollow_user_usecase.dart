import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';

import '../../../repositories/firebase_repository.dart';

class FollowUnFollowUserUseCase {
  final FirebaseRepository repository;

  FollowUnFollowUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.followUnFollowUser(userEntity);
  }
}
