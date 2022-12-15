import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/post/read_single_post_usecase.dart';

part 'get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final ReadSinglePostUseCase readSinglePostUseCase;

  GetSinglePostCubit({required this.readSinglePostUseCase})
      : super(GetSinglePostInitial());

  Future<void> getSinglePost({required String postId}) async {
    debugPrint("GetSinglePostCubit[getSinglePost]: GetSinglePostLoading!");
    emit(GetSinglePostLoading());
    try {
      final streamResponse = readSinglePostUseCase.call(postId);
      streamResponse.listen((posts) {
        debugPrint("GetSinglePostCubit[getSinglePost]: GetSinglePostLoaded!");
        emit(GetSinglePostLoaded(post: posts.first));
      });
    } on SocketException catch (_) {
      emit(GetSinglePostFailure());
    } catch (_) {
      emit(GetSinglePostFailure());
    }
  }
}
