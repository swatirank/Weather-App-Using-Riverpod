import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_app/futureprovider/weatherapp.dart';

void main() {
  runApp(ProviderScope(child: WeatherTracker()));
}

final weatherTracker = StreamProvider.family((ref, city) {
  return weatherStream(city as String);
});

Stream<Map<String, dynamic>> weatherStream(String city) async* {
  while (true) {
    final response = await http.get(
      Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=f43ab0bdad83408cadc120146253103&q=$city',
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      yield data;
    } else {
      yield {'error': 'Failed to load data'};
    }
    await Future.delayed(Duration(seconds: 1));
  }
}

class WeatherTracker extends ConsumerStatefulWidget {
  const WeatherTracker({super.key});

  @override
  ConsumerState<WeatherTracker> createState() => _WeatherTrackerState();
}

class _WeatherTrackerState extends ConsumerState<WeatherTracker> {
  String city = 'Wellington';
  @override
  Widget build(BuildContext context) {
    final cityP = ref.watch(weatherTracker(city));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Weather Tracker')),
        body: Center(
          child: cityP.when(
            data: (priceData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Location: ${priceData['location']['name']}'),
                  Text('Wind Speed: ${priceData['current']['wind_mph']}'),
                ],
              );
            },
            error: (err, stack) => Text('$err'),
            loading: () => CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
