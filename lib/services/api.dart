import 'dart:convert';
import 'package:iec_despesas_app/services/serializers/account_serializers.dart';
import 'package:iec_despesas_app/services/serializers/conferencia_serializer.dart';
import 'package:iec_despesas_app/services/serializers/create_account_error.dart';
import 'package:iec_despesas_app/services/serializers/solicitacao_serializer.dart';
import 'package:iec_despesas_app/services/serializers/token_serializer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RestApi {
  // String urlBase = "http://192.168.25.222:9000/";
  String urlBase = "http://inscricao.igrejaemcontagem.com.br/";

  Future<Map<String, String>> _headers({Map<String, String> headers, logged = true}) async{
    if(headers == null){
      headers = {
        'Content-Type': 'application/json'
      };
    }else{
      headers['Content-Type'] = 'application/json';
    }

    if(logged == true){
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if(prefs.getBool('logged') == true){
        headers['Authorization'] = 'JWT ' + prefs.getString('jwt');
      }
    }

    return headers;
  }

  _post(String url, {Map params, Map<String, String> headers, bool logged = true}) async {
    url = this.urlBase + url;

    headers = await _headers(headers: headers, logged: logged);

    return http.post(url, body: json.encode(params), headers: headers);
  }

  _put(String url, {Map params, Map<String, String> headers, bool logged = true}) async {
    url = this.urlBase + url;

    headers = await _headers(headers: headers, logged: logged);

    return http.put(url, body: json.encode(params), headers: headers);
  }

  _get(String url, {Map<String, String> headers, bool logged = true}) async {
    url = this.urlBase + url;

    headers = await _headers(headers: headers, logged: logged);

    return http.get(url, headers: headers);
  }

  Map<String, dynamic> responseObject(status, {data, errors, error}){

    Map<String, dynamic> response = {};

    response['status'] = status;

    if(data != null)
      response['data'] = data;
    
    if(errors != null)
      response['errors'] = errors;
    
    if(error != null)
      response['error'] = error;
      
    return response;
  }

  Future<Map<String, dynamic>> me() async {
    final url = 'api/account/me';
    final response = await this._get(url, logged: true);
 
    if(response.statusCode == 200){
      return this.responseObject(
        response.statusCode, 
        data: AccountSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
        response.statusCode, 
        error: response.body );
    }
  }

  Future<Map<String, dynamic>> userInfo(int userId) async {
    final url = 'api/account/user_info/';
    final response = await this._post(url, params: { "user_id": userId }, logged: true);
 
    if(response.statusCode == 200){
      return this.responseObject(
        response.statusCode, 
        data: AccountSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
        response.statusCode, 
        error: response.body );
    }
  }

  Future<Map<String, dynamic>> login(String email, String password, {context}) async {
    final url = 'api/token/auth';
    final response = await this._post(url, params: {
      "email": email,
	    "password": password
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
 
    if(response.statusCode == 200){

      AuthTokenSerializer serializer = AuthTokenSerializer.fromJson(json.decode(response.body));

      prefs.setString("jwt", serializer.token);
      prefs.setBool("logged", true);

      Map<String, dynamic> responseMe = await this.me();
      AccountSerializer memberSerializer = responseMe['data'];

      return this.responseObject(
        response.statusCode, 
        data: memberSerializer );
    }else{

      prefs.remove("jwt");
      prefs.remove("logged");

      return this.responseObject(
        response.statusCode, 
        error: response.body );
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 
    if(await this.isLogged()){
      prefs.remove("jwt");
      prefs.remove("logged");
    }
  }

  Future<Map<String, dynamic>> createAccount(String name, String email, String password, String passwordConfirm, String telefone, {context}) async {
    final url = 'api/account/create_account/';
    final response = await this._post(url, params: {
      "name": name,
      "email": email,
	    "password": password,
	    "password_confirm": passwordConfirm,
	    "telefone": telefone,
    });
 
    if(response.statusCode == 200){

      await this.login(email, password, context: context);

      Map<String, dynamic> responseMe = await this.me();
      AccountSerializer memberSerializer = responseMe['data'];

      return this.responseObject(
        response.statusCode, 
        data: memberSerializer );
    }else if(response.statusCode == 400){
      return this.responseObject(
        response.statusCode, 
        error: CreateAccountErrorSerializer.fromJson(json.decode(response.body)));
    }else{
      return this.responseObject(
        response.statusCode, 
        error: json.decode(response.body) );
    }
  }

  Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 
    try{
      bool logged = prefs.getBool("logged");
      
      if( logged == true ){
        return true;
      }
    }catch(err){

    }

    return false;
  }

  Future<Map<String, dynamic>> getSolicitacoes() async {
    final url = 'api/financeiro/solicitacoes';
    final response = await this._get(url, logged: true);
 
    if(response.statusCode == 200){
      return this.responseObject(
        response.statusCode, 
        data: ( json.decode(response.body) as List).map((data) => SolicitacaoSerializer.fromJson(data)).toList() );
    }else{
      return this.responseObject(
        response.statusCode, 
        error: response.body );
    }
  }

  Future<Map<String, dynamic>> getConferencias() async {
    final url = 'api/inscricao/conferencias';
    final response = await this._get(url, logged: true);

    if(response.statusCode == 200){
      return this.responseObject(
          response.statusCode,
          data: ( json.decode(response.body) as List).map((data) => ConferenciaSerializer.fromJson(data)).toList() );
    }else{
      return this.responseObject(
          response.statusCode,
          error: response.body );
    }
  }

  Future<Map<String, dynamic>> newSolicitation(String description, double price, int idConferencia, {context}) async {

    final url = 'api/financeiro/nova_solicitacao/';
    final response = await this._post(url, params: {
      "conferencia": idConferencia,
      "valor": price,
      "justificativa": description
    });

    if(response.statusCode == 200){
      return this.responseObject(
          response.statusCode,
          data: SolicitacaoSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
          response.statusCode,
          error: response.body );
    }
  }

  Future<Map<String, dynamic>> approve(int solicitationId, {context}) async {
    final url = 'api/financeiro/aprova_solicitacao/';
    final response = await this._put(url, params: {
      "pk": solicitationId
    });

    if(response.statusCode == 200){
      return this.responseObject(
          response.statusCode,
          data: SolicitacaoSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
          response.statusCode,
          error: response.body );
    }

  }

  Future<Map<String, dynamic>> confirmTransferMoney(int solicitationId, {context}) async {
    final url = 'api/financeiro/confirma_repasse_solicitacao/';
    final response = await this._put(url, params: {
      "pk": solicitationId
    });

    if(response.statusCode == 200){
      return this.responseObject(
          response.statusCode,
          data: SolicitacaoSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
          response.statusCode,
          error: response.body );
    }

  }

  Future<Map<String, dynamic>> confirmProof(int solicitationId, {context}) async {
    final url = 'api/financeiro/confirma_aprovacao_solicitacao/';
    final response = await this._put(url, params: {
      "pk": solicitationId
    });

    if(response.statusCode == 200){
      return this.responseObject(
          response.statusCode,
          data: SolicitacaoSerializer.fromJson(json.decode(response.body)) );
    }else{
      return this.responseObject(
          response.statusCode,
          error: response.body );
    }

  }


}