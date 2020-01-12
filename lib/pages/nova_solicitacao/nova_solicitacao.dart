import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/home/components/menu.dart';

class NovaSolicitacaoPage extends StatefulWidget {
  NovaSolicitacaoPage({Key key}) : super(key: key);

  @override
  _NovaSolicitacaoPageState createState() => _NovaSolicitacaoPageState();
}

class _NovaSolicitacaoPageState extends State<NovaSolicitacaoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Finanças Conferência IEC",
        ),
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 20),),
          Container(
            child: Center(
              child: MainMenu(defaultSelected: 2,),
            ),
          ),
        ],
      ),
    );
  }
}
