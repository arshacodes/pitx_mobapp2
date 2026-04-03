class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'phone_number': phoneNumber,
    };
  }
}
