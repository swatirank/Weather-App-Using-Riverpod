import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final weatherProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  city,
) async {
  final response = await http.get(
    Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=f43ab0bdad83408cadc120146253103&q=$city',
    ),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load weather app");
  }
});

class WeatherApp extends ConsumerStatefulWidget {
  const WeatherApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends ConsumerState<WeatherApp> {
  final TextEditingController controller = TextEditingController();
  String city = 'London';

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider(city));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 209, 209),
        appBar: AppBar(
          title: Text('Weather App'),
          backgroundColor: const Color.fromARGB(255, 251, 134, 134),
        ),
        body: SafeArea(
          child: Center(
            child: weather.when(
              data:
                  (data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'Enter the city name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  city =
                                      controller.text
                                          .trim(); // gets the current text from the text field and removes leading and trailing speaces from the input
                                });
                              },
                              icon: Icon(Icons.search),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 300),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("City: ${data['location']['name']}"),
                                Text(
                                  "Temperature: ${data['current']['temp_c']}\u00B0C",
                                ),
                                Text(
                                  "Condition: ${data['current']['condition']['text']}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              error:
                  (err, stack) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $err'),
                      ElevatedButton(
                        onPressed: () {
                          ref.refresh(weatherProvider(city));
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
