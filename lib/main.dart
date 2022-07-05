import 'package:flutter/material.dart';
import 'package:flutter_test_ssl_pinning/pages/home_page.dart';
import 'package:flutter_test_ssl_pinning/pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

final PinningSslData data = PinningSslData();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
