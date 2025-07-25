class ApiRoutes {
  // Base URL - you'll need to update this with your actual IP
  static const String baseUrl = 'http://10.0.2.2:5232/';

  // Auth endpoints
  static const String login = '/api/Auth/Login';
  static const String register = '/api/Auth/Register';
  static const String logout = '/api/Auth/Logout';
  static const String getAuthenticated = '/api/Auth/GetAuthenticated';

  // Category endpoints
  static const String categoryGetAll = '/api/Category/GetAll';
  static String categoryGetById(int id) => '/api/Category/GetById/$id';
  static const String categoryInsert = '/api/Category/Insert';
  static const String categoryUpdate = '/api/Category/Update';
  static const String categoryDelete = '/api/Category/Delete';

  // Exercise endpoints
  static const String exerciseGetAll = '/api/Exercise/GetAll';
  static const String exerciseGetById = '/api/Exercise/GetById';
  static const String exerciseInsert = '/api/Exercise/Insert';
  static const String exerciseUpdate = '/api/Exercise/Update';
  static const String exerciseDelete = '/api/Exercise/Delete';

  // Workout endpoints
  static const String workoutGetAll = '/api/Workout/GetAll';
  static String workoutGetById(int id) => '/api/Workout/GetById/$id';
  static const String workoutInsert = '/api/Workout/Insert';
  static String workoutUpdate(int id) => '/api/Workout/Update/$id';
  static String workoutDelete(int id) => '/api/Workout/Delete/$id';
  static const String workoutAddToWorkout = '/api/Workout/AddToWorkout';
  static const String workoutDeleteFromWorkout = '/api/Workout/DeleteFromWorkout';
}