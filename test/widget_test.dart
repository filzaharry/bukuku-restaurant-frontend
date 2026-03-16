import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:frontend/bindings/initial_binding.dart';

void main() {
  testWidgets('Hello World load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        title: "Bukuku App",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: InitialBinding(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
      )
    );

    await tester.pumpAndSettle();

    // Verify that Hello World is displayed.
    expect(find.text('Hello World'), findsWidgets);
  });
}
