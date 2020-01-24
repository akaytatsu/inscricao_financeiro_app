import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/conferencia_serializer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';

import '../../main.dart';

class NovaSolicitacaoPage extends StatefulWidget {
  NovaSolicitacaoPage({Key key}) : super(key: key);

  @override
  _NovaSolicitacaoPageState createState() => _NovaSolicitacaoPageState();
}

class _NovaSolicitacaoPageState extends State<NovaSolicitacaoPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

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

  fieldContainer({Widget child}) {

    return Container(
      margin: EdgeInsets.only(top: 20),
      constraints: BoxConstraints(maxWidth: 350),
      child: child
    );
  }

  btnRegister() {
    // return this.btn("Cadastrar", 0xFF4080FE, () {
    //   actionRegister();
    // });

    return GestureDetector(
      onTap: () {
        actionRegister();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF4080FE),
        ),
        child: Center(
          child: Text(
            "Cadastrar",
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

  double parseValue(String value){

    return double.parse(value.replaceAll(".", "").replaceAll(",", "."));

  }

  actionRegister() async {

    if (_fbKey.currentState.saveAndValidate()) {

      await showLoadingDialog();

      await buscaConferencias();

      double value = NumberFormat(("###,##")).parse( _fbKey.currentState.value['value'] ).toDouble() / 100;
      String justify = _fbKey.currentState.value['value'];

      Map<String, dynamic> response =
      await _api.newSolicitation(justify, value, _currentConferencia.id, context: context);

      hideLoadingDialog();

      if (response['status'] != 200) {
        return this.errorRegisterSolicitationDialog();
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntermdiareScreen()));

    }
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

  Widget formValue(){

    InputDecoration decorator = InputDecoration(
      labelText: 'Valor Solicitado',
      
    );

    TextStyle textStyle = TextStyle(
      color: Colors.black
    );

    return FormBuilderTextField(
      inputFormatters: [
        NumericDoubleTextFormatter()
      ],
      attribute: 'value',
      style: textStyle,
      decoration: decorator,
      keyboardType: TextInputType.number,
      
      validators: [
        FormBuilderValidators.required()
      ],
    );
  }

  Widget formJustify(){

    InputDecoration decorator = InputDecoration(
      labelText: 'Justificativa',
      
    );

    TextStyle textStyle = TextStyle(
      color: Colors.black
    );

    return FormBuilderTextField(
      attribute: 'justify',
      style: textStyle,
      decoration: decorator,      
      validators: [
        FormBuilderValidators.required()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Finanças Conferência IEC",
        ),
      ),
      body: FormBuilder(
        key: _fbKey,
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  fieldContainer(child: formJustify()),
                  fieldContainer(child: formValue()),
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

class NumericDoubleTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final f = new NumberFormat("#,###,##");
      int num = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(num);
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}