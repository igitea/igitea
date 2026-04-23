import 'package:flutter/material.dart';

/// Root application widget for iGitea.
class IGiteaApp extends StatelessWidget {
  const IGiteaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGitea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('iGitea')),
      ),
    );
  }
}
