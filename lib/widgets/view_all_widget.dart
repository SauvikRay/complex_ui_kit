import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/common_style.dart';

class ViewAllWidget extends StatelessWidget {
  const ViewAllWidget({super.key, required this.title, this.endTitle, required this.onPressed});
  final String title;
  final String? endTitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: title16Bold(darkThemeColor: colorE5E5EA, lightThemeColor: color040601, context: context)),
        const Spacer(),
        MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 50,
          child: Text(
            endTitle ?? 'View all',
            style: body14W400(darkThemeColor: colorE5E5EA, lightThemeColor: color363638.withOpacity(0.7), context: context),
          ),
        )
      ],
    );
  }
}
