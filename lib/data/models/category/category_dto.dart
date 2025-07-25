import './category_type_enum.dart';

class CategoryDTO {
  final int id;
  final String? name;
  final CategoryTypeEnum type;

  CategoryDTO({
    required this.id,
    this.name,
    required this.type,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      id: json['Id'] ?? 0,
      name: json['Name'],
      type: CategoryTypeEnum.values[json['Type'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
    };
  }
}