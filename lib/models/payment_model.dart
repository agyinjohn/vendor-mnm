class PaymentMethod {
  final String id;
  final String userId;
  final String type;
  final String name;
  final String accountNumber;
  final String bankCode;
  final String recipientCode;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.accountNumber,
    required this.bankCode,
    required this.recipientCode,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      name: json['name'],
      accountNumber: json['account_number'],
      bankCode: json['bank_code'],
      recipientCode: json['recipient_code'],
    );
  }
}
