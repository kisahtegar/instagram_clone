part of 'replay_cubit.dart';

abstract class ReplayState extends Equatable {
  const ReplayState();

  @override
  List<Object> get props => [];
}

class ReplayInitial extends ReplayState {}

class ReplayLoading extends ReplayState {}

class ReplayLoaded extends ReplayState {
  final List<ReplayEntity> replays;

  const ReplayLoaded({required this.replays});

  @override
  List<Object> get props => [replays];
}

class ReplayFailure extends ReplayState {}
