class VideoDTO {
  final int id;
  final String? description;
  final String? videoFile; // This will be base64 or file path

  VideoDTO({
    required this.id,
    this.description,
    this.videoFile,
  });

  factory VideoDTO.fromJson(Map<String, dynamic> json) {
    return VideoDTO(
      id: json['id'] ?? 0,
      description: json['description'],
      videoFile: json['videoFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'videoFile': videoFile,
    };
  }
}