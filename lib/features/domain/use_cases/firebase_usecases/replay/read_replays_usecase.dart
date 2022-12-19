import '../../../entities/replay/replay_entity.dart';
import '../../../repositories/firebase_repository.dart';

class ReadReplaysUseCase {
  final FirebaseRepository repository;

  const ReadReplaysUseCase({required this.repository});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return repository.readReplays(replay);
  }
}
