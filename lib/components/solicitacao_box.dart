import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/detalhes/detalhe.dart';
import 'package:intl/intl.dart';

class SolicitacaoBox extends StatelessWidget {
  final int status;
  final String solicitante;
  final String dataSolicitacao;
  final num valor;

  const SolicitacaoBox(
      {Key key,
      @required this.status,
      @required this.solicitante,
      @required this.dataSolicitacao,
      @required this.valor})
      : super(key: key);

  gradientBackground() {
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

    return LinearGradient(colors: colors);
  }

  Widget nomeSolicitanteWidget() {
    var textStyle = TextStyle(color: Colors.white, fontSize: 20);

    return Text(
      solicitante,
      style: textStyle,
    );
  }

  Widget dataSolicitacaoWidget() {
    var textStyle = TextStyle(color: Colors.white, fontSize: 20);

    return Text(
      dataSolicitacao,
      style: textStyle,
    );
  }

  Widget valorSolicitacaoWidget() {
    var valueTextStyle = TextStyle(color: Colors.white, fontSize: 20);

    var rsTextStyle = TextStyle(color: Colors.white, fontSize: 15);

    Intl.defaultLocale = 'pt_BR';

    var f = new NumberFormat("#,###.00");

    return Row(
      children: <Widget>[
        Text(
          "R\$",
          style: rsTextStyle,
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
        ),
        Text(
          f.format(valor),
          style: valueTextStyle,
        ),
      ],
    );
  }

  Widget statusSolicitacaoWidget() {
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

    statusStr = "Situação: " + statusStr;

    var textStyle = TextStyle(color: Color(0xFFCECBCB), fontSize: 15);

    return Text(
      statusStr,
      style: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhePage(status: status, id: 1)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        height: 110,
        decoration: BoxDecoration(
            gradient: gradientBackground(),
            borderRadius: BorderRadiusDirectional.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 3,
                offset: Offset(3, 3),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 50, top: 15),
              child: nomeSolicitanteWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 70, top: 5),
              child: statusSolicitacaoWidget(),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30, top: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    dataSolicitacaoWidget(),
                    valorSolicitacaoWidget()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
