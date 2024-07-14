import 'package:flutter/material.dart';
import 'colors.dart';

TextStyle styleF10W400({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 10.0,
    color: systemBrigthness == Brightness.dark ? colorA0A0A0 : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF12W400({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 12.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle timeAgoStyle({required BuildContext context, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 12.0,
    color: systemBrigthness == Brightness.dark ? color979797 : color979797,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF12W500({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 12.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF12W700({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 12.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF13W400({required BuildContext context, required Color color, required Brightness ststemBrigthness}) {
  return TextStyle(
    fontSize: 13.0,
    color: ststemBrigthness == Brightness.dark ? colorA0A0A0 : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF13W500({required BuildContext context, required Color color, required Brightness? systemBrigthness}) {
  return TextStyle(
    fontSize: 13.0,
    color: systemBrigthness == Brightness.dark ? colorF2F2F7 : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF13W700({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 13.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF14W400({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 14.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF14W500({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 14.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF14W600({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 14.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w600,
    fontFamily: "Roboto",
  );
}

TextStyle styleF14Normal({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 14.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.normal,
    fontFamily: "Roboto",
  );
}

TextStyle styleF16W400({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 16.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF16W500({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 16.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF20W500({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 20.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF16Normal({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 16.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.normal,
    fontFamily: "Roboto",
  );
}

TextStyle styleF14W700({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 14.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF15W400({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 15.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
  );
}

TextStyle styleF15W500({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 15.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle styleF15W700({required BuildContext context, required Color color, required Brightness systemBrigthness}) {
  return TextStyle(
    fontSize: 15.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF16W700({
  required BuildContext context,
  required Color color,
  required Brightness systemBrigthness,
}) {
  return TextStyle(
    fontSize: 16.0,
    color: systemBrigthness == Brightness.dark ? color979797 : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle selectedText({
  required BuildContext context,
  required Color color,
}) {
  return TextStyle(
    fontSize: 16.0,
    color: color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF22W700({
  required BuildContext context,
  required Color color,
  required Brightness systemBrigthness,
}) {
  return TextStyle(
    fontSize: 26.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF18W700({
  required BuildContext context,
  required Color color,
  required Brightness systemBrigthness,
}) {
  return TextStyle(
    fontSize: 18.0,
    color: systemBrigthness == Brightness.dark ? colorE5E5EA : color,
    fontWeight: FontWeight.w700,
    fontFamily: "Roboto",
  );
}

TextStyle styleF12W500UnderLine({required BuildContext context, required Color color}) {
  return TextStyle(
    decoration: TextDecoration.underline,
    fontSize: 12.0,
    color: color,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
}

TextStyle title24W700({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "Roboto",
    );

TextStyle title16W500({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 16.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
    );
TextStyle title16Bold({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 16.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.bold,
      fontFamily: "Roboto",
    );
TextStyle title16Normal({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 16.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto",
    );
TextStyle selectedTab16W700({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 16.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w700,
      fontFamily: "Roboto",
    );
TextStyle unSelectedTab16W400({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 16.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
    );

TextStyle body12Normal({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 12.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto",
    );
TextStyle body14Normal({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 14.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto",
    );
TextStyle body12W400({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 12.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
    );

TextStyle body14W400({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 14.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
    );
TextStyle body14Bold({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 14.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.bold,
      fontFamily: "Roboto",
    );
TextStyle body14SemiBold({required Color darkThemeColor, required Color lightThemeColor, required BuildContext context}) => TextStyle(
      fontSize: 14.0,
      color: contextColor(context: context, lightThemeColor: lightThemeColor, darkThemeColor: darkThemeColor),
      fontWeight: FontWeight.w600,
      fontFamily: "Roboto",
    );
