import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/util/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SharedPreferenceStorage {
  Future<bool> clear(String key);

  Future<bool> clearAll();

  Future<T?> getValue<T>(String key);

  Future<Iterable<T>> getValues<T>(String key);

  Future<bool> setValue(String key, Object value);
}

@LazySingleton(as: SharedPreferenceStorage)
class SharedPreferenceStorageImpl implements SharedPreferenceStorage {
  SharedPreferences? _prefs;

  SharedPreferenceStorageImpl();

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.reload();

    return _prefs!;
  }

  @override
  Future<bool> clear(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    return (await prefs).remove(key);
  }

  @override
  Future<bool> clearAll() async {
    final didClear = await (await prefs).clear();

    return didClear;
  }

  @override
  Future<T?> getValue<T>(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final value = (await prefs).get(key);

    return value as T?;
  }

  @override
  Future<Iterable<T>> getValues<T>(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final stringValue = (await prefs).getString(key);

    if (stringValue == null) {
      return [];
    }

    final values = jsonDecode(stringValue) as List<dynamic>;
    return values.cast();
  }

  @override
  Future<bool> setValue(String key, Object value) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    if (value is String) {
      return (await prefs).setString(key, value);
    } else if (value is int) {
      return (await prefs).setInt(key, value);
    } else if (value is double) {
      return (await prefs).setDouble(key, value);
    } else if (value is bool) {
      return (await prefs).setBool(key, value);
    } else if (value is List<String>) {
      return (await prefs).setStringList(key, value);
    } else {
      return (await prefs).setString(key, value.toString());
    }
  }
}
