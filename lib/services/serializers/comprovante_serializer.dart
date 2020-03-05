class ComprovanteSerializer {
    int id;
    String comprovante;
    bool isImage;
    String fileExt;

    ComprovanteSerializer({
        this.id,
        this.comprovante,
        this.isImage,
        this.fileExt,
    });

    factory ComprovanteSerializer.fromJson(Map<String, dynamic> json) => ComprovanteSerializer(
        id: json["id"] == null ? null : json["id"],
        comprovante: json["comprovante"] == null ? null : json["comprovante"],
        isImage: json["is_image"] == null ? null : json["is_image"],
        fileExt: json["extension"] == null ? null : json["extension"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "comprovante": comprovante == null ? null : comprovante,
    };
}
