import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as MV;
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TestInsert extends StatefulWidget {
  const TestInsert({super.key});

  @override
  State<TestInsert> createState() => _TestInsertState();
}

class _TestInsertState extends State<TestInsert> {
  late List<String> dropDownname;
  String? dropDownSelete;
  Uint8List? _selectedImage;
  String? _uploadedImageUrl;
  String cpName = ""; // 업체명을 저장할 변수
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
    ..fields['cp_name'] = cpName // 업체명 추가
    ..files.add(http.MultipartFile.fromBytes(
      'image',
      imageData,
      filename: fileName,
    ));

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('Server response: $responseBody');  // 서버 응답 출력

      return parseImageUrl(responseBody); // 응답에서 이미지 URL 파싱
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
  try {
    final Map<String, dynamic> json = jsonDecode(responseBody);
    print('Parsed JSON: $json');
    return json['url'];  // 'url' 키가 응답에 포함되어 있어야 함
  } catch (e) {
    print('Error parsing response: $e');
    return null;  // 응답 파싱 실패 시 null 반환
  }
}


  @override
  void initState() {
    super.initState();

    dropDownname = ["선택"];
    dropDownSelete = "선택";
    getJSONNameData();
  }

  getJSONNameData() async {
  var url = Uri.parse('http://127.0.0.1:8000/AdAdd/Add_name');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List<dynamic> result = dataConvertedJSON['results'];

    setState(() {
      // "선택"을 기본값으로 설정하고 리스트 내부의 값만 추가
      dropDownname = ["선택", ...result.map((e) => e.toString())];

      // 현재 선택된 값이 유효하지 않으면 기본값으로 설정
      if (!dropDownname.contains(dropDownSelete)) {
        dropDownSelete = dropDownname[0];
      }
    });
  } else {
    print('Error fetching data: ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Upload")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              iconSize: 30,
              style: const TextStyle(fontSize: 20),
              dropdownColor: Colors.white,
              iconEnabledColor: const Color(0xFF585858),
              value: dropDownSelete, // 드롭다운버튼 초기값
              icon: const Icon(Icons.keyboard_arrow_down),
              items: dropDownname.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                        color: const Color(0xFF585858),
                        fontSize: ResponsiveValue(context,
                            defaultValue: 20.0,
                            conditionalValues: [
                              const Condition.smallerThan(
                                  value: 10.0, name: MOBILE),
                              const Condition.largerThan(
                                  value: 20.0, name: TABLET),
                            ]).value,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropDownSelete = value!;
                  cpName = value.replaceAll(RegExp(r'[\[\]]'), '');
                });
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: "Enter Company Name", // 업체명 라벨
            //       border: OutlineInputBorder(),
            //     ),
            //     onChanged: (value) {
            //       setState(() {
            //         cpName = value; // 업체명 입력값 실시간 반영
            //       });
            //     },
            //   ),
            // ),
            if (_isUploading)
              Column(
                children: [
                  CircularProgressIndicator(value: _uploadProgress),
                  SizedBox(height: 10),
                  Text('${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                ],
              ),
            if (!_isUploading && _selectedImage != null)
              Image.memory(_selectedImage!, height: 200, fit: BoxFit.cover),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:() {
                _isUploading || cpName.isEmpty ? null : pickAndUploadImage();
              },
              child: Text('Upload Image'),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  MV.Get.back();
                }, 
                child: const Text('완료')
                ),
            )
          ],
        ),
      ),
    );
  }
}
