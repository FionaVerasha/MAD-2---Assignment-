import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class NetworkStatusPage extends StatefulWidget {
  const NetworkStatusPage({super.key});

  @override
  State<NetworkStatusPage> createState() => _NetworkStatusPageState();
}

class _NetworkStatusPageState extends State<NetworkStatusPage> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  bool get _isOnline => !_connectionStatus.contains(ConnectivityResult.none);

  String get _connectionType {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) return 'WiFi';
    if (_connectionStatus.contains(ConnectivityResult.mobile))
      return 'Mobile Data';
    if (_connectionStatus.contains(ConnectivityResult.ethernet))
      return 'Ethernet';
    if (_connectionStatus.contains(ConnectivityResult.vpn)) return 'VPN';
    if (_connectionStatus.contains(ConnectivityResult.bluetooth))
      return 'Bluetooth';
    if (_connectionStatus.contains(ConnectivityResult.other)) return 'Other';
    return 'None';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Network Status",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 80,
                    color: _isOnline ? Colors.green[700] : Colors.red[700],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _isOnline ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Connection Type: $_connectionType",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Changes are detected automatically.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
