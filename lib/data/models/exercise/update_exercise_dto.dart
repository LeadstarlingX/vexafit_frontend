class UpdateExerciseDTO {
  final int id;
  final String name;
  final String description;
  final int? imageId;
  final int? videoId;

  UpdateExerciseDTO({
    required this.id,
    required this.name,
    required this.description,
    this.imageId,
    this.videoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Description': description,
      'ImageId': imageId,
      'VideoId': videoId,
    };
  }
}