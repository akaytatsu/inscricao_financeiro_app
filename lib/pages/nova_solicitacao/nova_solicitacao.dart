import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/home/components/menu.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/conferencia_serializer.dart';

import '../../main.dart';

class NovaSolicitacaoPage extends StatefulWidget {
  NovaSolicitacaoPage({Key key}) : super(key: key);

  @override
  _NovaSolicitacaoPageState createState() => _NovaSolicitacaoPageState();
}

class _NovaSolicitacaoPageState extends State<NovaSolicitacaoPage> {
  final _description = TextEditingController();
  final _price = TextEditingController();
  List<DropdownMenuItem<ConferenciaSerializer>> _dropDownConferencia = new List();
  ConferenciaSerializer _currentConferencia;

  RestApi _api = RestApi();

  Future<List<ConferenciaSerializer>> buscaConferencias() async{

    var response = await _api.getConferencias();
    List<ConferenciaSerializer> conferencias = [];

    if( response['status'] == 200 ){
      conferencias = response['data'];
    }

    return conferencias;

  }

  textField(label, TextEditingController controller,
      {String placeholder = ""}) {
    final labelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4080FE),
    );

    return Container(
      margin: EdgeInsets.only(top: 20),
      constraints: BoxConstraints(maxWidth: 300),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style: labelStyle,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: placeholder),
          )
        ],
      ),
    );
  }

  btnRegister() {
    return this.btn("Cadastrar", 0xFF4080FE, () {
      actionRegister();
    });
  }

  actionRegister() async {
    Map<String, dynamic> response =
    await _api.newSolicitation(_description.text, double.parse(_price.text), 1, context: context);

    if (response['status'] != 200) {
      return this.errorRegisterSolicitationDialog();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => IntermdiareScreen()));
  }

  btn(label, color, Function action) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(color),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  errorRegisterSolicitationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text("ops..."),
              content: Text(
                "Não foi possível cadastrar sua solicitação, por favor tente novamente.",
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

  void changedDropDownItem(ConferenciaSerializer selectedCity) {
    if(_dropDownConferencia.isEmpty || _dropDownConferencia.length == 1){
      return;
    }

    setState(() {
      _currentConferencia = selectedCity;
    });
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
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 20),),
          Container(
            child: Center(
              child: MainMenu(defaultSelected: 2,),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                this.textField("DESCRIÇÃO", this._description, placeholder: "Descrição"),
                this.textField("VALOR", this._price, placeholder: "Valor"),
                FutureBuilder(
                    future: buscaConferencias(),
                    builder: (BuildContext context, AsyncSnapshot<List<ConferenciaSerializer>> snapshot){

                      if(snapshot.hasData){
                        for (ConferenciaSerializer item in snapshot.data) {
                          print(item.titulo);
                          _dropDownConferencia.add(new DropdownMenuItem(
                              value: item,
                              child: new Text(item.titulo)
                          ));
                        }

                        _currentConferencia = snapshot.data[0];

                        return new DropdownButton(
                          value: _currentConferencia,
                          items: _dropDownConferencia,
                          onChanged: changedDropDownItem,
                        );
                      }

                      return null;

                    }
                ),
                this.btnRegister()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
