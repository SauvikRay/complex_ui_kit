import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class SystemAnnotatedRegion extends StatelessWidget {
  const SystemAnnotatedRegion({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: allNewsBackgroundColor(context), //systemBrightness == Brightness.dark ? scaffoldDarkBackground : colorWhite,
          statusBarIconBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: allNewsBackgroundColor(context) //MediaQuery.of(context).platformBrightness == Brightness.dark ? scaffoldDarkBackground : colorWhite,
          ),
      child: child,
    );
  }
}
