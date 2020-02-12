import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/detalhes/detalhe.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:intl/intl.dart';

class SolicitacaoBox extends StatelessWidget {
  final SolicitacaoSerializer item;
  AnimationController controller;
  Animation<double> animation;

  SolicitacaoBox(
      {Key key, @required this.item})
      : super(key: key);

  gradientBackground() {
    return LinearGradient(colors: item.listColors());
  }

  Widget nomeSolicitanteWidget() {
    var textStyle = TextStyle(color: Colors.white, fontSize: 20);

    return Text(
      item.solicitante.name,
      style: textStyle,
    );
  }

  Widget dataSolicitacaoWidget() {
    var textStyle = TextStyle(color: Colors.white, fontSize: 20);

    return Text(
      DateFormat("dd/MM/yyyy", "en_US").format(item.dataSolicitacao),
      style: textStyle,
    );
  }

  Widget idSolicitacaoWidget() {
    var textStyle = TextStyle(color: Colors.white, fontSize: 20);

    return Text(
      "ID: " + item.id.toString(),
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
          f.format(item.valor),
          style: valueTextStyle,
        ),
      ],
    );
  }

  Widget statusSolicitacaoWidget() {
    String statusStr = "Situação: " + item.statusTitulo();

    var textStyle = TextStyle(color: Color(0xFFCECBCB), fontSize: 15);

    return Text(
      statusStr,
      style: textStyle,
    );
  }

  Widget statusRound(){
    return Container(
      decoration: BoxDecoration(
        color: item.statusColor(),
        borderRadius: BorderRadius.all(Radius.circular(100))
      ),
      width: 15,
      height: 15,
    );
  }

  Widget memberDetails(){

    var solicitanteNome = Text(
      item.solicitante.maxName(),
      style: TextStyle(
        fontSize: 18
      )
    );

    var status = Text(
      item.statusTitulo(),
      style: TextStyle(
        fontSize: 14
      )
    );

    var descricao = Text(
      item.justificativa.length > 27 ? item.justificativa.substring(0, 27) + "..." : item.justificativa,
      style: TextStyle(
        fontSize: 16
      )
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        solicitanteNome,
        descricao,
        status,
      ],
    );
  }

  Widget valueDetails(){

    Intl.defaultLocale = 'pt_BR';
    var f = new NumberFormat("#,###.00");

    String valor = "R\$: " + f.format(item.valor);

    var valueDetail = Text(
      valor,
      style: TextStyle(
        fontSize: 19
      )
    );

    var date = Text(
      DateFormat("dd/MM/yyyy", "en_US").format(item.dataSolicitacao.toLocal()),
      style: TextStyle(
        fontSize: 13
      )
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        valueDetail,
        Padding(padding: EdgeInsets.only(top: 5),),
        date,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    var decoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black26,
          width: 1
        )
      )
    );

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhePage(id: item.id)));
      },
      child: Container(
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                statusRound(),
                Padding(padding: EdgeInsets.only(right: 10),),
                memberDetails(),
              ],
            ),
            valueDetails(),
          ],
        ),
      ),
    );

  }
}
