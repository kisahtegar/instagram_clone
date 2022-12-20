import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'package:instagram_clone/features/data/data_sources/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:instagram_clone/features/data/repositories/firebase_repository_impl.dart';
import 'package:instagram_clone/features/domain/repositories/firebase_repository.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/user_cubit.dart';

import 'features/domain/use_cases/firebase_usecases/comment/create_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/like_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/read_comments_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/update_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/create_post_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/delete_post_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/like_post_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/read_posts_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/read_single_post_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/post/update_post_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/create_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/delete_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/like_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/read_replays_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/update_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/user/create_user_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/user/get_single_other_user_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/user/get_single_user_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/user/get_users_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/user/update_user_usecase.dart';
import 'features/presentation/cubit/comment/comment_cubit.dart';
import 'features/presentation/cubit/user/cubit/get_single_other_user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // NOTE: Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signInUserUseCase: sl.call(),
      signUpUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(
      updateUserUseCase: sl.call(),
      getUsersUseCase: sl.call(),
      followUnFollowUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(
      getSingleUserUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => GetSingleOtherUserCubit(
      getSingleOtherUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => PostCubit(
      createPostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
      likePostUseCase: sl.call(),
      readPostUseCase: sl.call(),
      updatePostUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
      () => GetSinglePostCubit(readSinglePostUseCase: sl.call()));

  // Replay Cubit Injection
  sl.registerFactory(
    () => ReplayCubit(
      createReplayUseCase: sl.call(),
      deleteReplayUseCase: sl.call(),
      likeReplayUseCase: sl.call(),
      readReplaysUseCase: sl.call(),
      updateReplayUseCase: sl.call(),
    ),
  );

  // NOTE: Use Cases
  // User
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleOtherUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FollowUnFollowUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Replay
  sl.registerLazySingleton(() => CreateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplaysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplayUseCase(repository: sl.call()));

  // NOTE: Repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(
      remoteDataSource: sl.call(),
    ),
  );

  // NOTE: Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFirestore: sl.call(),
      firebaseAuth: sl.call(),
      firebaseStorage: sl.call(),
    ),
  );

  // NOTE: Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
