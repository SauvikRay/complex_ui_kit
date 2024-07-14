import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const colorGrey = Color(0xFF363638);
const colorWhite = Color(0xFFFFFFFF);
const colorBlack22 = Color(0xFF222222);
const colorBlack12 = Color(0xff121212);
const colorF2F2F7 = Color(0xFFF2F2F7);
const color040601 = Color(0xFF040601);
const color007AFF = Color(0xFF007AFF);
const colorD9D9D9 = Color(0xFFD9D9D9);
const color0A84FF = Color(0xFF0A84FF);
const colorBlack51 = Color(0x82000000);
const colorE5E5EA = Color(0xFFE5E5EA); //  Dark background textColor
const color15295F = Color(0xFF15295F);
const color4CAF50 = Color(0xFF4CAF50);
const color979797 = Color(0xFF979797);
const colorF2F0F0 = Color(0xFFF2F0F0);
const color455A64 = Color(0xFF455A64);
const color000000 = Color(0xFF000000);
const colorFAFAFA = Color(0xFFFAFAFA);
const color656565 = Color(0xFF656565);
const color1E1E1E = Color(0xFF1E1E1E);
const color949494 = Color(0xFF949494);
const color2297D7 = Color(0xFF2297D7);
const colorBBBBBF = Color(0xFFBBBBBF);
const colorF8F8FB = Color(0xFFF8F8FB);
const color9E9E9E = Color(0xFF9E9E9E);
const colorF3F9FF = Color(0xFFF3F9FF);
const color7A7979 = Color(0xFF7A7979);
const color1DA1F2 = Color(0xFF1DA1F2);
const color363638 = Color(0xFF363638);
const colorE0E0E0 = Color(0xFFE0E0E0);
const color29292C = Color(0xFF29292C);
const colorA0A0A0 = Color(0xFFA0A0A0);
const color1C1C1E = Color(0xff1C1C1E);
const titleBackground = Color.fromARGB(239, 220, 220, 228);

//For Dark Mode
const scaffoldDarkBackground = Color(0xff1C1C1E);
const unselectedTopic = Color(0xFF6F6F70);

//WhiteBackground
const scaffoldWhiteBackground = Color(0xffffffff);
Color allNewsBackgroundColor(BuildContext context) =>
    CupertinoDynamicColor.resolve(const CupertinoDynamicColor.withBrightness(color: Colors.white, darkColor: CupertinoColors.darkBackgroundGray), context);
Color contextColor({required BuildContext context, required Color lightThemeColor, required Color darkThemeColor}) =>
    CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(color: lightThemeColor, darkColor: darkThemeColor), context);

Color iconColor(BuildContext context) => CupertinoDynamicColor.resolve(
    const CupertinoDynamicColor.withBrightness(
        debugLabel: 'inactiveGray',
        color: Color(0xFF363638), // Color(0xFF999999),
        darkColor: Color(0xFFFAFAFA) //Color(0xFF757575),
        ),
    context);
