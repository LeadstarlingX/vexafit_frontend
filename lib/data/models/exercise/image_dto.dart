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
      // Corrected to PascalCase for the response
      id: json['Id'] ?? 0,
      alternativeText: json['AlternativeText'],
      imageFile: json['ImageFile'],
    );
  }

  Map<String, dynamic> toJson() {
    // camelCase for requests remains the same
    return {
      'id': id,
      'alternativeText': alternativeText,
      'imageFile': imageFile,
    };
  }
}
