import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ProviderScope(child: CryptoPriceTracker()));
}

Stream<Map<String, dynamic>> cryptoPriceStream() async* {
  // static data
  // List<Map<String, dynamic>> prices = [
  //   {'crypto': 'Bitcoin', 'price': 45000},
  //   {'crypto': 'Ethereum', 'price': 3200},
  //   {'crypto': 'Litecoin', 'price': 150},
  // ];

  // for (var price in prices) {
  //   await Future.delayed(Duration(seconds: 1));
  //   yield price;
  // }

  // dynamic live data
  while (true) {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=usd',
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      yield data;
    } else {
      yield {'error': 'Failed to load data'};
    }
    await Future.delayed(Duration(seconds: 2));
  }
}

final cryptoProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return cryptoPriceStream();
});

class CryptoPriceTracker extends ConsumerWidget {
  const CryptoPriceTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoPrice = ref.watch(cryptoProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Crypto Price Tracker')),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(cryptoProvider); // Force provider to refresh
          },
          child: Center(
            child: cryptoPrice.when(
              data: (priceData) {
                if (priceData.containsKey('error')) {
                  return Text('Error: ${priceData['error']}');
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bitcoin: \$${priceData['bitcoin']['usd']}'),
                    Text('Ethereum: \$${priceData['ethereum']['usd']}'),
                    Text('Litecoin: \$${priceData['litecoin']['usd']}'),
                  ],
                );
              },
              error: (err, stack) => Text('$err'),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
