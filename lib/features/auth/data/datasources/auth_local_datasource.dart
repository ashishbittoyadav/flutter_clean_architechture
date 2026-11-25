import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);

  Future<String?> getCachedToken();

  Future<void> clearToken();

  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getCachedUser();
}

class AuthLocalSecureSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  final LocalAuthentication localAuthentication;
  static const String cachedToken = "CACHED_TOKEN";
  static const String cachedUser = "CACHED_USER";

  AuthLocalSecureSourceImpl({
    required this.flutterSecureStorage,
    required this.localAuthentication,
  });

  @override
  Future<void> cacheToken(String token) async {
    await flutterSecureStorage.write(key: cachedToken, value: token);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await flutterSecureStorage.write(key: cachedUser, value: json.encode(user));
  }

  Future<bool> localAuthenticate() async {
    return await localAuthentication
        .authenticate(
          localizedReason: 'Please authenticate before accessing the data',
          persistAcrossBackgrounding: true,
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Authentication Required',
              cancelButton: 'Cancel',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancel',
              localizedFallbackTitle: 'Use Passcode',
            ),
          ],
          biometricOnly: false,
        );
  }

  @override
  Future<void> clearToken() async {
    // final authenticated = await localAuthenticate();
    // if (authenticated) {
      await flutterSecureStorage.delete(key: cachedUser);
      await flutterSecureStorage.delete(key: cachedToken);
    // } else {
    //   null;
    // }
  }

  @override
  Future<String?> getCachedToken() async {
    // final authenticated = await localAuthenticate();
    // if (authenticated) {
      return await flutterSecureStorage.read(key: cachedToken);
    // } else {
    //   return null;
    // }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final authenticated = await localAuthenticate();
    if (authenticated) {
      return await flutterSecureStorage
          .read(key: cachedUser)
          .then(
            (value) =>
                value == null ? null : UserModel.fromJson(json.decode(value)),
          );
    } else {
      return null;
    }
  }
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedToken = "CACHED_TOKEN";
  static const String cachedUser = "CACHED_USER";

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(cachedToken, token);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(cachedUser, json.encode(user.toJson()));
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(cachedToken);
    await sharedPreferences.remove(cachedUser);
  }

  @override
  Future<String?> getCachedToken() async {
    return sharedPreferences.getString(cachedToken);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUser);

    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
