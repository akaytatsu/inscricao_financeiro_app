import 'package:flutter/material.dart';

class ComprovantePage extends StatelessWidget {

  final String comprovante;

  const ComprovantePage({Key key, @required this.comprovante}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          comprovante
        ),
      ),
    );
  }
}