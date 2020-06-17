import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences _preferences;

  Future<SharedPreferences> initPrefs() async {
    this._preferences = await SharedPreferences.getInstance();
    return this._preferences;
  }

  //GET && SET

  get user {
    return _preferences.getString('s_usuario') ?? 1;
  }

  set user(String value) {
    _preferences.setString('s_usuario', value);
  }

  get password {
    return _preferences.getString('s_password') ?? 1;
  }

  set password(String value) {
    _preferences.setString('s_password', value);
  }

  get isLogin {
    try {
      return _preferences.getBool('b_isLogin') ?? false;
    } catch (e) {
      return false;
    }
  }

  set isLogin(bool value) {
    _preferences.setBool('b_isLogin', value);
  }
}
