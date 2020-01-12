import 'package:iec_despesas_app/components/solicitacao_box.dart';
import 'package:flutter/material.dart';
import 'package:iec_despesas_app/main.dart';
import 'package:iec_despesas_app/pages/home/components/menu.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:intl/intl.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  RestApi api = RestApi();

  Future<List<SolicitacaoSerializer>> buscaSolicitacoes() async{

    var response = await api.getSolicitacoes();
    List<SolicitacaoSerializer> solicitacoes = [];

    if( response['status'] == 200 ){
      solicitacoes = response['data'];
    }

    return solicitacoes;

  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              RestApi().logout();
              Navigator.push(context, MaterialPageRoute(builder: (_) => IntermdiareScreen()));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: buscaSolicitacoes(),
        builder: (BuildContext context, AsyncSnapshot<List<SolicitacaoSerializer>> snapshot){

          List<Widget> solicitacoesWidgets = [];

          if(snapshot.hasData){

            for (SolicitacaoSerializer item in snapshot.data) {
              solicitacoesWidgets.add(
                SolicitacaoBox(
                  status: item.status,
                  dataSolicitacao: DateFormat("dd/MM/yyyy", "en_US").format(item.dataSolicitacao),
                  solicitante: item.solicitante.name,
                  valor: item.valor,
                )
              );
            }

          }

          return ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: 20),),
              Container(
                child: Center(
                  child: MainMenu(defaultSelected: 1,),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: Color(0xFF333333),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),),

              ...solicitacoesWidgets
            ],
          );

        }
      )
    );
  }
}
