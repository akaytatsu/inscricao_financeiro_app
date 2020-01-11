import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/login/login_page.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _nameError = TextEditingController();
  final _emailError = TextEditingController();
  final _telefoneError = TextEditingController();
  final _passwordError = TextEditingController();
  final _confirmPasswordError = TextEditingController();

  // RestApi _api = RestApi();

  title() {
    final TextStyle titleStyle = TextStyle(
      fontSize: 40,
      color: Color(0xFF4080FE),
    );

    return Text(
      "Criar Conta",
      style: titleStyle,
    );
  }

  errorField(String error) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(top: 5),
      child: Text(
        error,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  textField(label, TextEditingController controller,
      TextEditingController errorController,
      {bool isPassword = false, String placeholder = ""}) {
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
            obscureText: isPassword,
            decoration: InputDecoration(hintText: placeholder),
          ),
          errorController.text != "" && errorController.text != null
              ? errorField(errorController.text)
              : Container()
        ],
      ),
    );
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

  btnSignUp() {
    return this.btn("Criar Conta", 0xFF4080FE, () {
      this.actionNewAccount();
    });
  }

  errorClean() {
    setState(() {
      _nameError.text = "";
      _emailError.text = "";
      _telefoneError.text = "";
      _passwordError.text = "";
      _confirmPasswordError.text = "";
    });
  }

  cleanFieldsErrors(){
    setState(() {
      _nameError.text = "";
      _emailError.text = "";
      _telefoneError.text = "";
      _passwordError.text = "";
      _confirmPasswordError.text = "";
    });
  }

  actionNewAccount() async {
    
    // Map<String, dynamic> response = await _api.createAccount(
    //     _name.text, _email.text, _password.text, _confirmPassword.text,
    //     context: context);

    cleanFieldsErrors();

    // if (response['status'] == 400) {
    //   CreateAccountErrorsSerializer errors = response['error'];
    //   setState(() {
        
    //     if (errors.name != null) 
    //       if (errors.name.length > 0)
    //         _nameError.text = errors.name[0];

    //     if (errors.email != null) 
    //       if (errors.email.length > 0)
    //         _emailError.text = errors.email[0];

    //     if (errors.password != null) 
    //       if (errors.password.length > 0)
    //         _passwordError.text = errors.password[0];

    //     if (errors.passwordConfirm != null) 
    //       if (errors.passwordConfirm.length > 0) 
    //         _confirmPasswordError.text = errors.passwordConfirm[0];

    //     if (errors.nonFieldErrors != null) 
    //       if (errors.nonFieldErrors.length > 0) 
    //         _passwordError.text = errors.nonFieldErrors[0];

    //   });
    // } else if(response['status'] == 200){
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => TabbedHomePage()));  
    // }

  }

  createAccount() {
    final textStyle = TextStyle(
      fontSize: 19,
    );

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
          child: Text(
            "Possui conta? Faça login clicando aqui.",
            style: textStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // LoggedUserPhoto(),
                  this.title(),
                  this.textField("NOME", _name, _nameError,
                      placeholder: "Seu Nome"),
                  this.textField("EMAIL", _email, _emailError,
                      placeholder: "Email"),
                  this.textField("TELEFONE", _telefone, _telefoneError,
                      placeholder: "Telefone"),
                  this.textField("PASSWORD", _password, _passwordError,
                      placeholder: "Password", isPassword: true),
                  this.textField("CONFIRMAR PASSWORD", _confirmPassword,
                      _confirmPasswordError,
                      placeholder: "Confirmar Password", isPassword: true),
                  this.btnSignUp(),
                  this.createAccount(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
