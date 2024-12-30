import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep_project/View/chatbot_manage.dart';
import 'package:wep_project/View/dashboard_AD.dart';
import 'package:wep_project/View/user_manage.dart';
import 'package:wep_project/model/user.dart';

class MHome extends StatefulWidget {
  const MHome({super.key});

  @override
  State<MHome> createState() => _MHomeState();
}

class _MHomeState extends State<MHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 200,
              color: Color(0xffFFB9B9),
              Icons.manage_accounts
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: Text(
                  '관리 메뉴',
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xff353535),
                    
                  )
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const UserManage());
                      },
                      child: Container(
                        width: 200,
                        height: 280,
                        decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffAFAFAF), // 테두리 색상
                        width: 2,         // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Icon(
                                  Icons.manage_accounts,
                                  size: 100,
                                  color: Color(0xffD1D1D1),
                                  ),
                              ),
                              Text(
                                '사용자 관리',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(23, 15, 23, 0),
                                  child: Text(
                                    '사용자의 가입정보 확인, 상태 관리 등을 설정할 수 있습니다.',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff9D9D9D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const ChatbotManage());
                    },
                    child: Container(
                      width: 200,
                      height: 280,
                      decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffAFAFAF), // 테두리 색상
                      width: 2,         // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Icon(
                                  Icons.settings,
                                  size: 100,
                                  color: Color(0xffD1D1D1),
                                  ),
                              ),
                              Text(
                                'ChatBot 관리',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(23, 15, 23, 0),
                                  child: Text(
                                    'Chat Bot의 학습 모델을 관리할 수 있습니다.',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff9D9D9D),
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                )
                            ],
                          ),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 300, 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const DashboardAd());
                      },
                      child: Container(
                        width: 200,
                        height: 280,
                        decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffAFAFAF), // 테두리 색상
                        width: 2,         // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Icon(
                                  Icons.auto_graph,
                                  size: 100,
                                  color: Color(0xffD1D1D1),
                                  ),
                              ),
                              Text(
                                '대시 보드 / 광고',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(23, 15, 23, 0),
                                  child: Text(
                                    '앱의 전체 현황이나, 광고등을 설정할 수 있습니다.',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff9D9D9D),
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}