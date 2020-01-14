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

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<ConferenciaSerializer>> _dropDownConferencia = new List();
  ConferenciaSerializer _currentConferencia;

  RestApi _api = RestApi();

  buscaConferencias() async{

    var response = await _api.getConferencias();
    List<ConferenciaSerializer> conferencias = [];

    if( response['status'] == 200 ){
      conferencias = response['data'];
      _currentConferencia = conferencias[0];
    }

  }

  textField(label, TextEditingController controller, {String placeholder = "", bool isNumber = false}) {
    final labelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4080FE),
    );

    TextInputType keyboard;

    if(isNumber){
      keyboard = TextInputType.numberWithOptions(
        decimal: true,
        signed: false
      );
    }

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
          TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: placeholder),
            keyboardType: keyboard,
            validator: (value){
              if (value.isEmpty) {
                return 'Valor não informado';
              }
              return null;
            },
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

  double parseValue(String value){

    return double.parse(value.replaceAll(".", "").replaceAll(",", "."));

  }

  actionRegister() async {

    if (_formKey.currentState.validate()) {

      await buscaConferencias();

      Map<String, dynamic> response =
      await _api.newSolicitation(_description.text, this.parseValue(_price.text), _currentConferencia.id, context: context);

      if (response['status'] != 200) {
        return this.errorRegisterSolicitationDialog();
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntermdiareScreen()));

    }
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

  void changedDropDownItem(ConferenciaSerializer selectedConferencia) {
    if(_dropDownConferencia.isEmpty || _dropDownConferencia.length == 1){
      return;
    }

    setState(() {
      _currentConferencia = selectedConferencia;
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
      body: Form(
        key: _formKey,
        child: ListView(
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
                  this.textField("Justificativa", this._description, placeholder: "Descrição"),
                  this.textField("Valor", this._price, placeholder: "Valor", isNumber: true),
                  this.btnRegister()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
