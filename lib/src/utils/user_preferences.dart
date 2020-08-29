import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  /* Singleton */
  static final UserPreferences _instancie = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancie;
  }

  UserPreferences._internal();

  /*Shared preferences*/
  SharedPreferences _preferences;

  Future<SharedPreferences> initPrefs() async {
    this._preferences = await SharedPreferences.getInstance();
    return this._preferences;
  }

  //GET && SET

  get token {
    try {
      return _preferences.getString('s_token') ?? null;
    } catch (e) {
      return null;
    }
  }

  set token(String value) {
    _preferences.setString('s_token', value);
  }

  get isFirstTime {
    try {
      return _preferences.getBool('b_isFirstTime') ?? true;
    } catch (e) {
      return true;
    }
  }

  set isFirstTime(bool value){
    _preferences.setBool('b_isFirstTime', value);
  }
}
