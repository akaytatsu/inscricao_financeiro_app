import 'package:iec_despesas_app/provider/user_provider.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabbedHomePage extends StatefulWidget {
  TabbedHomePage({Key key}) : super(key: key);

  @override
  _TabbedHomePageState createState() => _TabbedHomePageState();
}

class _TabbedHomePageState extends State<TabbedHomePage> {
  UserProvider currentUser;

  @override
  void initState() {
    super.initState();
    // this.autoLogin();
  }

  autoLogin() async {
    final bool isLoggedUserProvider =
        Provider.of<UserProvider>(context, listen: false).isLogged;
    final RestApi _rest = RestApi();
    final bool isLoggedStore = await _rest.isLogged();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (isLoggedUserProvider == false && isLoggedStore == true) {
      Map<String, dynamic> response = await _rest.me();

      if (response['status'] == 200) {
        userProvider.setCurrentUser = response['data'];
      }
    }
  }

  labelTabBar(label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF797979), fontSize: 14),
      ),
    );
  }

  goToCreateValuePage() {
    
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserProvider>(context);

    Widget floatbutton = FloatingActionButton(
      onPressed: () {
        goToCreateValuePage();
      },
      child: Icon(Icons.add),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: floatbutton,
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xFFF8FFFF),
          bottom: TabBar(
            tabs: [
              labelTabBar("Solicitar Valor"),
              labelTabBar("Despesas / Comprovação"),
            ],
          ),
          title: Text("Despesas Conferencia IEC"),
        ),
        body: TabBarView(
          children: <Widget>[
            Text("Pagina 1"),
            Text("Pagina 2")
          ],
        ),
      ),
    );
  }
}
