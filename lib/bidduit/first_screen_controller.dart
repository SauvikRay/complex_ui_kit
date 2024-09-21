
import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class FirstScreenController extends GetxController{
 

RxInt increment=0.obs;
RxString  stValue= ''.obs;


@override
  void onInit() {
    stValue.value= 'Me name sdfdf ';
    log('FirstScreenController has been created');
    super.onInit();
  }

  increse(){
    increment++;
    update(['increment']);
  }

  decrement(){
    increment--;
    update(['increment']);
  }
}