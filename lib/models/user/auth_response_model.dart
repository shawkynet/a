import 'dart:convert';

class AuthResponse {
    AuthResponse({
        required this.error,
        required this.token_type,
        required this.email,
        required this.api_token,
        required this.expires_at,
        required this.user,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return {

        };
    }

    static fromJson(data) {
        List<String> list = [];
        if(data?['email'] != null){
            list = [];
            for(int index= 0; index < (data['email'] as List).length;index++){
                list.add((data['email'] as List)[index]);
            }
        }
        AuthResponse authResponse = AuthResponse(
            expires_at: data?['expires_at']??'',
            token_type: data?['token_type']??'',
            user: data?['user']??{},
            email: list,
            api_token: data?['remember_token']??'',
            error: data?['error']??data?['message']??null,
        );
        return authResponse;
    }

    final String expires_at;
    final String api_token;
    final List<String> email;
    final String token_type;
    final String? error;
    Map user;
}
