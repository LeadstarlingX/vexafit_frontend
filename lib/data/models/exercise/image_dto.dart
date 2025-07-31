class ImageDTO {
  final int id;
  final String? alternativeText;
  final String? imageFile;

  ImageDTO({
    required this.id,
    this.alternativeText,
    this.imageFile,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) {
    return ImageDTO(
      id: json['Id'] ?? 0,
      alternativeText: json['AlternativeText'],
      imageFile: json['Url'],
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
