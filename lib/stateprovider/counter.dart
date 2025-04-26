import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

void main() {
  runApp(ProviderScope(child: CounterApp()));
}

class CounterApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     ref.read(counterProvider.notifier).state++;
        //   },
        //   child: Icon(Icons.add),
        // ),
        appBar: AppBar(
          title: Text('Counter App'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Text('$count'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      onPressed:
                          () => ref.watch(counterProvider.notifier).state++,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.remove),
                      label: const Text('Minus'),
                      onPressed: () {
                        if (ref.watch(counterProvider.notifier).state == 0) {
                          return;
                        } else {
                          ref.watch(counterProvider.notifier).state--;
                        }
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Refresh'),
                onPressed: () => ref.watch(counterProvider.notifier).state = 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
