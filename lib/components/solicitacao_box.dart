import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/detalhes/detalhe.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:intl/intl.dart';

class SolicitacaoBox extends StatelessWidget {
  final SolicitacaoSerializer item;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhePage(id: item.id)));
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
