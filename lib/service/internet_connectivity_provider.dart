import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ui_kit/utils/size_helper.dart';

import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/time_utils.dart';

/* This class continuously check the internet connection.
If network connection is not available then it shows a toast message that the connection closed, also trying to connect the socket
 */

class InternetConnectivity extends GetxController {
  RxBool isInternetActive = false.obs;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();

    _initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    return _updateConnectionStatus(result);
  }

  _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    for (var connectivity in _connectionStatus) {
      if (connectivity != ConnectivityResult.none) {
        await worldTime();
        isInternetActive.value = true;

        log('Connectivity called : $connectivity');
      } else {
        log('Connectivity false');
        isInternetActive.value = false;
      }
    }
  }
}

OverlayEntry insertOverlay(BuildContext context, String message) {
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  log('Size: $size'); //MediaQuery.of(context).size;
  return OverlayEntry(builder: (context) {
    return OverlayBanner(
      message: message,
    );
  });
}

class OverlayBanner extends StatefulWidget {
  const OverlayBanner({super.key, required this.message});
  final String message;

  @override
  State<OverlayBanner> createState() => _OverlayBannerState();
}

class _OverlayBannerState extends State<OverlayBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const Curve curve = Curves.easeOut;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        final double animationValue = curve.transform(_controller.value);
        return FractionalTranslation(
          translation: Offset(0, -(1 - animationValue)),
          child: child,
        );
      },
      animation: _controller,
      child: SingleChildScrollView(
        child: Material(
          color: color007AFF,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              SvgPicture.asset('assets/images/caution_red.svg', height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 180, maxWidth: MediaQuery.of(context).size.width),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.message, maxLines: 2, style: styleF16W400(context: context, color: Colors.white, systemBrigthness: Brightness.light)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() async {
    // fist will show banner with forward.
    await _controller.forward();
    // wait for 3 second and then play reverse animation to hide the banner
    // Duration can be passed as parameter, banner will wait this much and then will dismiss
    await Future<void>.delayed(const Duration(seconds: 3));
    await _controller.reverse(from: 1);
    // call onDismissedCallback so OverlayWidget can remove and clear the OverlayEntry.
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key, this.onPressed});

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final systemBrigthness = MediaQuery.of(context).platformBrightness;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/caution.svg',
              height: 100,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                'Sorry, there was a problem loding this content',
                textAlign: TextAlign.center,
                style: styleF16W500(context: context, color: colorGrey, systemBrigthness: systemBrigthness),
              ),
            ),
            SpaceHepler.verticalMedium,
            TextButton(
                onPressed: onPressed,
                child: Text(
                  'Retry',
                  style: styleF15W700(context: context, color: color0A84FF, systemBrigthness: Brightness.light),
                ))
          ],
        ),
      ),
    );
  }
}
