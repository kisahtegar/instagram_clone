import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/presentation/pages/post/post_detail/widget/post_detail_main_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../cubit/post/get_single_post/get_single_post_cubit.dart';
import '../../../cubit/post/post_cubit.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: PostDetailMainWidget(postId: postId),
    );
  }
}
