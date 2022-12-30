import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class PrimaryProvider with ChangeNotifier {
  PrimaryProvider() {
    print('PrimaryProvider');
  }
  String version = '', buildNumber = '', userId = '';
  bool isConnected = false;
  StreamSubscription<ConnectivityResult>? connectivityStream;

  bool get isUserLogin => userId.isNotEmpty;

  Future<void> updateCustomerId() async {
    final preferences = await SharedPreferences.getInstance();
    userId = preferences.getString(SP.userId.name) ?? '';
    notifyListeners();
  }

  Future<void> updatePackageInfo() => PackageInfo.fromPlatform().then((info) {
        version = info.version.substring(0, 4);
        buildNumber = info.buildNumber;
        connectivityListener();
        notifyListeners();
      });

  void connectivityListener() {
    connectivityStream = Connectivity().onConnectivityChanged.listen((result) {
      isConnected = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<void> clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<void> dispose() async {
    print('PrimaryProvider dispose');
    await connectivityStream?.cancel();
    return super.dispose();
  }
}
