import './category_type_enum.dart';

class CreateCategoryDTO {
  final String name;
  final CategoryTypeEnum typeEnum;

  CreateCategoryDTO({
    required this.name,
    required this.typeEnum,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'TypeEnum': typeEnum.index,
    };
  }
}