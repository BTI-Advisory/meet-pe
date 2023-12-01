import 'dart:convert';
import 'package:meet_pe/models/contact_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meet_pe/utils/_utils.dart';

// Service that provide data storage.
///
/// Uses Hive internally.
/// Note: Using Box<JsonObject> directly throws when ready values, so we use Box<String> instead. See https://github.com/hivedb/hive/issues/522
class StorageService  {
  //#region Global
  static const _dataBoxName = 'data';
  static Box<String> get _dataBox => Hive.box(_dataBoxName);

  static const _jsonCacheBoxName = 'jsonCache';
  static Box<String> get _jsonCacheBox => Hive.box(_jsonCacheBoxName);

  static const _imageCacheBoxName = 'imageCache';
  static Box<Uint8List> get imageCacheBox => Hive.box(_imageCacheBoxName);    // Stores avatars images bytes for caching purposes

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_dataBoxName);
    await Hive.openBox<String>(_jsonCacheBoxName);
    await Hive.openBox<Uint8List>(_imageCacheBoxName);
    debugPrint('[StorageService] initiated');
  }

  /// Delete all local data
  /// Use [butAnalyticsEnabled] to restore analyticsEnabledBox's value after cleaning.
  static Future<void> deleteAll({butAnalyticsEnabled = false}) async {
    bool? analyticsEnabled;
    if (butAnalyticsEnabled) analyticsEnabled = analyticsEnabledBox.value;

    await _dataBox.clear();
    await userCardDataBox._clear();
    await _jsonCacheBox.clear();
    await imageCacheBox.clear();
    debugPrint('[StorageService] all data deleted');

    if (butAnalyticsEnabled && analyticsEnabled != null) await analyticsEnabledBox.save(analyticsEnabled);
  }
  //#endregion

  //#region basic data box
  static const developerModeBox = BoolBox('developerMode');
  static const analyticsEnabledBox = BoolBox('analyticsEnabled');
  static const biometricsEnabledBox = BoolBox('biometricsEnabled');
  //#endregion

  //#region CachedJsonBox boxes
  static final userCardDataBox = CachedJsonBox<ContactData>('userCardData', ContactData.fromJson, (value) => value.toJson());
//#endregion
}

/// A basic box that stores a simple boolean value
class BoolBox {
  const BoolBox(this.key);

  final String key;

  bool? get value {
    final value = StorageService._dataBox.get(key);
    if (value == 'true') return true;
    if (value == 'false') return false;
    return null;
  }
  Future<void> save(bool value) async {
    StorageService._dataBox.put(key, value ? 'true' : 'false');
    debugPrint('[StorageService] $key set to $value');
  }
}

/// A box that store a json object, for caching purpose.
/// If a value can't be read, it will be deleted and return null.
class CachedJsonBox<T> {
  CachedJsonBox(this.key, this._fromJson, this._toJson, {this.stalePeriod = const Duration(days: 7)});

  final String key;
  final T Function(JsonObject raw) _fromJson;
  final JsonObject Function(T value) _toJson;
  final Duration stalePeriod;

  String get _lastSavedAtKey => '${key}SavedAt';
  DateTime? _lastSavedAt;
  DateTime? get lastSavedAt => _lastSavedAt ??= const NullableDateTimeConverter().fromJson(StorageService._jsonCacheBox.get(_lastSavedAtKey));

  T? _value;
  T? get value {
    if (_value == null) {
      try {
        // Check date
        if (lastSavedAt == null) return null;
        if (DateTime.now().difference(lastSavedAt!) > stalePeriod) {
          _clear();
          return null;
        }

        // Get value
        final rawValue = StorageService._jsonCacheBox.get(key);
        if (rawValue == null) return null;
        _value = _fromJson(json.decode(rawValue));
      } catch(e, s) {
        // If an error occurs while reading, delete cache
        _value = null;
        _clear();
        // TODO: Remove the comment when implementing Crashlytics
        //reportError(e, s);
      }
    }
    return _value;
  }

  Future<void> saveValue(T? value) async {
    if (value == null) return;
    _value = value;
    await StorageService._jsonCacheBox.put(key, json.encode(_toJson(value)));
    _lastSavedAt = DateTime.now();
    await StorageService._jsonCacheBox.put(_lastSavedAtKey, const DateTimeConverter().toJson(_lastSavedAt!));
    debugPrint('[StorageService] $key: saved');
  }

  Future<void> _clear() async {
    _lastSavedAt = null;
    _value = null;
    await StorageService._jsonCacheBox.delete(_lastSavedAtKey);
    await StorageService._jsonCacheBox.delete(key);
    debugPrint('[StorageService] $key: deleted');
  }
}
