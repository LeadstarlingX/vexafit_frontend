class ApiRoutes {
  // Base URL
  static const String emulatorBaseUrl = 'http://10.0.2.2:5232';
  static const String baseUrl = 'http://192.168.1.8:5232';
  static String url = emulatorBaseUrl;

  static String images = url+'/images/';
  // Auth endpoints
  static const String login = '/api/Auth/Login';
  static const String register = '/api/Auth/Register';
  static const String logout = '/api/Auth/Logout';
  static const String getAuthenticated = '/api/Auth/GetAuthenticated';


  // Category endpoints
  static const String categoryGetAll = '/api/Category/GetAll';
  static const String categoryGetById = '/api/Category/GetById';
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
  static const String workoutGetById = '/api/Workout/GetById';
  static const String workoutInsert = '/api/Workout/Insert';
  static const String workoutUpdate = '/api/Workout/Update';
  static const String workoutDelete = '/api/Workout/Delete';
  static const String workoutAddToWorkout = '/api/Workout/AddToWorkout';
  static const String workoutUpdateExerciseInWorkout = '/api/Workout/UpdateExerciseInWorkout';
  static const String workoutDeleteFromWorkout = '/api/Workout/DeleteFromWorkout';
}
