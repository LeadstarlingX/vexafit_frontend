
import 'package:vexafit_frontend/data/models/exercise/video_dto.dart';

import '../category/category_dto.dart';
import 'image_dto.dart';

class ExerciseDTO {
  final int id;
  final String name;
  final String description;
  final List<ImageDTO> images;
  final List<VideoDTO> videos;
  final List<CategoryDTO> categories;

  ExerciseDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.videos,
    required this.categories,
  });

  factory ExerciseDTO.fromJson(Map<String, dynamic> json) {
    var imageList = (json['Image'] as List<dynamic>?)
        ?.map((e) => ImageDTO.fromJson(e))
        .toList() ?? [];

    var videoList = (json['Video'] as List<dynamic>?)
        ?.map((e) => VideoDTO.fromJson(e))
        .toList() ?? [];

    var categoryList = (json['Categories'] as List<dynamic>?)
        ?.map((e) => CategoryDTO.fromJson(e))
        .toList() ?? [];

    return ExerciseDTO(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? 'Unnamed Exercise',
      description: json['Description'] ?? '',
      images: imageList,
      videos: videoList,
      categories: categoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images.map((e) => e.toJson()).toList(),
      'videos': videos.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}
