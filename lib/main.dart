import 'package:flutter/material.dart';
import 'package:instagram_clone/features/presentation/pages/main_screen/main_screen.dart';

import 'features/presentation/pages/credential/sign_in_page.dart';

void main() {
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
      home: const MainScreen(),
    );
  }
}
