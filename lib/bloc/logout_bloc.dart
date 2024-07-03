import 'package:tokoku/helpers/user_info.dart';

class LogoutBloc{
  static Future logout() async {
    await UserInfo().logout();
  }
}
