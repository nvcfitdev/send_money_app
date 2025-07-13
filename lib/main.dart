import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maya_test_app/presentation/app/init_app.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const InitApp());
    },
    (e, st) {
      print('Error: $e');
      print('Stack trace: $st');
    },
  );
}
