import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontProvider = StateProvider<double>((ref) {
  return 16.0;
});

void main() {
  runApp(ProviderScope(child: FontSize()));
}

class FontSize extends ConsumerWidget {
  const FontSize({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final font = ref.watch(fontProvider);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text('Font Size', style: TextStyle(fontSize: font)),
              // ElevatedButton(
              //   onPressed: () {
              //     ref.read(fontProvider.notifier).state =
              //         font == 16.0 ? 30.0 : 16.0;
              //   },
              //   child: Text('Font Size', style: TextStyle(fontSize: font)),
              // ),
              Slider(
                value: font,
                min: 16.0,
                max: 50.0,
                onChanged: (value) {
                  ref.read(fontProvider.notifier).state = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
