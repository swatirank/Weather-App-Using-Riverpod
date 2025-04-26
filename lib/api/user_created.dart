import 'package:flutter/material.dart';

class UserCreated extends StatelessWidget {
  const UserCreated({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('User Created ')),
        body: Center(child: Text('User Created: $name')),
      ),
    );
  }
}
