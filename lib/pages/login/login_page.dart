import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/create_account/create_account_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  // RestApi _api = RestApi();

  title() {
    final TextStyle titleStyle = TextStyle(
      fontSize: 40,
      color: Color(0xFF4080FE),
    );

    return Text(
      "Login",
      style: titleStyle,
    );
  }

  textField(label, TextEditingController controller,
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
          )
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

  btnSignIn() {
    return this.btn("Entrar", 0xFF4080FE, () {
      this.actionLogin();
    });
  }

  errorAccountLoginDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              // title: Text("ops..."),
              content: Text(
                "Conta não encontrada.",
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

  actionLogin() async {
    // Map<String, dynamic> response =
        // await _api.login(_email.text, _password.text, context: context);

    // if (response['status'] != 200) {
    //   return this.errorAccountLoginDialog();
    // }

    // Provider.of<UserProvider>(context, listen: false).setCurrentUser =
    //     response['data'];

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => TabbedHomePage()));
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
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => CreateAccountPage()));
          },
          child: Text(
            "Não possui conta? Crie uma clicando aqui.",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // LoggedUserPhoto(),
              this.title(),
              this.textField("EMAIL", this._email, placeholder: "Email"),
              this.textField("PASSWORD", this._password,
                  placeholder: "Password", isPassword: true),
              this.btnSignIn(),
              this.createAccount(),
            ],
          ),
        ),
      ),
    );
  }
}
