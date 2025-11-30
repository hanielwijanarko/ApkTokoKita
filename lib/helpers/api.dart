import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';
import 'app_exception.dart';

class Api{
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try{
      final response = await http.post(Uri.parse(url),
      body: data,
      headers:{
        HttpHeaders.authorizationHeader: "Bearer $token"
      }
      );
      responseJson = _returnResponse(response);
    } on SocketException{
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}

Future<dynamic> put(dynamic url, dynamic data) async {
  var token = await UserInfo().getToken();
  var responseJson;
  try{
    final response = await http.put(Uri.parse(url), body: data, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    }
    );
    responseJson = _returnResponse(response);
  } on SocketException{
    throw FetchDataException('No Internet connection');
  }
  return responseJson;
}

Future<dynamic> delete(dynamic url) async {
  var token = await UserInfo().getToken();
  var responseJson;
  try{
    final response = await http.delete(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }
    );
    responseJson = _returnResponse(response);
  } on SocketException{
    throw FetchDataException('No Internet connection');
  }
  return responseJson;
}

dynamic_returnResponse(http.Response response){
  switch(response.statusCode){
    case 200:
      var responseJson = response.body;
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException('Error occured with code : ${response.statusCode}');
  }
}