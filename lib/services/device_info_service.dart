import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService  {
  static DeviceInfo? _cachedDeviceInfo;
  static Future<DeviceInfo> getDeviceInfo() async {
    if (_cachedDeviceInfo == null) {
      final deviceInfo = DeviceInfoPlugin();
      _cachedDeviceInfo = await () async {
        if (Platform.isAndroid) {
          final info = await deviceInfo.androidInfo;
          return DeviceInfo(
            brand: '${info.brand} | ${info.manufacturer}',
            model: info.model ?? 'Unknown',
            osVersion: 'Android ${info.version.release}',
          );
        }
        else if (Platform.isIOS) {
          final info = await deviceInfo.iosInfo;
          return DeviceInfo(
            brand: 'Apple',
            model: info.model ?? 'Unknown',
            osVersion: '${info.systemName} ${info.systemVersion}',
          );
        }
        else {
          throw UnimplementedError('${Platform.operatingSystem} is not supported');
        }
      } ();
    }
    return _cachedDeviceInfo!;
  }
}

class DeviceInfo {
  const DeviceInfo({required this.brand, required this.model, required this.osVersion});

  final String brand;
  final String model;
  final String osVersion;
}
