import 'package:flutter/material.dart';

class DetalhePage extends StatefulWidget {
  final int status;
  final int id;

  DetalhePage({Key key, @required this.status, @required this.id})
      : super(key: key);

  @override
  _DetalhePageState createState() =>
      _DetalhePageState(status: this.status, id: this.id);
}

class _DetalhePageState extends State<DetalhePage> {
  final int status;
  final int id;

  Color colorStatus() {
    if (status == 1) {
      return Color(0xFF857E7E);
    } else if (status == 2) {
      return Color(0xFF3977FF);
    } else if (status == 3 || status == 4) {
      return Color(0xFFB48508);
    } else if (status == 5) {
      return Color(0xFF7008B4);
    } else if (status == 6) {
      return Color(0xFF02A212);
    } else if (status == 8) {
      return Color(0xFFDB0404);
    }

    return Color(0xFF857E7E);
  }

  _DetalhePageState({this.status, this.id});

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
          child: Text("Aguardando Aprovação",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorStatus())),
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
            color: colorStatus(),
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
            detalheELabel("Solicitante", "Thiago Freitas"),
            detalheELabel("Data Solicitação", "21/10/2020"),
            detalheELabel("Valor", "R\$ 500,00"),
            detalheELabel("Categoria", "T.I"),
            detalheELabel("Justificativa",
                "Solicito para fazer alguma coisa, e devo descrever aqui qual é a solticiação para um novo teste de um novo tetse para ver qual"),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
            )
          ],
        ));
  }

  Widget btn(String label, IconData icon){
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      appBar: null,
      body: ListView(
        children: <Widget>[
          topo(),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          detalhes(),
          
          Padding(padding: EdgeInsets.only(top: 30)),

          btn("Aprovar Solicitação", Icons.check),
          btn("Reprovar Solicitação", Icons.close),
          btn("Confirmar Repasse Recurso", Icons.monetization_on),
          btn("Selecionar Comprovante", Icons.add_a_photo),
          btn("Enviar Comprovante", Icons.file_upload),
          btn("Confirmar Comprovação", Icons.check_circle),
          btn("Recusar Comprovação", Icons.reply),
        ],
      ),
    );
  }
}
