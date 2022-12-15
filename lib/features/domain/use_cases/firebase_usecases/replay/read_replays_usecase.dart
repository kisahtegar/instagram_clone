import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadReplayUseCase {
  final FirebaseRepository repository;

  const ReadReplayUseCase({required this.repository});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return repository.readReplays(replay);
  }
}
