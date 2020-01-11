import 'dart:convert';
import 'dart:io';
import 'package:iec_despesas_app/services/serializers/account_serializers.dart';
import 'package:iec_despesas_app/services/serializers/token_serializer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class RestApi {
  String urlBase = "http://192.168.25.222:8080/";
  // String urlBase = "https://app.englishingroup.com/";

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

  Future<Map<String, dynamic>> createAccount(String name, String email, String password, String passwordConfirm, {context}) async {
    final url = 'api/account/create_account/';
    final response = await this._post(url, params: {
      "name": name,
      "email": email,
	    "password": password,
	    "password_confirm": passwordConfirm,
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
        error: CreateAccountErrorsSerializer.fromJson(json.decode(response.body)));
    }else{
      return this.responseObject(
        response.statusCode, 
        error: json.decode(response.body) );
    }
  }

  Future<Map<String, dynamic>> uploadImagePerfil(File image, context) async {
    final url = this.urlBase + 'api/account_image/';

    String name = path.basename(image.path);

    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.files.add(new http.MultipartFile.fromBytes(
    'image',
    await image.readAsBytes(),
    filename: name));
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getBool('logged') == true){
      request.headers['Authorization'] = 'JWT ' + prefs.getString('jwt');
    }

    var response = await request.send();
 
    return this.responseObject(
      response.statusCode
    );
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("jwt");
    prefs.remove("logged");

    return true;

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


}