import 'dart:convert';

AuthTokenSerializer authTokenSerializerFromJson(String str) => AuthTokenSerializer.fromJson(json.decode(str));

String authTokenSerializerToJson(AuthTokenSerializer data) => json.encode(data.toJson());

class AuthTokenSerializer {
    String token;

    AuthTokenSerializer({
        this.token,
    });

    factory AuthTokenSerializer.fromJson(Map<String, dynamic> json) => AuthTokenSerializer(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
