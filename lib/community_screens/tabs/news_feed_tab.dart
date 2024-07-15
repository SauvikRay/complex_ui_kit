import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../utils/time_utils.dart';
import '../../widgets/all_decoration.dart';
import '../../widgets/reuse_widget.dart';

class NewsFeedTab extends StatelessWidget {
  const NewsFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
         physics:const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverList.separated(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const NewFeedCardWidget();
                },
                separatorBuilder: (context, index) {
                  return SpaceHepler.verticalSpace(15);
                }),
          )
        ],
      ),
    );
  }
}

class NewFeedCardWidget extends StatelessWidget {
  const NewFeedCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 345,
      decoration: borderBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userAndUpdateTitle(context),
          SpaceHepler.verticalMedium,
          const CachedNetworkDynamic(
            height: 170,
            boxFit: BoxFit.cover,
            imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
          ),
          SpaceHepler.verticalSmall,
          Text(
            'Abia imposes night-time restriction on tricycles, motorcycles and other small vehicles.',
            maxLines: 2,
            style: title16Bold(darkThemeColor: CupertinoColors.inactiveGray, lightThemeColor: color363638, context: context),
          ),
          SpaceHepler.verticalSmall,
          Text(TimeUtils.dateFormat("2024-07-09 22:47:14")),
          SpaceHepler.verticalSpace(5),
        ],
      ),
    );
  }

  Row _userAndUpdateTitle(BuildContext context) {
    return Row(
      children: [
        const Center(
            child: ClipOval(
          child: CachedNetworkDynamic(
            height: 45,
            width: 45,
            imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
            boxFit: BoxFit.cover,
          ),
        )),
        SpaceHepler.horizontalSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Local News', style: title16W500(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
                  TextSpan(text: " Have an Update ", style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
                ]),
              ),
              SpaceHepler.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AssetIcons.icFace,
                    height: 20,
                    width: 20,
                    // colorFilter: const ColorFilter.mode(CupertinoColors.inactiveGray, BlendMode.srcIn),
                  ),
                  SpaceHepler.horizontalSmall,
                  Expanded(
                    child: Text(
                      'Adekunle Obas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body12Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
