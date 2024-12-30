import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class ChatbotManage extends StatefulWidget {
  const ChatbotManage({super.key});

  @override
  State<ChatbotManage> createState() => _ChatbotManageState();
}

class _ChatbotManageState extends State<ChatbotManage> {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  List<Map<String, dynamic>> users = [];

  // Firebase Functions 호출하여 사용자 목록을 가져오는 함수
  Future<void> _fetchUsers() async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('listUsers');
      final response = await callable.call();

      if (response.data['success']) {
        setState(() {
          users = List<Map<String, dynamic>>.from(response.data['users']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.data['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch users: $e')));
    }
  }

  // 사용자 삭제 함수
  Future<void> _deleteUser(String uid) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('deleteUser');
      final response = await callable.call({'uid': uid});

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully.')));
        _fetchUsers(); // 사용자 삭제 후 다시 목록을 가져옵니다.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.data['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
    }
  }

  // 이메일 수정 함수
  Future<void> _updateEmail(String uid, String newEmail) async {
    try {
      print('Updating email for UID: $uid with new email: $newEmail'); // 디버깅을 위한 출력
      final HttpsCallable callable = _functions.httpsCallable('updateEmail');
      final response = await callable.call({
        'uid': uid,
        'newEmail': newEmail,
      });

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email updated successfully.')));
        _fetchUsers(); // 이메일 수정 후 다시 목록을 가져옵니다.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.data['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update email: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // 페이지가 로드되면 사용자 목록을 가져옵니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return ListTile(
                  title: Text(user['displayName'] ?? 'No Display Name'),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.email),
                        onPressed: () {
                          // 이메일 수정 다이얼로그
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController emailController = TextEditingController();
                              return AlertDialog(
                                title: Text("Update Email"),
                                content: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(hintText: "Enter new email"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      String newEmail = emailController.text.trim();
                                      if (newEmail.isNotEmpty) {
                                        String uid = user['uid'];
                                        print("Attempting to update email for UID: $uid with new email: $newEmail");
                                        _updateEmail(uid, newEmail);
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid email')));
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUser(user['uid']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
