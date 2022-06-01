import 'dart:convert';

RepaymentAccount repaymentAccountFromJson(String str) =>
    RepaymentAccount.fromJson(json.decode(str) as Map<String, dynamic>);

String repaymentAccountToJson(RepaymentAccount data) =>
    json.encode(data.toJson());

class RepaymentAccount {
  RepaymentAccount({
    required this.id,
    required this.friend,
    required this.balance,
    required this.createdAt,
  });

  String id;
  RepaymentFriend friend;
  int balance;
  DateTime createdAt;

  factory RepaymentAccount.fromJson(Map<String, dynamic> json) =>
      RepaymentAccount(
        id: json["id"].toString(),
        friend:
            RepaymentFriend.fromJson(json["friend"] as Map<String, dynamic>),
        balance: json["balance"] as int,
        createdAt: DateTime.parse(json["created_at"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "friend": friend.toJson(),
        "user1_balance": balance,
        "created_at": createdAt.toIso8601String(),
      };
}

class RepaymentFriend {
  RepaymentFriend({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.v,
  });

  String id;
  String name;
  String email;
  String password;
  int v;

  factory RepaymentFriend.fromJson(Map<String, dynamic> json) =>
      RepaymentFriend(
        id: json["_id"] as String,
        name: json["name"] as String,
        email: json["email"] as String,
        password: json["password"] as String,
        v: json["__v"] as int,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "__v": v,
      };
}
