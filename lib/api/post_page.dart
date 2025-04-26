import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/providers.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postApiProvider);
    final notifier = ref.read(postApiProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Post Page')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.error}'),
                      ElevatedButton(
                        onPressed: () => notifier.getPosts(),
                        child: Text('Retry'),
                      ),
                    ],
                  )
                  : ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => notifier.getPosts(),
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
