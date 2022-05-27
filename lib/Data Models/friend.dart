// import 'dart:convert';

class Friend {
  final String name;
  final String email;
  Friend({
    required this.name,
    required this.email,
  });

  factory Friend.fromJson(Map<String, dynamic> source) {
    return Friend(
      name: source['name'] == null ? '' : source['name'] as String,
      email: source['email'] == null ? '' : source['email'] as String,
    );
  }
}
