import './category_type_enum.dart';

class UpdateCategoryDTO {
  final int id;
  final String name;
  final CategoryTypeEnum type;

  UpdateCategoryDTO({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Type': type.index,
    };
  }
}