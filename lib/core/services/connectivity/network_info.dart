import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo._();
  static final NetworkInfo instance = NetworkInfo._();

  final Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    final res = await _connectivity.checkConnectivity();
    return res != ConnectivityResult.none;
  }
}
