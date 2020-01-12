import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/home/home.dart';
import 'package:iec_despesas_app/pages/nova_solicitacao/nova_solicitacao.dart';

class MainMenu extends StatelessWidget {
  final int defaultSelected;

  const MainMenu({Key key, @required this.defaultSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double menuSize = 170;
    const double borderRadius = 10;
    const double menuHeight = 40;
    const double fontSize = 20;

    return Container(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MainHomePage()));
            },
            child: Container(
              child: Center(
                child: Text(
                  "Solicitações",
                  style: TextStyle(
                      color: defaultSelected == 1
                          ? Colors.white
                          : Color(0xFF707070),
                      fontSize: fontSize),
                ),
              ),
              height: menuHeight,
              width: menuSize,
              decoration: BoxDecoration(
                  color: defaultSelected == 1
                      ? Color(0xFF2E8FFF)
                      : Color(0xFFF2F4F8),
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(borderRadius),
                      bottomStart: Radius.circular(borderRadius))),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NovaSolicitacaoPage()));
            },
            child: Container(
              child: Center(
                child: Text(
                  "Nova Solicitação",
                  style: TextStyle(
                      color: defaultSelected == 2
                          ? Colors.white
                          : Color(0xFF707070),
                      fontSize: fontSize),
                ),
              ),
              height: menuHeight,
              width: menuSize,
              decoration: BoxDecoration(
                  color: defaultSelected == 2
                      ? Color(0xFF2E8FFF)
                      : Color(0xFFF2F4F8),
                  borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(borderRadius),
                      bottomEnd: Radius.circular(borderRadius))),
            ),
          )
        ],
      ),
    );
  }
}
