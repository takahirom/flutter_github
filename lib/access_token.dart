library github_flutter.access_token;

import 'dart:async';

import 'package:github_flutter/oauth/flutter_auth.dart';
import 'package:github_flutter/oauth/model/config.dart';
import 'package:github_flutter/oauth/oauth.dart';
import 'package:github_flutter/oauth/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessToken {
  static AccessToken _instance;

  static AccessToken getInstance() {
    if (_instance == null) {
      _instance = new AccessToken();
    }
    return _instance;
  }

  Future<String> getAccessToken() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("access_token");
  }

  Future<String> createAccessToken() async {
    Map<String, String> customParameters = {
      "scope": "public_repo,notifications"
    };
    final OAuth flutterOAuth = new FlutterOAuth(new Config(
        "https://github.com/login/oauth/authorize",
        "https://github.com/login/oauth/access_token",
        "",
        "",
        "http://localhost:8080",
        "code",
        parameters: customParameters));
    Token token = await flutterOAuth.performAuthorization();
    var accessToken = token.accessToken;
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", accessToken);
    return accessToken;
  }

  Future<String> getOrCreate() async {
    return getAccessToken().then((token) async {
      if (token == null) {
        token = await AccessToken.getInstance().createAccessToken();
      }
      return token;
    });
  }
}
