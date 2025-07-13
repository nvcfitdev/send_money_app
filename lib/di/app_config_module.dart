import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._();

  late Map<String, dynamic> _config;

  AppConfig._();

  String get baseUrl => _config['baseUrl'];

  Future<void> loadConfig({String environment = 'dev'}) async {
    try {
      final configString = await rootBundle.loadString(
        '.env/$environment.json',
      );
      _config = json.decode(configString);
    } catch (e) {
      throw Exception('Failed to load config: $e');
    }
  }
}

@module
abstract class AppConfigModule {
  @Named('baseUrl')
  String get baseUrl => AppConfig.instance.baseUrl;
}
