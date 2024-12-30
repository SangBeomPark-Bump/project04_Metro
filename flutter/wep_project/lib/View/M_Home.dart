import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          children: [
            Text('test')
          ],
        ),
      ),
    );
  }
}