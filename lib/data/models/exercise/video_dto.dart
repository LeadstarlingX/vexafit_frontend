class VideoDTO {
  final int id;
  final String? description;
  final String? videoFile;

  VideoDTO({
    required this.id,
    this.description,
    this.videoFile,
  });

  factory VideoDTO.fromJson(Map<String, dynamic> json) {
    return VideoDTO(
      id: json['Id'] ?? 0,
      description: json['Description'],
      videoFile: json['VideoFile'],
    );
  }

  Map<String, dynamic> toJson() {
    // camelCase for requests remains the same
    return {
      'id': id,
      'description': description,
      'videoFile': videoFile,
    };
  }
}
