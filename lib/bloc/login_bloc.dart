import 'dart:convert';

import 'package:tokoku/helpers/api.dart';
import 'package:tokoku/helpers/api_url.dart';
import 'package:tokoku/model/login.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;

    var body = {"email": email, "password": password};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    print(jsonObj.toString());

    return Login.fromJson(jsonObj);
  }
}
