import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iec_despesas_app/components/solicitacao_box.dart';
import 'package:flutter/material.dart';
import 'package:iec_despesas_app/main.dart';
import 'package:iec_despesas_app/pages/detalhes/detalhe.dart';
import 'package:iec_despesas_app/pages/nova_solicitacao/nova_solicitacao.dart';
import 'package:iec_despesas_app/services/api.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  RestApi api = RestApi();

  Future<List<SolicitacaoSerializer>> buscaSolicitacoes() async{

    var response = await api.getSolicitacoes();
    List<SolicitacaoSerializer> solicitacoes = [];

    if( response['status'] == 200 ){
      solicitacoes = response['data'];
    }

    return solicitacoes;

  }

  void _handleNotificationReceived(OSNotificationOpenedResult result) {

    int requestId;

    try {
      requestId = result.notification.payload.additionalData['id'];
    } catch (e) {
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhePage(id: requestId,)));
  }

  void initOneSignal() async{
    
    OneSignal.shared.init(
      "804ea63b-9ec2-4fe8-b65a-e4742b583777",
      iOSSettings: {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.inAppLaunchUrl: true
      }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationOpenedHandler(_handleNotificationReceived);

    this.updateUserId();
  }

  updateUserId() async{
    RestApi api = RestApi();

    String oneSignalID = await this.getToken();

    await api.updateOneSignalID(oneSignalID);
  }

  Future<String> getToken() async{
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    if (status.subscriptionStatus.subscribed){
      return status.subscriptionStatus.userId;
    }

    return "";
  }

  @override
  void initState() { 
    super.initState();
    this.initOneSignal();
  }

  Widget solicitacoes(){

    return FutureBuilder(
        future: buscaSolicitacoes(),
        builder: (BuildContext context, AsyncSnapshot<List<SolicitacaoSerializer>> snapshot){

          List<Widget> solicitacoesWidgets = [];

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin,
                ),
              ),
            );
          }
          else if(!snapshot.hasData || snapshot.data.length == 0){

            return Center(
              child: Text("Nenhuma solicitação encontrada", style: TextStyle(
                fontSize: 18
              )),
            );

          }
          else{

            for (SolicitacaoSerializer item in snapshot.data) {
              solicitacoesWidgets.add(
                SolicitacaoBox(
                  item: item,
                )
              );
            }

          }

          solicitacoesWidgets.add(
            Padding(padding: EdgeInsets.only(top: 100),)
          );

          return ListView(
            children: solicitacoesWidgets,
          );

        }
      );
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              RestApi().logout();
              Navigator.push(context, MaterialPageRoute(builder: (_) => IntermdiareScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NovaSolicitacaoPage()))
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            onTap: () => {
              setState(() {})
            }
          ),
          // SpeedDialChild(
          //   child: Icon(Icons.exit_to_app),
          //   backgroundColor: Colors.red,
          //   onTap: () async {
          //     RestApi().logout();
          //     Navigator.push(context, MaterialPageRoute(builder: (_) => IntermdiareScreen()));
          //   }
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10),),
          Expanded(
            child: solicitacoes(),
          ),
        ],
      )
    );
  }
}

