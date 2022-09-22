import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/presentation/pages/main_screen/main_screen.dart';
import 'on_generate_route.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      onGenerateRoute: OnGenerateRoute.route,
      initialRoute: '/',
      routes: {
        "/": (context) {
          return const MainScreen();
        },
      },
    );
  }
}
