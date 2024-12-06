import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:mnm_vendor/screens/dashboard_page.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _connectivity = Connectivity();

  //   // Initialize the stream and listen for changes
  //   _connectivityStream =
  //       _connectivity.onConnectivityChanged as Stream<ConnectivityResult>;
  //   _subscription = _connectivityStream.listen((ConnectivityResult result) {
  //     // Check if there's a connection
  //     if (result != ConnectivityResult.none) {
  //       // Navigate back if there is internet
  //       Navigator.of(context).pop();
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      // Handle cases where `event` is of type List<ConnectivityResult>
      // Get the first connectivity result from the list if possible
      if (event.isNotEmpty && event.first != ConnectivityResult.none) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _checkConnection() async {
    var result = await _connectivity.checkConnectivity();
    print(result);
    if (result != ConnectivityResult.none) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
    }
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _checkConnection,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "An unexpected error happened. Please check your internet connection and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Pull down to refresh",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
