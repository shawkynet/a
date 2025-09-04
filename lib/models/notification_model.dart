import 'dart:convert';

import 'package:cargo/models/user/user_model.dart';

class NotificationModel {
    NotificationModel({
        required this.sender,
        required this.created_at,
        required this.subject,
        required this.id,
        required this.code,
        required this.content,
        required this.url,
        required this.icon,
        required this.type,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'sender': sender.toString(),
            'code': code,
            'subject': subject,
            'created_at': created_at,
            'id': id,
            'content': content,
            'url': url,
            'icon': icon,
            'type': type,
        };
    }

    static fromJson(data) {
        return NotificationModel(
            sender: UserModel.fromJson(data?['data']?['sender']??{}),
            subject: (data?['data']??'')['message']['subject'].toString(),
            id: (data?['data']??'')['message']['id'].toString(),
            content: (data?['data']??'')['message']['content'].toString(),
            url: (data?['data']??'')['message']['url'].toString(),
            code: (data?['data']??'')['message']['code'],
            icon: (data?['data']??'')['icon'].toString(),
            type: (data?['data']??'')['type'].toString(),
            created_at: (data?['created_at']??''),
        );
    }

    final UserModel sender;
    final String subject;
    final String created_at;
    final String id;
    final String content;
    final String url;
    final String icon;
    final String type;
    final String code;
}