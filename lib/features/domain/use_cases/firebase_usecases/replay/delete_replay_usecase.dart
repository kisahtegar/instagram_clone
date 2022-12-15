import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class DeleteReplayUseCase {
  final FirebaseRepository repository;

  const DeleteReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.deleteReplay(replay);
  }
}
