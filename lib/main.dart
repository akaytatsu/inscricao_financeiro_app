import 'package:iec_despesas_app/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/user_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: MaterialApp(
        home: new MainHomePage(),
      )
    );
  }
}
