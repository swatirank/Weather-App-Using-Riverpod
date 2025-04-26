import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/api_service.dart';
import 'package:riverpod_app/api/providers.dart';

class UserDetail extends ConsumerStatefulWidget {
  const UserDetail({super.key});

  @override
  ConsumerState<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends ConsumerState<UserDetail> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoading = false;
  void getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (idController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please enter a user ID')));
        return;
      }
      final api = ref.read(apiServiceProvider);
      final users = await api.fetchUsersById(int.parse(idController.text));
      if (users.isNotEmpty) {
        final user = users.first;
        nameController.text = user.name;
        emailController.text = user.email;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('User Details')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter User ID',
                ),
              ),
              SizedBox(height: 50),
              Center(
                child:
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: getUserDetails,
                          child: Text('Get User Details'),
                        ),
              ),
              SizedBox(height: 50),
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) ...[
                Card(
                  child: ListTile(
                    title: Text('Name: ${nameController.text}'),
                    subtitle: Text('Email: ${emailController.text}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
