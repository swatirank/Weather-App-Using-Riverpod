import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modeProvider = StateProvider<bool>((ref) => false);

void main() {
  runApp(ProviderScope(child: ModeChange()));
}

class ModeChange extends ConsumerWidget {
  const ModeChange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider);
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mode ? dark : light,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: mode,
                onChanged: (value) {
                  ref.watch(modeProvider.notifier).state = value;
                },
              ),
              Text(mode ? 'Dark Mode' : 'Light Mode'),
            ],
          ),
        ),
      ),
    );
  }
}
