import './image_dto.dart';
import './video_dto.dart';

class CreateExerciseDTO {
  final String name;
  final String description;
  final int categoryId;
  final List<ImageDTO>? imageFiles;
  final List<VideoDTO>? videoFiles;

  CreateExerciseDTO({
    required this.name,
    required this.description,
    required this.categoryId,
    this.imageFiles,
    this.videoFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Description': description,
      'CategoryId': categoryId,
      'ImageFiles': imageFiles?.map((e) => e.toJson()).toList(),
      'VideoFiles': videoFiles?.map((e) => e.toJson()).toList(),
    };
  }
}
