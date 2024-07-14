
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_kit/utils/colors.dart';

import '../widgets/loader_widget.dart';

showLoader() async {
  Get.dialog(
    barrierColor: colorD9D9D9.withOpacity(0.075),
    Center(child: PopScope(canPop: false, onPopInvoked: (didPop) => false, child: Material(color: Colors.transparent, child: loaderWidget()))),
    barrierDismissible: false,
  );
}
