import 'dart:convert';

class ReceiverModel {
  ReceiverModel(
      {
        required this.receiver_name,
        required this.receiver_email,
        required this.receiver_mobile,
       });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'receiver_name': receiver_name,
      'receiver_email': receiver_email,
      'receiver_mobile': receiver_mobile,
    };
  }

  static fromJson(data) {
    return ReceiverModel(
      receiver_name: (data?['receiver_name']??'').toString(),
      receiver_email: (data?['receiver_email']??'').toString(),
      receiver_mobile: (data?['receiver_mobile']??'').toString(),
    );
  }

  final String receiver_name;
  final String receiver_email;
  final String receiver_mobile;
}
