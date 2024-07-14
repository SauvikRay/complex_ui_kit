import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../widgets/reuse_widget.dart';

class RecentUserCard extends StatelessWidget {
  const RecentUserCard({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {},
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: ClipOval(
                child: CachedNetworkDynamic(
                  height: 60,
                  width: 60,
                  imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
                  boxFit: BoxFit.cover,
                ),
              )),
            ],
          ),
          SpaceHepler.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Popoola Ife', style: body14Bold(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
                    TextSpan(text: " is a ", style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
                    TextSpan(text: "New User", style: body14Normal(context: context, darkThemeColor: color007AFF, lightThemeColor: color007AFF)),
                    TextSpan(text: " in your area", style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
                  ]),
                ),
                SpaceHepler.verticalSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetIcons.icLocation,
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(CupertinoColors.inactiveGray, BlendMode.srcIn),
                    ),
                    SpaceHepler.horizontalSmall,
                    Expanded(
                      child: Text(
                        'Ago -Odo, Abia Ago -Odo, Abia Ago -Odo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: body12Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638.withOpacity(0.7)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
