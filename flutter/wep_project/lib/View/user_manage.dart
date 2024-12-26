import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep_project/model/user.dart';

class UserManage extends StatefulWidget {
  const UserManage({super.key});

  @override
  State<UserManage> createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  late TextEditingController searchController;
  late Stream<QuerySnapshot> firebaseState;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    firebaseState = FirebaseFirestore.instance.collection('User').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 500,
                height: 30,
                child: SearchBar(
                  controller: searchController,
                  hintText: '이름을 입력하세요',
                  shadowColor: WidgetStatePropertyAll(Colors.black),
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStateProperty.all(ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(20))),
                  onChanged: (value) {
                    if (value.isEmpty) {
                        // 검색어가 비어있으면 전체 데이터 스트림으로 돌아감
                        firebaseState = FirebaseFirestore.instance.collection('User').snapshots();
                      } else {
                        // 검색어에 맞는 데이터 스트림
                        firebaseState = FirebaseFirestore.instance
                            .collection('User')
                            .where('name', isEqualTo: value)
                            .snapshots();
                      }
                      setState(() {});
                  },
                ),
              ),
            ),
            Container(
              width: 1650,
              height: 50,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
              width: 100,
              child: Text(
                '닉네임',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                '이름',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                '회원 유형',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                '가입일',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                child: SizedBox(
                width: 100,
                child: Text(
                  '최근 접속일',
                  style: TextStyle(
                    fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                  )
                ),
              ),
                ],
              )
              ),
            Container(
              width: 1650,
              height: 500,
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                  // firebase에 있는 데이터중 User collection의 문서 전체 출력
                  stream: firebaseState,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final documents = snapshot.data!.docs;
                    return ListView(
                      // map형식으로 되어있는 데이터를 list로 변환
                      children: documents.map((e) => buildItemWidgets(e)).toList(),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemWidgets(DocumentSnapshot doc){
    final user = User(
      id: doc['id'], 
      password: doc['password'], 
      name: doc['name'], 
      nickname: doc['nickname'], 
      addDate: doc['addDate'],
      userState: doc['userState'],
      recentDate: doc['recentDate']);
      return Card(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                user.nickname,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.userState,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.addDate,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.recentDate,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              // 수정 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SizedBox(
                  width: 80,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff414141),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 테두리 둥글기
                ),
                    ),
                    child: const Text('수정')
                    ),
                ),
              ),
              // 삭제 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SizedBox(
                  width: 80,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      buttonDialog(doc.id);
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF7373),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 테두리 둥글기
                ),
                    ),
                    child: const Text('탈퇴')
                    ),
                ),
              ),
          ],
        ),
      );
  }
  buttonDialog(id){
    Get.defaultDialog(
      title: '회원 탈퇴',
      middleText: '정말로 회원을 탈퇴시키겠습니까?',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
                TextButton(
          onPressed: () => FirebaseFirestore.instance.collection('User').doc(id).delete(), 
          child: const Text('네')
          ),
        TextButton(
          onPressed: () => Get.back(), 
          child: const Text('아니요')
          )
      ]
    );
  }
}