class TokenDTO {
  final String? jwtToken;
  final bool success;
  final List<String>? roles;

  TokenDTO({
    this.jwtToken,
    required this.success,
    this.roles,
  });

  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(
      jwtToken: json['JwtToken'],
      success: json['Success'] ?? false,
      roles: json['Roles'] != null ? List<String>.from(json['Roles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JwtToken': jwtToken,
      'Success': success,
      'Roles': roles,
    };
  }
}

class UserProfileDTO {
  final String? id;
  final String? userName;
  final String? email;
  final TokenDTO? token;

  UserProfileDTO({
    this.id,
    this.userName,
    this.email,
    this.token,
  });

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
      id: json['Id'],
      userName: json['UserName'],
      email: json['Email'],
      token: json['Token'] != null ? TokenDTO.fromJson(json['Token']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserName': userName,
      'Email': email,
      'Token': token?.toJson(),
    };
  }
}
