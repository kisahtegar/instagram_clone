import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/credential/sign_in_page.dart';
import 'features/presentation/cubit/credential/credential_cubit.dart';
import 'features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';
import 'features/presentation/pages/main_screen/main_screen.dart';
import 'on_generate_route.dart';
import 'injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // NOTE: Calling this cubit when app started
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: '/',
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return const SignInPage();
                }
              },
            );
          },
        },
      ),
    );
  }
}
