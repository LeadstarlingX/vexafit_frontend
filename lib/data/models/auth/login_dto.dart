class LoginDTO {
  final String email;
  final String password;
  final bool rememberMe;

  LoginDTO({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'rememberMe': rememberMe,
  };
}
