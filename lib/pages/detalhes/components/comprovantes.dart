import 'package:flutter/material.dart';
import 'package:iec_despesas_app/pages/comprovante/comprovante.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/comprovante_serializer.dart';
import 'package:load/load.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ComprovantesTable extends StatefulWidget {

  final int despesaId;
  final bool canDelete;

  ComprovantesTable({Key key, @required this.despesaId, this.canDelete = true}) : super(key: key);

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

          if(snapshot.connectionState == ConnectionState.waiting){
            lista.add(
              comprovanteCard(
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: LoadingIndicator(
                      indicatorType: Indicator.circleStrokeSpin,
                    ),
                  ),
                )
              )
            );
          }

          else if(snapshot.data.length == 0){
            lista.add(
              comprovanteCard(
                child: Center(
                  child: Text("Nenhum Comprovante informado"),
                )
              )
            );
          }
          else{
            for (ComprovanteSerializer item in snapshot.data) {

              Widget deleteOption;

              if(widget.canDelete == true){
                deleteOption = GestureDetector(
                  onTap: (){
                    deletaComprovante(item.id);
                  },
                  child: Icon(
                    Icons.close
                  ),
                );
              }else{
                deleteOption = Container();
              }

              lista.add(
                comprovanteCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          if ( item.isImage ){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ComprovantePage(comprovante: item.comprovante,)));
                          }
                        },
                        child: Text("Ver Comprovante",
                          style: TextStyle(
                              color: item.isImage == true ? Colors.blue : Colors.black ,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      ),
                      deleteOption,
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