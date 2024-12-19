import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wep_project/View/M_Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController idController;
  late TextEditingController passwordController;
  late List loginCheck;
  final _formKey = GlobalKey<FormState>();
  final RegExp idRegExp = RegExp(r'^[a-zA-Z0-9]{4,}$'); // ID: 영문자+숫자, 5자 이상
  final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'); // Password: 영문+숫자, 8자 이상

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
    loginCheck = [];
    getJSONLoginData();
  }
    getJSONLoginData() async {
    var url = Uri.parse('http://127.0.0.1:8000/Login/Login_Check');
    var response = await http.get(url);
    loginCheck.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    loginCheck.addAll(result);
    // mounted 값이 true일 때만 setState 호출
  if (mounted) {
    setState(() {});
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '관리자 페이지 로그인(임시)',
                style: TextStyle(
                  fontSize: 30
                ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(500, 40, 500, 20),
                  child: TextFormField(
                    controller: idController,
                    maxLength: 15,
                    decoration: InputDecoration(
                      hintText: 'id를 입력하세요',
                      labelText: 'ID',
                      border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                    return "ID칸을 입력해주세요요";
                  } else if (!idRegExp.hasMatch(value)) {
                    return "아이디는 5자 이상이어야 합니다. (문자, 숫자만 가능)";
                  }
                  return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(500, 20, 500, 40),
                  child: TextFormField(
                    controller: passwordController,
                    maxLength: 15,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'password를 입력하세요',
                      labelText: 'PW',
                      
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                    return "패스워드를 입력해주세요";
                  } else if (!passwordRegExp.hasMatch(value)) {
                    return "비밀번호는 영문, 숫자를 포함하여 8자 이상이어야 합니다.";
                  }
                  return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      print(loginCheck[0]);
                      
                      
if (_formKey.currentState!.validate()) {
  }checkLG(idController.text.trim(), passwordController.text.trim());
                      //
                    }, 
                    
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login')
                    ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Function
  checkLG(id, pw){
    if(id == loginCheck[0][0] && pw == loginCheck[0][1]){
      Get.to(const MHome());
    }
  }
} // End