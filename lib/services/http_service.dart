import 'dart:convert';
import 'package:github_page/models/repositories.dart';
import 'package:github_page/models/user_model.dart';
import 'package:http/http.dart';

class Network{
  static bool isTester = true;

  /// Base URL
  static String SERVER_DEVELOPMENT = 'api.github.com';
  static String SERVER_PRODUCTION = 'api.github.com';

  /// Server
  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /// Headers
  static Map<String, String> getHeaders() {
    Map<String,String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    };
    // {
    //   'Content-type': 'application/json; charset=UTF-8'
    // };
    return headers;
  }

  /// Http APIs
  static String API_GET = '/users/'; // {user}
  static String API_REPOS = '/starred'; // {user}

  /// Http Requests Methods
  static Future GET(String api, Map<String, String> params) async{
    var uri = Uri.http(getServer(),  api, params);  // http or https -> depends on api
    Response response = await get(uri, headers: getHeaders());
    if(response.statusCode == 200){
      return response.body;
    }
    return response.statusCode;
  }

  /// Http Parameters
  static Map<String, String> paramsEmpty(){
    Map<String, String> params = {};
    return params;
  }

  /// Http Parsing
  // #get user
  static User parseUser(String response){
    dynamic json = jsonDecode(response);
    User data = User.fromJson(json);
    return data;
  }
  // #get repos
  // static List<Repositories> parseRepos1(String response){
  //   List<Repositories> data = List<Repositories>.from(json.decode(response).map((x) => Repositories.fromJson(x)));
  //   return data;
  // }
}