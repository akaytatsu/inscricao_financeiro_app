import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/home/home.dart';
import 'package:iec_despesas_app/pages/login/login_page.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import './provider/user_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LoadingProvider(child: MainPage(),));
}

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: MaterialApp(
        home: IntermdiareScreen(),
      )
    );
  }
}

class IntermdiareScreen extends StatefulWidget {
  IntermdiareScreen({Key key}) : super(key: key);

  @override
  _IntermdiareScreenState createState() => _IntermdiareScreenState();
}

class _IntermdiareScreenState extends State<IntermdiareScreen> {

  @override
  void initState() {
    super.initState();
    redirect();
  }

  redirect() async{

    RestApi api = RestApi();

    bool logged = await api.isLogged();

    if(logged){
      Navigator.push(context, MaterialPageRoute(builder: (_) => MainHomePage()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
    );
  }
}