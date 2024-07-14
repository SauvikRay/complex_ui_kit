import 'package:flutter/cupertino.dart';

class SpaceHepler {
  static const verticalSmall = SizedBox(
    height: 10.0,
  );
  static const verticalMedium = SizedBox(
    height: 20.0,
  );
  static const verticalBig = SizedBox(
    height: 30.0,
  );
  static const horizontalSmall = SizedBox(
    width: 10.0,
  );
  static const horizontalMedium = SizedBox(
    width: 20.0,
  );
  static const horizontalBig = SizedBox(
    width: 30.0,
  );
  static verticalSpace(double space) => SizedBox(
        height: space,
      );
  static horizontalSpace(double space) => SizedBox(
        width: space,
      );
}

class AllScreenSize {
  static double responsiveHeight(BuildContext context, double baseHeight) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / 821) * baseHeight; // Adjust 640 to your design reference height
  }

  static double responsiveWidth(BuildContext context, double baseWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / 375) * baseWidth; // Adjust 360 to your design reference width
  }
}

Widget spacerHeight(BuildContext context, double value) {
  return SizedBox(
    height: AllScreenSize.responsiveHeight(context, value),
  );
}

Widget spacerWidth(BuildContext context, double value) {
  return SizedBox(
    width: AllScreenSize.responsiveWidth(context, value),
  );
}

class AllScreenFontSize {
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / 320) * baseFontSize; // Adjust 360 to your design reference width
  }
}
