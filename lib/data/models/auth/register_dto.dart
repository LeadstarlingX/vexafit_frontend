enum RoleEnum {
  user,
  admin;

  int toInt() {
    switch (this) {
      case RoleEnum.user:
        return 0;
      case RoleEnum.admin:
        return 1;
    }
  }

  static RoleEnum fromInt(int value) {
    switch (value) {
      case 0:
        return RoleEnum.user;
      case 1:
        return RoleEnum.admin;
      default:
        throw Exception("Invalid role value: $value");
    }
  }
}

class RegisterDTO {
  final String userName;
  final String email;
  final String password;
  final String? confirmPassword;
  final RoleEnum role;

  RegisterDTO({
    required this.userName,
    required this.email,
    required this.password,
    this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role.toInt(),
    };
  }
}
