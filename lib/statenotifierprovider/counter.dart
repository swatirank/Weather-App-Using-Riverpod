import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

void main() {
  runApp(ProviderScope(child: CounterAppn()));
}

class CounterAppn extends ConsumerWidget {
  const CounterAppn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('StateNotifier')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$counter'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.watch(counterProvider.notifier).increment();
                  },
                  child: Text('Increment'),
                ),
                SizedBox(width: 50),
                ElevatedButton(
                  onPressed: () {
                    ref.watch(counterProvider.notifier).decrement();
                  },
                  child: Text('Decrement'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
