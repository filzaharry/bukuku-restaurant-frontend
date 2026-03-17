import 'package:get/get.dart';
import '../controllers/table_controller.dart';
import '../repositories/table_repository.dart';

class TableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TableRepository>(() => TableRepository());
    Get.lazyPut<TableController>(() => TableController());
  }
}
