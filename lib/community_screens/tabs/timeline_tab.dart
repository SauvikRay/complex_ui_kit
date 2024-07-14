import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../widgets/custom_devider.dart';
import '../../widgets/icon_list_tile.dart';
import '../../widgets/reuse_widget.dart';
import '../../widgets/view_all_widget.dart';
import '../community_widgets.dart/recent_user_card.dart';
import '../community_widgets.dart/suggest_user_card.dart';
import '../create_post/create_post_screen.dart';
import '../timeline_screen/timeline_controller.dart';

class TimeLineTab extends StatelessWidget {
  const TimeLineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final TimelineController _timeLineController = Get.find<TimelineController>();
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            //This is User Image and Add post section
            const UserAndAddPostSection(),
            SpaceHepler.verticalMedium,

            //Recent update View All
            ViewAllWidget(
              title: 'Recent Update',
              onPressed: () {},
            ),
            SpaceHepler.verticalSpace(5),
          ])),
        ),
        //Recent update user list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                return RecentUserCard(
                  onPressed: () {},
                );
              },
              separatorBuilder: (context, index) {
                return SpaceHepler.verticalSmall;
              }),
        ),
        //Suggested View All

        SliverList(
          delegate: SliverChildListDelegate([
            SpaceHepler.verticalMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ViewAllWidget(
                title: 'Suggested for you',
                onPressed: () {},
              ),
            ),
            SpaceHepler.verticalSmall,
            //Suggested List
            SizedBox(
              height: 220,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                // controller: _timeLineController.suggestController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    sliver: SliverList.separated(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return const SuggestedUserWidget();
                        },
                        separatorBuilder: (context, index) {
                          return SpaceHepler.horizontalSmall;
                        }),
                  )
                ],
              ),
            ),
            // Activities in My Area
            SpaceHepler.verticalMedium,
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: ViewAllWidget(title: 'Activities in my area', onPressed: () {})),
            SpaceHepler.verticalSmall,
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                return MyAreaActivityCardCard(onPressed: () {});
              },
              separatorBuilder: (context, index) {
                return SpaceHepler.verticalSmall;
              }),
        ),

        SliverList(delegate: SliverChildListDelegate([SpaceHepler.verticalSpace(kBottomNavigationBarHeight + kBottomNavigationBarHeight)]))
      ],
    );
  }
}

class UserAndAddPostSection extends StatelessWidget {
  const UserAndAddPostSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Icon
        const Center(
            child: ClipOval(
          child: CachedNetworkDynamic(
            height: 40,
            width: 40,
            imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
            boxFit: BoxFit.cover,
          ),
        )),
        SpaceHepler.horizontalSmall,
        Expanded(
          child: GestureDetector(
            onTap: () {
              //Select Post Type Dialog
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return const SelectPostTypeWidget();
                  });
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: color979797)),
            ),
          ),
        )
      ],
    );
  }
}

List<IconListTileModel> iconListTile = [
  IconListTileModel(icon: AssetIcons.icMessage, title: 'General Massage'),
  IconListTileModel(icon: AssetIcons.icArticle, title: 'Contribute Article'),
  IconListTileModel(icon: AssetIcons.icReport, title: 'Report a Crime'),
  IconListTileModel(icon: AssetIcons.icContribute, title: 'Contribute to state History'),
];

class SelectPostTypeWidget extends StatelessWidget {
  const SelectPostTypeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 400),
        child: SizedBox(
            width: double.infinity,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SpaceHepler.verticalSmall,
              Container(
                height: 5,
                width: 64,
                decoration: const BoxDecoration(color: color363638),
              ),
              SpaceHepler.verticalMedium,
              Text(
                'Select Post Type',
                style: title24W700(darkThemeColor: Colors.white, lightThemeColor: color040601, context: context),
              ),
              SpaceHepler.verticalBig,
              customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              Flexible(
                  child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: iconListTile.length,
                itemBuilder: (context, index) {
                  IconListTileModel iconTile = iconListTile[index];
                  return IconListTile(
                      icon: iconTile.icon,
                      title: iconTile.title,
                      onPressed: () {
                        Get.to(() => CreatePostScreen());
                      });
                },
                separatorBuilder: (context, index) {
                  return customDivider(context: context, color: colorE5E5EA, thickness: 1.5);
                },
              )),
              customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              SpaceHepler.verticalMedium,
            ])),
      ),
    );
  }
}

class MyAreaActivityCardCard extends StatelessWidget {
  const MyAreaActivityCardCard({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: color979797.withOpacity(0.6), width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  height: 70,
                  width: 70,
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
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(text: 'Popoola Ife', style: body14Bold(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
                    TextSpan(
                        text: " shared an update shared an update shared an update shared an update shared an update shared an update ",
                        style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
                  ]),
                ),
                SpaceHepler.verticalSmall,
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Sed feugiat iaculis phasellus vel vitae ac et suspendisse.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638.withOpacity(0.7)),
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
