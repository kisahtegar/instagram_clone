import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class UpdateReplayUseCase {
  final FirebaseRepository repository;

  const UpdateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.updateReplay(replay);
  }
}
