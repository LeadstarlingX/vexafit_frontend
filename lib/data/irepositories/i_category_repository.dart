// lib/data/irepositories/i_category_repository.dart
import '../models/category/category_dto.dart';
import '../models/category/category_type_enum.dart';

abstract class ICategoryRepository {
  Future<List<CategoryDTO>> getAllCategories({
    String? name,
    CategoryTypeEnum? type,
  });

  Future<CategoryDTO> getById(int id);
  Future<void> create({
    required String name,
    required CategoryTypeEnum type,
  });
  Future<void> update({
    required int id,
    required String name,
    required CategoryTypeEnum type,
  });
  Future<void> delete(int id);
}