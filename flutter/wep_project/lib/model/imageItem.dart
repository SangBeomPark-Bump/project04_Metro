class ImageItem {
  final int id;
  final String cpName;
  final String imageData;

  ImageItem({required this.id, required this.cpName, required this.imageData});

  // JSON 응답에서 ImageItem 객체로 변환하는 생성자
  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'],
      cpName: json['cp_name'],
      imageData: json['data'],  // base64 인코딩된 데이터
    );
  }
}