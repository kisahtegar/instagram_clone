import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/pages/profile/widgets/profile_main_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../cubit/post/post_cubit.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    debugPrint("ProfilePage[build]: Building!!");
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: ProfileMainWidget(currentUser: currentUser),
    );
  }
}
