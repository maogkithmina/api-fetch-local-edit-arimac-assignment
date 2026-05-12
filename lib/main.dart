import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Fetch & Local Edit',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
