class ImageDTO {
  final int id;
  final String? alternativeText;
  final String? imageFile; // This will be base64 or file path

  ImageDTO({
    required this.id,
    this.alternativeText,
    this.imageFile,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) {
    return ImageDTO(
      id: json['id'] ?? 0,
      alternativeText: json['alternativeText'],
      imageFile: json['imageFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alternativeText': alternativeText,
      'imageFile': imageFile,
    };
  }
}