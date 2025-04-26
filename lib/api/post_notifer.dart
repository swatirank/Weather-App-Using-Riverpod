import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/api_service.dart';
import 'package:riverpod_app/api/post_model.dart';
import 'package:riverpod_app/api/post_state.dart';

class PostNotifer extends StateNotifier<PostState> {
  final ApiService apiService;

  PostNotifer(this.apiService) : super(PostState());

  Future<void> getPosts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final posts = await apiService.fetchPost();
      state = state.copyWith(isLoading: false, posts: posts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
