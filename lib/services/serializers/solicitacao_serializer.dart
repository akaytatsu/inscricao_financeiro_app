import 'package:flutter/material.dart';

class SolicitacaoSerializer {
    int id;
    Solicitante solicitante;
    int status;
    double valor;
    String justificativa;
    String justificativaReprovacao;
    bool aprovado;
    bool comprovado;
    DateTime dataSolicitacao;
    int conferencia;
    int usuarioSolicitacao;
    dynamic usuarioAprovacao;
    dynamic usuarioComprovacao;
    String categoria;

    SolicitacaoSerializer({
        this.id,
        this.solicitante,
        this.status,
        this.valor,
        this.justificativa,
        this.justificativaReprovacao,
        this.aprovado,
        this.comprovado,
        this.dataSolicitacao,
        this.conferencia,
        this.usuarioSolicitacao,
        this.usuarioAprovacao,
        this.usuarioComprovacao,
        this.categoria,
    });

    factory SolicitacaoSerializer.fromJson(Map<String, dynamic> json) => SolicitacaoSerializer(
        id: json["id"] == null ? null : json["id"],
        solicitante: json["solicitante"] == null ? null : Solicitante.fromJson(json["solicitante"]),
        status: json["status"] == null ? null : json["status"],
        valor: json["valor"] == null ? null : json["valor"],
        justificativa: json["justificativa"] == null ? null : json["justificativa"],
        justificativaReprovacao: json["justificativa_reprovacao"] == null ? null : json["justificativa_reprovacao"],
        aprovado: json["aprovado"] == null ? null : json["aprovado"],
        comprovado: json["comprovado"] == null ? null : json["comprovado"],
        dataSolicitacao: json["data_solicitacao"] == null ? null : DateTime.parse(json["data_solicitacao"]),
        conferencia: json["conferencia"] == null ? null : json["conferencia"],
        usuarioSolicitacao: json["usuario_solicitacao"] == null ? null : json["usuario_solicitacao"],
        usuarioAprovacao: json["usuario_aprovacao"],
        usuarioComprovacao: json["usuario_comprovacao"],
        categoria: json["categoria"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "solicitante": solicitante == null ? null : solicitante.toJson(),
        "status": status == null ? null : status,
        "valor": valor == null ? null : valor,
        "justificativa": justificativa == null ? null : justificativa,
        "justificativa_reprovacao": justificativaReprovacao == null ? null : justificativaReprovacao,
        "aprovado": aprovado == null ? null : aprovado,
        "comprovado": comprovado == null ? null : comprovado,
        "data_solicitacao": dataSolicitacao == null ? null : dataSolicitacao.toIso8601String(),
        "conferencia": conferencia == null ? null : conferencia,
        "usuario_solicitacao": usuarioSolicitacao == null ? null : usuarioSolicitacao,
        "usuario_aprovacao": usuarioAprovacao,
        "usuario_comprovacao": usuarioComprovacao,
        "categoria": categoria,
    };

  String statusTitulo() {
    String statusStr = "";

    switch (this.status) {
      case 1:
        statusStr = "Aguardando Aprovação";
        break;
      case 2:
        statusStr = "Aprovado";
        break;
      case 3:
        statusStr = "Recurso Repassado";
        break;
      case 4:
        statusStr = "Aguardando Comprovação";
        break;
      case 5:
        statusStr = "Comprovação em Analise";
        break;
      case 6:
        statusStr = "Comprovado";
        break;
      case 8:
        statusStr = "Reprovado";
        break;
      default:
        statusStr = "";
    }

    return statusStr;
  }

  Color statusColor(){
    Color color;

    if (status == 1) {
      color = Color(0xFF857E7E);
    } else if (status == 2) {
      color = Color(0xFF3977FF);
    } else if (status == 3 || status == 4) {
      color = Color(0xFFB48508);
    } else if (status == 5) {
      color = Color(0xFF7008B4);
    } else if (status == 6) {
      color = Color(0xFF02A212);
    } else if (status == 8) {
      color = Color(0xFFDB0404);
    }

    return color;
  }

  List<Color> listColors() {
    List<Color> colors;

    if (status == 1) {
      colors = [
        Color(0xFF857E7E),
        Color(0xFF656161),
      ];
    } else if (status == 2) {
      colors = [
        Color(0xFF3977FF),
        Color(0xFF1C55D4),
      ];
    } else if (status == 3 || status == 4) {
      colors = [
        Color(0xFFB48508),
        Color(0xFFA77A03),
      ];
    } else if (status == 5) {
      colors = [
        Color(0xFF7008B4),
        Color(0xFF450171),
      ];
    } else if (status == 6) {
      colors = [
        Color(0xFF02A212),
        Color(0xFF008D0E),
      ];
    } else if (status == 8) {
      colors = [
        Color(0xFFDB0404),
        Color(0xFFB50404),
      ];
    }

    return colors;
  }
}

class Solicitante {
    int id;
    String name;
    String email;
    dynamic telefone;
    bool canRequest;
    bool canAprove;
    bool canPay;
    int tpUserFinanceiro;

    Solicitante({
        this.id,
        this.name,
        this.email,
        this.telefone,
        this.canRequest,
        this.canAprove,
        this.canPay,
        this.tpUserFinanceiro,
    });

    factory Solicitante.fromJson(Map<String, dynamic> json) => Solicitante(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        telefone: json["telefone"],
        canRequest: json["can_request"] == null ? null : json["can_request"],
        canAprove: json["can_aprove"] == null ? null : json["can_aprove"],
        canPay: json["can_pay"] == null ? null : json["can_pay"],
        tpUserFinanceiro: json["tp_user_financeiro"] == null ? null : json["tp_user_financeiro"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "telefone": telefone,
        "can_request": canRequest == null ? null : canRequest,
        "can_aprove": canAprove == null ? null : canAprove,
        "can_pay": canPay == null ? null : canPay,
        "tp_user_financeiro": tpUserFinanceiro == null ? null : tpUserFinanceiro,
    };
}