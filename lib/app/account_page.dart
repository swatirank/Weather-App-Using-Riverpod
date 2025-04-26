import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/app/userauthentication.dart';

void main() {
  runApp(ProviderScope(child: AccountPage()));
}

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    final email = auth.email ?? ' ';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Account Page',
            style: TextStyle(color: const Color.fromARGB(255, 252, 198, 216)),
          ),
          backgroundColor: const Color.fromARGB(255, 163, 116, 132),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: const Color.fromARGB(255, 252, 198, 216),
              iconSize: 25,
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (BuildContext context) => AlertDialog(
                        backgroundColor: const Color.fromARGB(
                          255,
                          252,
                          219,
                          230,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Color.fromARGB(255, 109, 72, 84),
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 121, 80, 94),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(authenticationProvider.notifier)
                                  .logout();
                              ref
                                  .read(selectedImagePathProvider.notifier)
                                  .state = null;
                              ref.read(imageBytesProvider.notifier).state =
                                  null;
                              Navigator.of(context).pushAndRemoveUntil(
                                // remove all the previous routes in the navigation stack until a condition is met
                                MaterialPageRoute(
                                  builder: (_) => UserAuthenticationApp(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: Color.fromARGB(255, 97, 64, 75),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: Color.fromARGB(255, 97, 64, 75),
                              ),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth =
                constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.85;
            return Center(
              child: SizedBox(
                width: cardWidth,
                height: 600,
                child: Card(
                  color: const Color.fromARGB(255, 252, 234, 240),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        // if (auth.imagePath != null)
                        //   CircleAvatar(
                        //     radius: 80,
                        //     backgroundImage: FileImage(File(auth.imagePath!)),
                        //     backgroundColor: const Color.fromARGB(
                        //       255,
                        //       252,
                        //       219,
                        //       230,
                        //     ),
                        //     child: Icon(
                        //       Icons.person,
                        //       size: 100,
                        //       color: Color.fromARGB(255, 163, 113, 129),
                        //     ),
                        //   ),
                        auth.imageBytes != null
                            ? CircleAvatar(
                              radius: 80,
                              backgroundColor: const Color.fromARGB(
                                255,
                                252,
                                219,
                                230,
                              ),
                              backgroundImage: MemoryImage(auth.imageBytes!),
                            )
                            : const CircleAvatar(
                              radius: 80,
                              backgroundColor: Color.fromARGB(
                                255,
                                252,
                                219,
                                230,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Color.fromARGB(255, 163, 113, 129),
                              ),
                            ),
                        SizedBox(height: 50),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 60,
                            color: Color.fromARGB(255, 165, 90, 114),
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          '$email',
                          style: TextStyle(
                            color: Color.fromARGB(255, 163, 113, 129),
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
