import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/api_service.dart';
import 'package:riverpod_app/api/providers.dart';

class UpdateUser extends ConsumerStatefulWidget {
  const UpdateUser({super.key});

  @override
  ConsumerState<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends ConsumerState<UpdateUser> {
  final idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final api = ref.read(apiServiceProvider);
      try {
        final success = await api.updateUser(
          int.parse(idController.text),
          _nameController.text,
          _emailController.text,
        );
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('User updated successfully')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating user')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Update User')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID'),
                SizedBox(height: 10),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter user ID',
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter user ID' : null,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 50),
                Text('Name'),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                ),
                SizedBox(height: 50),
                Text('Email'),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child:
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: () {
                              updateUser();
                            },
                            child: Text('Submit'),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
