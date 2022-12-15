import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class CreateReplayUseCase {
  final FirebaseRepository repository;

  const CreateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.createReplay(replay);
  }
}
