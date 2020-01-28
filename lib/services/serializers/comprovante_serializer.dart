class ComprovanteSerializer {
    int id;
    String comprovante;

    ComprovanteSerializer({
        this.id,
        this.comprovante,
    });

    factory ComprovanteSerializer.fromJson(Map<String, dynamic> json) => ComprovanteSerializer(
        id: json["id"] == null ? null : json["id"],
        comprovante: json["comprovante"] == null ? null : json["comprovante"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "comprovante": comprovante == null ? null : comprovante,
    };
}
