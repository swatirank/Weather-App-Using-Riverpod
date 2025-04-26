import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/api/api_service.dart';
import 'package:riverpod_app/api/providers.dart';

class DeleteUser extends ConsumerStatefulWidget {
  const DeleteUser({super.key});

  @override
  ConsumerState<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends ConsumerState<DeleteUser> {
  final idController = TextEditingController();
  bool isLoading = false;

  void delelteUser() async {
    final id = int.tryParse(idController.text);
    if (id == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final api = ref.read(apiServiceProvider);
    try {
      final success = await api.deleteUser(id);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User deleted successfully')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting user')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting user')));
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
        appBar: AppBar(title: Text('Delete User')),
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  content: Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 300,
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            Expanded(
                                              child: Text(
                                                'Are you sure you want to delete this user?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    delelteUser();
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Icon(Icons.close, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            // delelteUser();
                          },
                          child: Text('Delete User'),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
