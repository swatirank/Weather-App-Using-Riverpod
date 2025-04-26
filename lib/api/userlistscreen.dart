import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/providers.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('API Get Request')),
        body: userAsyncValue.when(
          data: (user) {
            return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                final users = user[index];
                return ListTile(
                  title: Text(users.name),
                  subtitle: Text(users.email),
                );
              },
            );
          },
          error: (err, stackTrace) => Center(child: Text('Error: $err')),
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
