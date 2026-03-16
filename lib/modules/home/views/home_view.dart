import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../components/ui_title.dart';
import '../../../components/ui_button.dart';
import '../../../components/ui_text_input.dart';
import '../../../components/ui_card.dart';
import '../../../components/ui_scaffold.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UiTitle(text: 'Welcome to Bukuku!', color: AppColors.primary, fontSize: 28),
            const SizedBox(height: 20),
            UiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const UiTitle(text: 'Getx Setup Successful', fontSize: 18),
                  const SizedBox(height: 10),
                  const Text('Your app is now configured with the requested master colors and UI components.'),
                  const SizedBox(height: 20),
                  UiTextInput(
                    label: 'Name',
                    hint: 'Enter your name...',
                    controller: controller.textController,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  UiButton(
                    label: 'Say Hello',
                    onPressed: controller.sayHello,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => UiCard(
              backgroundColor: AppColors.background,
              child: Column(
                children: [
                  const Text('Button Clicks:', style: TextStyle(fontSize: 16)),
                  Text(
                    '${controller.count}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.secondaryVariant),
                  ),
                  const SizedBox(height: 10),
                  UiButton(
                    label: 'Increment Counter',
                    backgroundColor: AppColors.secondary,
                    onPressed: controller.increment,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
