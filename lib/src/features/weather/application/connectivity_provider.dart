import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  ConnectivityProvider() {
    _checkInitialConnection();
    _listenToConnectionChanges();
  }

  void _checkInitialConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _listenToConnectionChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _hasConnection = result != ConnectivityResult.none;
    notifyListeners();
  }
}
