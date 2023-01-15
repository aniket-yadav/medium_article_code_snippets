class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  static SharedPreferences _preferences;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> login(String email, String token, String userName) async {
    await _preferences.setString('email', email);
    await _preferences.setString('token', token);
    await _preferences.setString('userName', userName);
  }

  Future<void> logout() async {
    await _preferences.clear();
  }

  Future<Map<String, String>> getUserDetails() async {
    final String email = _preferences.getString('email');
    final String token = _preferences.getString('token');
    final String userName = _preferences.getString('userName');
    return {'email': email, 'token': token, 'userName': userName};
  }

  Future<bool> isLoggedIn() async {
    final String email = _preferences.getString('email');
    final String token = _preferences.getString('token');
    return email != null && token != null;
  }

}
