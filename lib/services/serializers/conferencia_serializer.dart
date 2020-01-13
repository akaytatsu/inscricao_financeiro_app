class ConferenciaSerializer {
    int id;
    String titulo;

    ConferenciaSerializer({
        this.id,
        this.titulo,
    });

    factory ConferenciaSerializer.fromJson(Map<String, dynamic> json) => ConferenciaSerializer(
        id: json["id"] == null ? null : json["id"],
        titulo: json["titulo"] == null ? null : json["titulo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "titulo": titulo == null ? null : titulo,
    };
}

class Conferencia {
    int id;
    String titulo;

    Conferencia({
        this.id,
        this.titulo,
    });

    factory Conferencia.fromJson(Map<String, dynamic> json) => Conferencia(
        id: json["id"] == null ? null : json["id"],
        titulo: json["titulo"] == null ? null : json["titulo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "titulo": titulo == null ? null : titulo,
    };
}