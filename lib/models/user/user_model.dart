import 'dart:convert';

class UserModel {
    UserModel({
        required this.id,
        required this.nationalityId,
        required this.name,
        required this.email,
        this.error,
        this.type,
        this.api_token,
         this.balance,
        this.created_at,
         this.code,
        this.created_by,
        this.created_by_type,
        this.password,
        this.pickup_cost,
        this.responsible_mobile,
        this.supply_cost,
        this.updated_at,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return {
            'id': id.toString(),
            'national_id': id.toString(),
            'created_at': created_at ?? '',
            'type': type ?? '',
            'code': code.toString(),
            'balance': balance.toString(),
            'remember_token': api_token??'',
            'error': error??'',
            'created_by': created_by ?? '',
            'created_by_type': created_by_type ?? '',
            'pickup_cost': pickup_cost??'',
            'supply_cost': supply_cost??'',
            'updated_at': updated_at??'',
            'name': name,
            'email': email,
            'password': password??'',
            'responsible_mobile': responsible_mobile??'',
        };
    }
    Map<String, String> toJsonForRegister(String token) {
        return {
            'name': name,
            'national_id': nationalityId,
            'responsible_name':name,
            'email': email,
            'device_token': token,
            'password': password??'',
            'responsible_mobile': "123123123777",
            'type':'client',
            'branch_id':id
        };
    }

    static fromJson(user) {
        // print('userfromJson');
        // print(user);
        return UserModel(
            nationalityId: (user['national_id']??'').toString(),
            id: (user['id']??'').toString(),
            created_at: (user['created_at']??''),
            type: (user['type']??'').toString(),
            balance: (user['balance']??'').toString(),
            code: (user['code']??'').toString(),
            api_token: (user['remember_token']??''),
            error: user?['error'],
            name: (user['name']??''),
            email: (user['email']??''),
            created_by: (user['created_by']??'').toString(),
            created_by_type: (user['created_by_type']??''),
            pickup_cost: (user['pickup_cost']??''),
            responsible_mobile: (user['responsible_mobile']??'')??(user['phone']??''),
            password: null,
            supply_cost: (user['supply_cost']??''),
            updated_at: (user['updated_at']??''),
        );
    }

    final String id;
    final String nationalityId;
    final String? code;
    final String name;
    final String email;
    final String? type;
    String? api_token;
    final String? error;
    String? balance;
    final String? responsible_mobile;
    final String? password;
    final String? updated_at;
    final String? created_at;
    final String? created_by_type;
    final String? created_by;
    final String? pickup_cost;
    final String? supply_cost;
}
