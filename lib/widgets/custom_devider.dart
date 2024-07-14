import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

customDivider({
  required BuildContext context,
  required Color color,
  double? thickness,
}) {
  return Divider(thickness: thickness, height: 0.5, color: contextColor(context: context, lightThemeColor: color, darkThemeColor: color656565)

      //  systemBrigthness == Brightness.dark ? color656565 : color,
      );
}
