import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkInitialRoute();
  }

  void _checkInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));
    final String initialRoute = StorageService.getToken() != null 
        ? Routes.HOME 
        : Routes.POS;
        
    Get.offAllNamed(initialRoute);
  }
}
