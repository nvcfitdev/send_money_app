import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maya_test_app/di/app_config_module.dart';
import 'package:maya_test_app/di/dependency_injection.dart';
import 'package:maya_test_app/presentation/app/app.dart';

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late final Future<String?> _initApp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _initApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }

        return const Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initApp = Future(_initializeApp);
  }

  Future<String?> _initializeApp() async {
    try {
      await AppConfig.instance.loadConfig();
      configureDependencies();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      return 'done';
    } catch (e, st) {
      print('Error during initialization: $e');
      print('Stack trace: $st');
      rethrow;
    }
  }
}
