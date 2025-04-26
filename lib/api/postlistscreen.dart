import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/providers.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Post Data')),
        body: post.when(
          data: (post) {
            return ListView.builder(
              itemCount: post.length,
              itemBuilder: (context, index) {
                final posts = post[index];
                return ListTile(
                  title: Text(posts.title),
                  subtitle: Text(posts.body),
                );
              },
            );
          },
          error: (err, stackTrace) => Center(child: Text('Error: $err')),
          loading:
              () => Center(
                child: ElevatedButton(
                  onPressed: () {
                    ref.refresh(postProvider);
                  },
                  child: Text('Retry'),
                ),
              ),
        ),
      ),
    );
  }
}
