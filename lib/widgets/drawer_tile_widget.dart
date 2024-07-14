import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

import '../utils/common_style.dart';
import '../utils/size_helper.dart';

class DrawerTileWidget extends StatelessWidget {
  const DrawerTileWidget({super.key, required this.title, this.textStyle, required this.icon, this.height, this.width, this.isActive = false, required this.onPressed});
  final String title;
  final TextStyle? textStyle;
  final String icon;
  final double? height;
  final double? width;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: Row(
        children: [
          // assets/images/ic_drawer_news.svg
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(isActive ? color007AFF : iconColor(context), BlendMode.srcIn),
            height: height,
            width: width,
            fit: BoxFit.contain,
          ),
          SpaceHepler.horizontalSmall,
          Text(
            title,
            style: textStyle ??
                body14W400(
                  context: context,
                  lightThemeColor: isActive ? color007AFF : color363638,
                  darkThemeColor: isActive ? color007AFF : Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
