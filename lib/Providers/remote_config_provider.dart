import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigProvider with ChangeNotifier {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _maskEmail = false;

  bool get maskEmail => _maskEmail;

  RemoteConfigProvider() {
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    try {
      await _remoteConfig.setDefaults({'mask_email': false});
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(hours: 1),
      ));

      await _fetchAndActivateConfig();

      _remoteConfig.onConfigUpdated.listen((_) {
        _fetchAndActivateConfig();
      });
    } catch (e) {
      print('Remote Config initialization error: $e');
    }
  }

  Future<void> _fetchAndActivateConfig() async {
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
      _maskEmail = _remoteConfig.getBool('mask_email');
      print('Updated mask email setting: $_maskEmail');
      notifyListeners();
    } catch (e) {
      print('Remote Config fetch error: $e');
    }
  }

  Future<void> refreshConfig() async {
    try {
      await _fetchAndActivateConfig();
    } catch (e) {
      print('Remote Config refresh error: $e');
    }
  }
}
