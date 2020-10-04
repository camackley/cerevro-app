import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:http/http.dart' as http;

class GeneralServiceResponse{
  String error;
  dynamic body;

  GeneralServiceResponse.fromJson(Map<String, dynamic> data){
    error = data["error"];
    body = data["body"];
  }
}

  const URL_SERVICE = "https://us-central1-cerevro-cf50f.cloudfunctions.net/api/";

  Future<GeneralServiceResponse> postService(String path, Map<String, dynamic> credenciales) async {
  try {
    final response = await http.post(URL_SERVICE+ path,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(credenciales));

    if (response.statusCode == 200) {
        GeneralServiceResponse res = GeneralServiceResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        return res;
    } else {
      throw Exception("Failed to post service $path");
    }
  } catch (e) {
    throw Exception("Failed to post service $e");
  }
}

Future<GeneralServiceResponse> getService(String path) async {
  try {
    final response = await http.get(URL_SERVICE+ path,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
        GeneralServiceResponse res = GeneralServiceResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        return res;
    } else {
      throw Exception("Failed to post service $path");
    }
  } catch (e) {
    throw Exception("Failed to post service $e");
  }
}