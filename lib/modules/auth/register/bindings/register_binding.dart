import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../repositories/register_repository.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<RegisterRepository>(() => RegisterRepository());

    // Controller
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
