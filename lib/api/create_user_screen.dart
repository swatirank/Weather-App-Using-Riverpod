import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/providers.dart';
import 'package:riverpod_app/api/user_created.dart';

class CreateUser extends ConsumerStatefulWidget {
  const CreateUser({super.key});

  @override
  ConsumerState<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends ConsumerState<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      // formkey is controller for the form widget,  currentState is the current state of the form, .validate()- If the user left any field empty or invalid, it will show an error and skip the rest of the code.
      setState(() {
        isLoading =
            true; // loader will appear when the user clicks on the button
      });
      final api = ref.read(apiServiceProvider);
      try {
        final success = await api.createUser(
          nameController.text,
          emailController.text,
          int.parse(
            phoneController.text,
          ), // converts the phone number from a string to int
        );
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UserCreated(name: nameController.text);
              },
            ),
          ); // navigate to the user list screen
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating user')));
      } finally {
        setState(() {
          isLoading =
              false; // loader will disappear when the user clicks on the button
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Create User using POST request')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? ' Please enter your email' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () => submitForm(),
                      child: Text('Create User'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
