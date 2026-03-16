import 'package:get/get.dart';
import '../core/services/api_handler.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiHandler(), permanent: true);
  }
}
