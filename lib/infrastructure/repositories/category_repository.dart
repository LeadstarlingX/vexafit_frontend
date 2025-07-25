// // lib/infrastructure/repositories/category_repository.dart
// import 'package:dio/dio.dart';
//
// import '../../core/constants/api_routes.dart';
// import '../../core/dio/dio_client.dart';
// import '../../data/irepositories/i_category_repository.dart';
// import '../../data/models/api_response.dart';
// import '../../data/models/category/category_dto.dart';
// import '../../data/models/category/category_type_enum.dart';
//
// class CategoryRepository implements ICategoryRepository {
//   final DioClient _dioClient;
//
//   CategoryRepository({required DioClient dioClient}) : _dioClient = dioClient;
//
//   @override
//   Future<List<CategoryDTO>> getAllCategories({
//     String? name,
//     CategoryTypeEnum? type,
//   }) async {
//     try {
//       final response = await _dioClient.dio.get(
//         ApiRoutes.categoryGetAll,
//         queryParameters: {
//           if (name != null) 'Name': name,
//           if (type != null) 'Type': type.index,
//         },
//       );
//
//       final apiResponse = ApiResponse.fromJson(response.data);
//       return (apiResponse.data as List)
//           .map((json) => CategoryDTO.fromJson(json))
//           .toList();
//     } on DioException catch (e) {
//       throw _handleCategoryError(e);
//     }
//   }
//
//   @override
//   Future<CategoryDTO> getById(int id) async {
//     try {
//       final response = await _dioClient.dio.get(
//         ApiRoutes.categoryGetById,
//         queryParameters: {'Id': id},
//       );
//
//       final apiResponse = ApiResponse.fromJson(response.data);
//       return CategoryDTO.fromJson(apiResponse.data);
//     } on DioException catch (e) {
//       throw _handleCategoryError(e);
//     }
//   }
//
//   @override
//   Future<void> create({
//     required String name,
//     required CategoryTypeEnum type,
//   }) async {
//     try {
//       final response = await _dioClient.dio.post(
//         ApiRoutes.categoryInsert,
//         queryParameters: {
//           'Name': name,
//           'TypeEnum': type.index,
//         },
//       );
//
//       final apiResponse = ApiResponse.fromJson(response.data);
//       if (!apiResponse.result) {
//         throw Exception(apiResponse.message ?? 'Failed to create category');
//       }
//     } on DioException catch (e) {
//       throw _handleCategoryError(e);
//     }
//   }
//
//   @override
//   Future<void> update({
//     required int id,
//     required String name,
//     required CategoryTypeEnum type,
//   }) async {
//     try {
//       final response = await _dioClient.dio.put(
//         ApiRoutes.categoryUpdate,
//         queryParameters: {
//           'Id': id,
//           'Name': name,
//           'Type': type.index,
//         },
//       );
//
//       final apiResponse = ApiResponse.fromJson(response.data);
//       if (!apiResponse.result) {
//         throw Exception(apiResponse.message ?? 'Failed to update category');
//       }
//     } on DioException catch (e) {
//       throw _handleCategoryError(e);
//     }
//   }
//
//   @override
//   Future<void> delete(int id) async {
//     try {
//       final response = await _dioClient.dio.delete(
//         ApiRoutes.categoryDelete,
//         queryParameters: {'Id': id},
//       );
//
//       final apiResponse = ApiResponse.fromJson(response.data);
//       if (!apiResponse.result) {
//         throw Exception(apiResponse.message ?? 'Failed to delete category');
//       }
//     } on DioException catch (e) {
//       throw _handleCategoryError(e);
//     }
//   }
//
//   Exception _handleCategoryError(DioException e) {
//     try {
//       final apiResponse = ApiResponse.fromJson(e.response?.data ?? {});
//       return Exception(apiResponse.message ?? 'Category operation failed');
//     } catch (_) {
//       return Exception('Network error occurred. Please try again.');
//     }
//   }
// }