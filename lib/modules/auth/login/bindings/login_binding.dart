import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../repositories/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(() => LoginRepository(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true); // ✅
  }
}
