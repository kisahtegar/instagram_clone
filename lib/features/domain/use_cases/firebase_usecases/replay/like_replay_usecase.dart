import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class LikeReplayUseCase {
  final FirebaseRepository repository;

  const LikeReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.likeReplay(replay);
  }
}
