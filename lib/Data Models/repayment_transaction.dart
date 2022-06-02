import 'dart:convert';

RepaymentTransaction repaymentTransactionFromJson(String str) =>
    RepaymentTransaction.fromJson(json.decode(str) as Map<String, dynamic>);

String repaymentTransactionToJson(RepaymentTransaction data) =>
    json.encode(data.toJson());

class RepaymentTransaction {
  RepaymentTransaction({
    required this.id,
    required this.user1,
    required this.user2,
    required this.repaymentAccount,
    required this.user1Transaction,
    required this.user2Transaction,
    required this.user1Accepted,
    required this.user2Accepted,
    required this.createdAt,
    required this.v,
  });

  String id;
  String user1;
  String user2;
  String repaymentAccount;
  int user1Transaction;
  int user2Transaction;
  bool user1Accepted;
  bool user2Accepted;
  DateTime createdAt;
  int v;

  factory RepaymentTransaction.fromJson(Map<String, dynamic> json) =>
      RepaymentTransaction(
        id: json["_id"] as String,
        user1: json["user1"] as String,
        user2: json["user2"] as String,
        repaymentAccount: json["repayment_account"] as String,
        user1Transaction: json["user1_transaction"] as int,
        user2Transaction: json["user2_transaction"] as int,
        user1Accepted: json["user1_accepted"] as bool,
        user2Accepted: json["user2_accepted"] as bool,
        createdAt: DateTime.parse(json["created_at"] as String),
        v: json["__v"] as int,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user1": user1,
        "user2": user2,
        "repayment_account": repaymentAccount,
        "user1_transaction": user1Transaction,
        "user2_transaction": user2Transaction,
        "user1_accepted": user1Accepted,
        "user2_accepted": user2Accepted,
        "created_at": createdAt.toIso8601String(),
        "__v": v,
      };
}
