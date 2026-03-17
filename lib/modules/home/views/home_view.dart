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
          ],
        ),
      ),
    );
  }
}
