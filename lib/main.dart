import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ui_kit/community_screens/community_welcome/comunnity_welcome_screen.dart';
import 'package:ui_kit/controller.dart';
import 'subcategory_model.dart';
import 'utils/colors.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
       theme: ThemeData.light(useMaterial3: false).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      })),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: false),
      home:CommunityWelcomeScreen(),
        navigatorKey: navigatorKey,
    );
  }
}
 

