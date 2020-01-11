import 'package:iec_despesas_app/components/solicitacao_box.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  List<Widget> solicitacoes() {
    List<Widget> response = [];

    response.add(SolicitacaoBox(
      status: 1,
      dataSolicitacao: "21/01/2019",
      solicitante: "Thiago Freitas",
      valor: 200,
    ));

    response.add(SolicitacaoBox(
      status: 2,
      dataSolicitacao: "23/01/2019",
      solicitante: "Samuel Backer",
      valor: 70,
    ));

    response.add(SolicitacaoBox(
      status: 4,
      dataSolicitacao: "27/01/2019",
      solicitante: "Charles Pierre Freitas",
      valor: 6700,
    ));

    response.add(SolicitacaoBox(
      status: 5,
      dataSolicitacao: "27/01/2019",
      solicitante: "Cleiton Cunha",
      valor: 1200,
    ));

    response.add(SolicitacaoBox(
      status: 6,
      dataSolicitacao: "27/01/2019",
      solicitante: "Fabiane Freitas",
      valor: 350,
    ));

    response.add(SolicitacaoBox(
      status: 8,
      dataSolicitacao: "27/01/2019",
      solicitante: "Thiago Freitas",
      valor: 125,
    ));

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Finanças Conferência IEC",
        ),
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 20),),
          ...solicitacoes()
        ],
      ),
    );
  }
}
