// import 'dart:convert';

class Friend {
  final String name;
  final String email;
  final String friendshipId;
  Friend({
    required this.name,
    required this.email,
    required this.friendshipId,
  });

  factory Friend.fromJson(Map<String, dynamic> source) {
    return Friend(
      name: source['name'] == null ? '' : source['name'] as String,
      email: source['email'] == null ? '' : source['email'] as String,
      friendshipId: source['id'] == null ? '' : source['id'] as String,
    );
  }

  Friend copywith(
    String? name,
    String? email,
    String? friendshipId,
  ) {
    return Friend(
      name: name ?? this.name,
      email: email ?? this.email,
      friendshipId: friendshipId ?? this.friendshipId,
    );
  }
}
