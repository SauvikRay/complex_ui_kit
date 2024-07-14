import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final ScrollController suggestController = ScrollController();
  RxBool isLeftRightSliding = false.obs;
  @override
  void onInit() {
    suggestController.addListener(() {
      if (suggestController.position.userScrollDirection == ScrollDirection.reverse) {
        isLeftRightSliding.value = true;
      } else {
        isLeftRightSliding.value = false;
      }
    });
    super.onInit();
  }
}
