import './image_dto.dart';
import './video_dto.dart';
import '../category/category_dto.dart';

class ExerciseDTO {
  final int id;
  final String? name;
  final String? description;
  final List<ImageDTO>? image;
  final List<VideoDTO>? video;
  final List<CategoryDTO>? categories;

  ExerciseDTO({
    required this.id,
    this.name,
    this.description,
    this.image,
    this.video,
    this.categories,
  });

  factory ExerciseDTO.fromJson(Map<String, dynamic> json) {
    return ExerciseDTO(
      id: json['id'] ?? 0,
      name: json['name'],
      description: json['description'],
      image: json['image'] != null
          ? (json['image'] as List).map((e) => ImageDTO.fromJson(e)).toList()
          : null,
      video: json['video'] != null
          ? (json['video'] as List).map((e) => VideoDTO.fromJson(e)).toList()
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List).map((e) => CategoryDTO.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image?.map((e) => e.toJson()).toList(),
      'video': video?.map((e) => e.toJson()).toList(),
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}