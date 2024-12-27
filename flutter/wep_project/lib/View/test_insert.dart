import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../model/imageItem.dart';

class TestInsert extends StatefulWidget {
  const TestInsert({super.key});

  @override
  State<TestInsert> createState() => _TestInsertState();
}

class _TestInsertState extends State<TestInsert> {
  Uint8List? _selectedImage;
  String? _uploadedImageUrl;
  String cpName = "";  // 업체명을 저장할 변수
  bool _isUploading = false;
  double _uploadProgress = 0.0;


  
  // 이미지 선택 및 업로드 함수
  Future<void> pickAndUploadImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // 이미지만 선택
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) async {
          final data = reader.result as Uint8List;

          setState(() {
            _selectedImage = data;
            _isUploading = true;
            _uploadProgress = 0.0;
          });

          final imageUrl = await uploadImage(data, file.name);

          setState(() {
            _uploadedImageUrl = imageUrl;
            _isUploading = false;
          });

          if (imageUrl == null) {
            print(imageUrl);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image upload failed')),
            );
          }
        });

        reader.onProgress.listen((html.ProgressEvent e) {
          setState(() {
            _uploadProgress = (e.loaded! / e.total!);
          });
        });
      }
    });
  }

  // 이미지를 서버로 업로드하는 함수
  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    final url = Uri.parse('http://127.0.0.1:8000/Image/upload');
    
    // 업로드 요청에 cp_name 추가
    final request = http.MultipartRequest('POST', url)
      ..fields['cp_name'] = cpName  // 업체명 추가
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageData,
        filename: fileName,
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Image uploaded successfully');
        return parseImageUrl(responseBody);
      } else {
        print('Image upload failed: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // 서버 응답에서 이미지 URL을 파싱
  String? parseImageUrl(String responseBody) {
    final Map<String, dynamic> json = jsonDecode(responseBody);
    print(json['url']);
    return json['url'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Upload")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 업체명 입력받는 TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Enter Company Name", // 업체명 라벨
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    cpName = value;  // 업체명 입력값 실시간 반영
                  });
                },
              ),
            ),
            
            // 업로드 중일 때 원형 로딩 표시
            if (_isUploading)
              Column(
                children: [
                  CircularProgressIndicator(value: _uploadProgress),
                  SizedBox(height: 10),
                  Text('${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                ],
              ),
            
            // 이미지가 선택되었을 때 미리보기
            if (!_isUploading && _selectedImage != null)
              Image.memory(_selectedImage!, height: 200, fit: BoxFit.cover),
            
            SizedBox(height: 20),
            // 이미지 업로드 버튼
            ElevatedButton(
              onPressed: _isUploading || cpName.isEmpty ? null : pickAndUploadImage, // cpName이 비어 있으면 업로드 비활성화
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
