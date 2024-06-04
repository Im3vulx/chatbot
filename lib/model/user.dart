class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String firtsName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.firtsName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      firtsName: json['firtsName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'firtsName': firtsName,
      'lastName': lastName,
    };
  }
}