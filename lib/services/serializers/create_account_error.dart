class CreateAccountErrorSerializer {
    List<String> name;
    List<String> password;
    List<String> passwordConfirm;
    List<String> email;
    List<String> telefone;
    List<String> nonFieldErrors;

    CreateAccountErrorSerializer({
        this.name,
        this.password,
        this.passwordConfirm,
        this.email,
        this.telefone,
        this.nonFieldErrors,
    });

    factory CreateAccountErrorSerializer.fromJson(Map<String, dynamic> json) => CreateAccountErrorSerializer(
        name: json["name"] == null ? null : List<String>.from(json["name"].map((x) => x)),
        password: json["password"] == null ? null : List<String>.from(json["password"].map((x) => x)),
        passwordConfirm: json["password_confirm"] == null ? null : List<String>.from(json["password_confirm"].map((x) => x)),
        email: json["email"] == null ? null : List<String>.from(json["email"].map((x) => x)),
        telefone: json["telefone"] == null ? null : List<String>.from(json["telefone"].map((x) => x)),
        nonFieldErrors: json["non_field_errors"] == null ? null : List<String>.from(json["non_field_errors"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : List<dynamic>.from(name.map((x) => x)),
        "password": password == null ? null : List<dynamic>.from(password.map((x) => x)),
        "password_confirm": passwordConfirm == null ? null : List<dynamic>.from(passwordConfirm.map((x) => x)),
        "email": email == null ? null : List<dynamic>.from(email.map((x) => x)),
        "telefone": telefone == null ? null : List<dynamic>.from(telefone.map((x) => x)),
        "non_field_errors": nonFieldErrors == null ? null : List<dynamic>.from(nonFieldErrors.map((x) => x)),
    };
}