import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otp/bindings/otp_binding.dart';
import '../modules/auth/otp/views/otp_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/food_beverage/categories/bindings/category_binding.dart';
import '../modules/food_beverage/categories/views/category_view.dart';
import '../modules/food_beverage/items/bindings/item_binding.dart';
import '../modules/food_beverage/items/views/item_view.dart';
import '../modules/orders/bindings/order_binding.dart';
import '../modules/orders/views/order_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/pos/bindings/pos_binding.dart';
import '../modules/pos/views/pos_view.dart';

import '../modules/kitchen/bindings/kitchen_binding.dart';
import '../modules/kitchen/views/kitchen_view.dart';
import '../modules/table_manage/bindings/table_binding.dart';
import '../modules/table_manage/views/table_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.ITEM_CATEGORIES,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.ITEMS,
      page: () => const ItemView(),
      binding: ItemBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.POS,
      page: () => const PosView(),
      binding: PosBinding(),
    ),
    GetPage(
      name: _Paths.KITCHEN,
      page: () => const KitchenView(),
      binding: KitchenBinding(),
    ),
    GetPage(
      name: _Paths.TABLES,
      page: () => const TableView(),
      binding: TableBinding(),
    ),
  ];
}
