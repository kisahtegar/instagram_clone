import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/presentation/pages/post/comment/widget/comment_main_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../cubit/comment/comment_cubit.dart';
import '../../../cubit/post/get_single_post/get_single_post_cubit.dart';
import '../../../cubit/user/get_single_user/get_single_user_cubit.dart';

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;

  const CommentPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
