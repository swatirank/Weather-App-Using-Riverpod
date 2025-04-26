import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_app/app/account_page.dart';

void main() {
  runApp(ProviderScope(child: UserAuthenticationApp()));
}

class AuthState {
  final bool isAuthenticated;
  final String? email;

  final String? imagePath;

  final Uint8List? imageBytes;

  AuthState({
    this.email,
    required this.isAuthenticated,
    this.imagePath,
    this.imageBytes,
  });

  factory AuthState.authenticated(
    String email,
    String? imagePath,
    Uint8List? imageBytes,
  ) {
    return AuthState(
      isAuthenticated: true,
      email: email,
      imagePath: imagePath,
      imageBytes: imageBytes,
    );
  }

  factory AuthState.unauthenticated() {
    return AuthState(isAuthenticated: false);
  }
}

class Authentication extends StateNotifier<AuthState> {
  Authentication() : super(AuthState.unauthenticated());

  void login(email, imagePath, imageBytes) {
    state = AuthState.authenticated(email, imagePath, imageBytes);
  }

  void logout() {
    state = AuthState.unauthenticated();
  }
}

final authenticationProvider = StateNotifierProvider<Authentication, AuthState>(
  (ref) => Authentication(),
);
final selectedImagePathProvider = StateProvider<String?>((ref) => null);
final imageBytesProvider = StateProvider<Uint8List?>((ref) => null);

class UserAuthenticationApp extends ConsumerWidget {
  UserAuthenticationApp({super.key});
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwdcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp pwdRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&*!]).{6,}$',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'User Aunthentication',
            style: TextStyle(color: const Color.fromARGB(255, 252, 198, 216)),
          ),
          backgroundColor: const Color.fromARGB(255, 163, 116, 132),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth =
                constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.85;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: 700,
                      child: Card(
                        color: const Color.fromARGB(255, 252, 234, 240),
                        child:
                            auth.isAuthenticated
                                ? AccountPage()
                                : _buildLoginForm(context, ref),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(selectedImagePathProvider);
    final imageBytes = ref.watch(imageBytesProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 163, 113, 129),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                final bytes = await image.readAsBytes(); // Read bytes
                ref.read(selectedImagePathProvider.notifier).state = image.path;
                ref.read(imageBytesProvider.notifier).state =
                    bytes; // Save bytes to provider
              }
            },
            child:
                imagePath != null
                    ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.memory(
                          imageBytes!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.pink,
                              child: Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    : CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromARGB(255, 163, 113, 129),
                      backgroundImage:
                          imagePath != null ? FileImage(File(imagePath)) : null,
                      child:
                          imagePath == null
                              ? Icon(Icons.image, size: 40, color: Colors.white)
                              : null,
                    ),
          ),

          SizedBox(height: 50),
          Row(children: [SizedBox(width: 20), Text('Email')]),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email (e.g., example@domain.com)';
                }
                return null;
              },
              // key: _formKey,
              controller: _emailcontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(children: [SizedBox(width: 20), Text('Password')]),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length <= 6) {
                  return 'Password must be more than 6 characters';
                } else if (!pwdRegex.hasMatch(value)) {
                  return 'Password must have at least:\n'
                      '- One uppercase letter\n'
                      '- One lowercase letter\n'
                      '- One number\n'
                      '- One special character\n'
                      '- At least 6 characters';
                }
                return null;
              },
              // key: _formKey,
              controller: _pwdcontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(120, 60)),
              backgroundColor: WidgetStatePropertyAll(
                const Color.fromARGB(255, 163, 116, 132),
              ),
              foregroundColor: WidgetStatePropertyAll(
                const Color.fromARGB(255, 255, 203, 220),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String email = _emailcontroller.text.trim();
                String pwd = _pwdcontroller.text.trim();
                final imagePath = ref.read(selectedImagePathProvider);
                final imageBytes = ref.read(imageBytesProvider);

                ref
                    .read(authenticationProvider.notifier)
                    .login(email, imagePath, imageBytes);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountPage()),
                );
              }
            },
            child: Text('Login', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  // Widget _buildWelcomeScreen(
  //   BuildContext context,
  //   WidgetRef ref,
  //   String email,
  // ) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         // mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Welcome, $email!',
  //             style: TextStyle(
  //               fontSize: 30,
  //               color: Color.fromARGB(255, 163, 113, 129),
  //             ),
  //           ),
  //           SizedBox(height: 30),
  //           SizedBox(
  //             width: 150,
  //             child: ElevatedButton(
  //               style: ButtonStyle(
  //                 fixedSize: WidgetStatePropertyAll(Size(120, 60)),
  //                 backgroundColor: WidgetStatePropertyAll(
  //                   const Color.fromARGB(255, 163, 116, 132),
  //                 ),
  //                 foregroundColor: WidgetStatePropertyAll(
  //                   const Color.fromARGB(255, 255, 203, 220),
  //                 ),
  //               ),
  //               onPressed: () {
  //                 ref.read(authenticationProvider.notifier).logout();
  //               },
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Icon(Icons.logout),
  //                   SizedBox(width: 10),
  //                   Text('Logout'),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
}
