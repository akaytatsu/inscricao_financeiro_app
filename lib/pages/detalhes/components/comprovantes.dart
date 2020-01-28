import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/comprovante/comprovante.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/comprovante_serializer.dart';
import 'package:load/load.dart';

class ComprovantesTable extends StatefulWidget {

  final int despesaId;

  ComprovantesTable({Key key, @required this.despesaId}) : super(key: key);

  @override
  _ComprovantesTableState createState() => _ComprovantesTableState();
}

class _ComprovantesTableState extends State<ComprovantesTable> {
  RestApi api = RestApi();

  Future<List<ComprovanteSerializer>> buscaComprovantes() async{
    List<ComprovanteSerializer> comprovantes = [];

    var response = await api.getComprovantes(widget.despesaId);

    if(response['status'] != 200) return comprovantes;

    comprovantes = response['data'];

    return comprovantes;
  }

  deletaComprovante(int comprovanteId) async{

    await showLoadingDialog();

    await api.deletaComprovante(comprovanteId);

    hideLoadingDialog();

    setState(() {
      
    });
  }

  Widget comprovanteCard({Widget child}){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: child,
    );
  }

  Widget title() {
    Widget titulo = Container(
      decoration: BoxDecoration(
        color: Color(0xFFEEEEF7),
      ),
      height: 45,
      child: Center(
        child: Text("comprovantes",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B9BAF))),
      ),
    );

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFF9B9BAF),
              width: 1,
            )
        ),
        child: Column(
          children: <Widget>[
            titulo,
            
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder(
        future: buscaComprovantes(),
        builder: (context, snapshot){
            
          List<Widget> lista = [];

          lista.add(title());

          if(snapshot.data == null || snapshot.data.length == 0 || ! snapshot.hasData){
            lista.add(
              comprovanteCard(
                child: Center(
                  child: Text("Nenhum Comprovante informado"),
                )
              )
            );
          }
          else{
            for (var item in snapshot.data) {
              lista.add(
                comprovanteCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ComprovantePage(comprovante: item.comprovante,)));
                        },
                        child: Text("Ver Comprovante",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: (){
                          deletaComprovante(item.id);
                        },
                        child: Icon(
                          Icons.close
                        ),
                      )
                    ],
                  )
                )
              );
            }
          }

          return Column(
            children: lista,
          );
        },
      ),
    );
  }
}