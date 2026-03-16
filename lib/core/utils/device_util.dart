import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtil {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    
    Map<String, dynamic> deviceData = {
      "firebase_id": "MOCK_FIREBASE_ID", // This should come from Firebase Messaging later
      "app_version": packageInfo.version,
      "device_platform": "mobile",
    };

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData.addAll({
        "device_imei": androidInfo.id, // Not real IMEI but unique ID
        "device_name": androidInfo.model,
        "device_os": "Android ${androidInfo.version.release}",
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData.addAll({
        "device_imei": iosInfo.identifierForVendor,
        "device_name": iosInfo.name,
        "device_os": "iOS ${iosInfo.systemVersion}",
      });
    }

    return deviceData;
  }
}
