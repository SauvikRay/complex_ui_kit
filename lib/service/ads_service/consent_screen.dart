import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_kit/service/ads_service/eu_consent_helper.dart';

import '../../widgets/loader_widget.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key, required this.targetWidget});
  final Widget targetWidget;

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _consentHelper = ConsentHelper();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _consentHelper.initialize();
        Get.offAll(() => widget.targetWidget, transition: Transition.rightToLeft);
      } catch (e) {
        if (kDebugMode) {
          log('Consent initialize error : $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoPageScaffold(
        child: Center(
          child: loaderWidget(),
        ),
      ),
    );
  }
}
