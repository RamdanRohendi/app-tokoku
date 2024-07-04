import 'dart:convert';

import 'package:tokoku/helpers/api.dart';
import 'package:tokoku/helpers/api_url.dart';
import 'package:tokoku/model/profile.dart';

class ProfileBloc {
  static Future<Profile> getProfile() async{
    String apiUrl = ApiUrl.profile;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    return Profile.fromJson(jsonObj);
  }

  static Future<bool> updateProfile({required Profile profile}) async {
    String apiUrl = ApiUrl.profile;

    var body = {
      "nama": profile.nama,
      "email": profile.email,
      "current_password": profile.currentPassword,
      "new_password": profile.newPassword,
      "confirm_password": profile.confirmPassword,
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
  
    return jsonObj['status'];
  }

  static Future<bool> deleteAkun() async {
    String apiUrl = ApiUrl.profile;

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }
}
