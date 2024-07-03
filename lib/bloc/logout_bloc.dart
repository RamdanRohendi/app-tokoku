import 'dart:convert';

import 'package:tokoku/helpers/api.dart';
import 'package:tokoku/helpers/user_info.dart';
import 'package:tokoku/helpers/api_url.dart';

class LogoutBloc{
  static Future logout() async {
    String apiUrl = ApiUrl.logout;
    int? id = await UserInfo().getUserID();

    var body = {
      "id": id.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    await UserInfo().logout();

    return jsonObj['status'];
  }
}
