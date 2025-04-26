import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/api_service.dart';
import 'package:riverpod_app/api/post_notifer.dart';
import 'package:riverpod_app/api/post_state.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final userProvider = FutureProvider((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchUsers();
});

// fetching api data using future provider

final postProvider = FutureProvider((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchPost();
});

final postApiProvider = StateNotifierProvider<PostNotifer, PostState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PostNotifer(apiService);
});
