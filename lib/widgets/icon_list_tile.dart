import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/common_style.dart';

class IconListTileModel {
  String title;
  String icon;
  IconListTileModel({required this.title, required this.icon});
}

class IconListTile extends StatelessWidget {
  const IconListTile({super.key, required this.icon, required this.title, required this.onPressed});
  final String icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      dense: true,
      minVerticalPadding: 12,
      leading: SvgPicture.asset(
        icon,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
      ),
      title: Text(
        title,
        style: title16Normal(darkThemeColor: Colors.white, lightThemeColor: color363638, context: context),
      ),
      onTap: onPressed,
    );
  }
}
