import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/home/home.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/account_serializers.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:intl/intl.dart';

class DetalhePage extends StatefulWidget {
  final SolicitacaoSerializer item;
  final String title;
  final Color color;

  DetalhePage({Key key, @required this.item, @required this.title, @required this.color})
      : super(key: key);

  @override
  _DetalhePageState createState() =>
      _DetalhePageState(item: this.item, title: this.title, color: this.color);
}

class _DetalhePageState extends State<DetalhePage> {
  final SolicitacaoSerializer item;
  final String title;
  final Color color;

  final List<Widget> buttons = new List();
  AccountSerializer user = new AccountSerializer();
  
  RestApi _api = RestApi();
  
  _DetalhePageState({this.item, this.title, this.color});

  Future<AccountSerializer> getUserInfo() async{
    var response = await _api.me();

    if( response['status'] == 200 ){
      user = response['data'];
    }

    return user;
  }

  configButtons(){
    if (item.status == 1 && user.canAprove) {
      buttons.add(btn("Aprovar Solicitação", Icons.check, approve));
      buttons.add(btn("Reprovar Solicitação", Icons.close, errorRequestDialog));
    } else if (item.status == 2 && user.canPay) {
      buttons.add(btn("Confirmar Repasse Recurso", Icons.monetization_on, confirmTransferMoney));
    } else if (item.status == 3 || item.status == 4) {
      buttons.add(btn("Selecionar Comprovante", Icons.add_a_photo, errorRequestDialog));
      buttons.add(btn("Enviar Comprovante", Icons.file_upload, errorRequestDialog));
    } else if (item.status == 5 && user.canAprove) {
      buttons.add(btn("Confirmar Comprovação", Icons.check_circle, confirmProof));
      buttons.add(btn("Recusar Comprovação", Icons.reply, errorRequestDialog));
    }
  }

  Widget detalhesTitulo() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 50),
      child: Text(
        "Detalhes Solicitação",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }

  Widget boxStatus() {
    return Center(
      child: Container(
        height: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 3,
                offset: Offset(1, 1),
              )
            ]),
        margin: EdgeInsets.only(left: 10, right: 10, top: 90),
        child: Center(
          child: Text(this.title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: this.color)),
        ),
      ),
    );
  }

  Widget btnVoltar() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 20,
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        margin: EdgeInsets.only(top: 15, left: 10),
      ),
    );
  }

  Widget topo() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: this.color,
          ),
          height: 137,
          width: MediaQuery.of(context).size.width,
        ),
        btnVoltar(),
        detalhesTitulo(),
        boxStatus(),
      ],
    );
  }

  Widget detalheELabel(String label, String valor) {

    if(valor == null) {
      valor = "";
    }

    final double fontSize = 15;

    return Container(
      margin: EdgeInsets.only(left: 20, top: 10),
      padding: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Text(label + ": ",
              style: TextStyle(color: Color(0xFFACA4A4), fontSize: fontSize)),
          Expanded(
            child: Text(valor,
                style: TextStyle(
                    color: Color(0xFFACA4A4),
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget detalhes() {
    Widget titulo = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(25), topEnd: Radius.circular(25)),
        color: Color(0xFFEEEEF7),
      ),
      height: 45,
      child: Center(
        child: Text("DETALHES",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B9BAF))),
      ),
    );

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 3,
                offset: Offset(1, 1),
              )
            ]),
        child: Column(
          children: <Widget>[
            titulo,
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            detalheELabel("Solicitante", this.item.solicitante.name),
            detalheELabel("Data Solicitação", DateFormat("dd/MM/yyyy", "en_US").format(this.item.dataSolicitacao)),
            detalheELabel("Valor", "R\$" + new NumberFormat("#,###.00").format(item.valor)),
            detalheELabel("Categoria", item.categoria),
            detalheELabel("Justificativa", item.justificativa),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
            )
          ],
        ));
  }

  errorRequestDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text("ops..."),
              content: Text(
                "Houve uma falha ao processar sua ação, por favor tente novamente.",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                // define os botões na base do dialogo
                FlatButton(
                  child: Text("close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  approve() async{
    Map<String, dynamic> response = await _api.approve(item.id);

    if (response['status'] != 200) {
      return this.errorRequestDialog();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainHomePage()));
  }

  confirmTransferMoney() async{
    Map<String, dynamic> response = await _api.confirmTransferMoney(item.id);

    if (response['status'] != 200) {
      return this.errorRequestDialog();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainHomePage()));
  }

  confirmProof() async{
    Map<String, dynamic> response = await _api.confirmProof(item.id);

    if (response['status'] != 200) {
      return this.errorRequestDialog();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainHomePage()));
  }

  Widget btn(String label, IconData icon, Function action){
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFF48A8E7)),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 3,
                offset: Offset(1, 1),
              )
            ]),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(label, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF9FA6BC))),
                Icon(icon, color: Color(0xFFA2A9BD), size: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    var builder = <Widget>[
      topo(),
      Padding(
        padding: EdgeInsets.only(top: 20),
      ),
      detalhes(),

      Padding(padding: EdgeInsets.only(top: 30))
    ];

    configButtons();
    buttons.forEach((b) => builder.add(b));

    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      appBar: null,
      body: FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<AccountSerializer> snapshot) {

          if(!snapshot.hasData){
            return ListView();
          }

          return ListView(
              children: buildChildren()
          );
        },
      ),

      
    );
  }
}
