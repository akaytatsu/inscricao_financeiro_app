class AccountSerializer {
    int id;
    String name;
    String email;
    bool canAprove;
    bool canRequest;
    bool canPay;

    AccountSerializer({
        this.id,
        this.name,
        this.email,
        this.canAprove,
        this.canRequest,
        this.canPay,
    });

    factory AccountSerializer.fromJson(Map<String, dynamic> json) => AccountSerializer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        canAprove: json["can_aprove"],
        canRequest: json["can_request"],
        canPay: json["can_pay"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "can_aprove": canAprove,
        "can_request": canRequest,
        "can_pay": canPay,
    };
}

class CreateAccountErrorsSerializer {
    List<String> name;
    List<String> password;
    List<String> passwordConfirm;
    List<String> email;
    List<String> nonFieldErrors;

    CreateAccountErrorsSerializer({
        this.name,
        this.password,
        this.passwordConfirm,
        this.email,
        this.nonFieldErrors,
    });

    factory CreateAccountErrorsSerializer.fromJson(Map<String, dynamic> json) => CreateAccountErrorsSerializer(
        name: json["name"] == null ? null : List<String>.from(json["name"].map((x) => x)),
        password: json["password"] == null ? null : List<String>.from(json["password"].map((x) => x)),
        passwordConfirm: json["password_confirm"] == null ? null : List<String>.from(json["password_confirm"].map((x) => x)),
        email: json["email"] == null ? null : List<String>.from(json["email"].map((x) => x)),
        nonFieldErrors: json["non_field_errors"] == null ? null : List<String>.from(json["non_field_errors"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : List<dynamic>.from(name.map((x) => x)),
        "password": password == null ? null : List<dynamic>.from(password.map((x) => x)),
        "password_confirm": passwordConfirm == null ? null : List<dynamic>.from(passwordConfirm.map((x) => x)),
        "email": email == null ? null : List<dynamic>.from(email.map((x) => x)),
        "non_field_errors": nonFieldErrors == null ? null : List<dynamic>.from(nonFieldErrors.map((x) => x)),
    };
}
