import 'package:flutter/material.dart';

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
      home: const SignInPage(),
    );
  }
}
