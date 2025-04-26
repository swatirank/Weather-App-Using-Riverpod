import 'package:riverpod_app/api/post_model.dart';

class PostState {
  final bool isLoading;
  final List<Post> posts;
  final String? error;

  PostState({this.isLoading = false, this.posts = const [], this.error});

  PostState copyWith({
    bool? isLoading,
    List<Post>? posts,
    String? error,
  }) {
    return PostState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
    );
  }
}
