import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: FavouriteApp()));
}

class FavouriteNotifier extends StateNotifier<bool> {
  FavouriteNotifier() : super(false);
  void toggleFavourite() {
    state = !state;
  }                                                                                                                                                                                                                                                                                                                                                  
}

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, bool>((ref) {
  return FavouriteNotifier();
});

class FavouriteApp extends ConsumerWidget {
  const FavouriteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourite = ref.watch(favouriteProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Favourite App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.watch(favouriteProvider.notifier).toggleFavourite();
                },
                child:
                    favourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
