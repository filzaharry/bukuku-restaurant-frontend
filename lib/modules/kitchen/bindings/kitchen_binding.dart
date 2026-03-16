import 'package:get/get.dart';
import '../controllers/kitchen_controller.dart';
import '../repositories/kitchen_repository.dart';

class KitchenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KitchenRepository>(() => KitchenRepository());
    Get.lazyPut<KitchenController>(() => KitchenController());
  }
}
