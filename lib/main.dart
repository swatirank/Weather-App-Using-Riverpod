import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_app/futureprovider/weatherapp.dart';
import 'package:riverpod_app/statenotifierprovider/todolist.dart';

final helloWorldProvider = Provider<String>((ref) {
  return 'Hello world';
});

void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ToDoList(),
          backgroundColor: const Color.fromARGB(255, 244, 111, 111),
        ),
      ),
    ),
  ); // providerscope is a must have widget for riverpod without this no widget can read or watch a provider
}

class MyApp extends ConsumerWidget {
  // consumerwidget allows to watch providers
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(
      helloWorldProvider,
    ); // listen for the changes to helloWorldProvider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SimpleApp'),
          backgroundColor: Colors.blue,
        ),
        body: Center(child: Text(value)),
      ),
    );
  }
}
