import 'dart:convert';

class ForgetPasswordModel {
    ForgetPasswordModel({
        required this.message,
        required this.status,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'message': message,
            'status': status,
        };
    }

    static fromJson(data) {
        return ForgetPasswordModel(
            status: data['status']??false,
            message: (data['message']??'').toString(),
        );
    }

    final String message;
    final bool status;
}
