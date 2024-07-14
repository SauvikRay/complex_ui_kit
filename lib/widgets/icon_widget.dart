import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
    );
  }
}
