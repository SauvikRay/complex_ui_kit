import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../widgets/reuse_widget.dart';

class SuggestedUserWidget extends StatelessWidget {
  const SuggestedUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // height: 210,
      width: 160,
      decoration: BoxDecoration(border: Border.all(color: color979797.withOpacity(0.6)), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: ClipOval(
            child: CachedNetworkDynamic(
              height: 80,
              width: 80,
              imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
              boxFit: BoxFit.cover,
            ),
          )),
          SpaceHepler.verticalSmall,
          Text('Christopher', style: body14SemiBold(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
          SpaceHepler.verticalSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetIcons.icLocation,
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(CupertinoColors.inactiveGray, BlendMode.srcIn),
              ),
              SpaceHepler.horizontalSmall,
              Flexible(
                child: Text(
                  'Ago -Odo Ago -Odo Ago -Odo Ago -Odo',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: body12Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638.withOpacity(0.7)),
                ),
              ),
            ],
          ),
          SpaceHepler.verticalSmall,
          OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Follow',
                style: TextStyle(fontSize: 13.5),
              ))
        ],
      ),
    );
  }
}
