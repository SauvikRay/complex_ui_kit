import 'dart:developer';

import 'package:get/get.dart';

class NewsDrawerController extends GetxController {
  findActivePage({required String routeNAme}) {
    log('Current Route ${Get.currentRoute}');
    if (Get.currentRoute == routeNAme) {
      return true;
    } else if (Get.currentRoute == routeNAme) {
      return true;
    }
    return false;
  }
}
