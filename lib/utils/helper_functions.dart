import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/device_type.dart';

double tabBarHeight = 0;
RxBool isDialogOpened = false.obs;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> launchWebUrl(String url) async {
  await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication) : Fluttertoast.showToast(msg: "Something went wrong!");
}

void onShare({required BuildContext context, required String url, required String text}) async {
  final box = context.findRenderObject() as RenderBox?;

  GetDeviceType().deviceType(context) == DeviceType.tablet
      ? await Share.share(url, subject: text, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size)
      : await Share.share(url, subject: text, sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 2));
}

hideKyBoard(BuildContext context) {
  FocusScope.of(context).unfocus();
}
