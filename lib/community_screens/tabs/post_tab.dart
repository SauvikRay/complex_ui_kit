import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../utils/time_utils.dart';
import '../../widgets/all_decoration.dart';

import '../../widgets/base_action_button.dart';
import '../../widgets/custom_cupertino_segment_control.dart';
import '../../widgets/custom_devider.dart';
import '../../widgets/reuse_widget.dart';
import '../../widgets/view_all_widget.dart';
import '../community_widgets.dart/recent_user_card.dart';
import '../community_widgets.dart/suggest_user_card.dart';
import '../post_details/post_details_screen.dart';
import '../timeline_screen/timeline_controller.dart';

enum PostType { allPost, myPost }

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  PostType _selectedSegment = PostType.allPost;
  final TimelineController _timeLineController = Get.find<TimelineController>();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            SpaceHepler.verticalSmall,

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
                 physics:const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  child: CustomCupertinoSegmentedControl(
                      selectedColor: color007AFF,
                      unselectedColor: Colors.transparent,
                      groupValue: _selectedSegment,
                      children: <PostType, Widget>{
                        PostType.allPost: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'AllPost',
                            style: body14W400(
                                darkThemeColor: _selectedSegment == PostType.allPost ? Colors.white : color007AFF,
                                lightThemeColor: _selectedSegment == PostType.allPost ? Colors.white : color007AFF,
                                context: context),
                          ),
                        ),
                        PostType.myPost: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('My Post',
                              style: body14W400(
                                  darkThemeColor: _selectedSegment == PostType.myPost ? Colors.white : color007AFF,
                                  lightThemeColor: _selectedSegment == PostType.myPost ? Colors.white : color007AFF,
                                  context: context)),
                        )
                      },
                      onValueChanged: (PostType data) {
                        setState(() {
                          _selectedSegment = data;
                        });
                      }),
                ),
              ),
            ),
            SpaceHepler.verticalSmall,
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                return PostCardWidget(
                  onTap: () {
                    Get.to(() => PostDetailsScreen());
                  },
                );
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

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 380,
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
            SpaceHepler.verticalSmall,
            customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
            SpaceHepler.verticalSmall,
            Row(
              children: [
                BaseIconButton(
                  onPressed: () {},
                  height: 30,
                  width: 30,
                  icon: AssetIcons.icHeart,
                ),
                Text(
                  '20',
                  style: body14Normal(darkThemeColor: iconColor(context), lightThemeColor: color363638, context: context),
                ),
                const Spacer(),
                BaseIconButton(
                  onPressed: () {},
                  height: 30,
                  width: 30,
                  icon: AssetIcons.icComment,
                ),
                Text(
                  '20',
                  style: body14Normal(darkThemeColor: iconColor(context), lightThemeColor: color363638, context: context),
                ),
                SpaceHepler.horizontalMedium,
                BaseIconButton(
                  onPressed: () {},
                  height: 30,
                  width: 30,
                  icon: AssetIcons.icPostShare,
                ),
              ],
            ),
            SpaceHepler.verticalSpace(5),
          ],
        ),
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
              Text('Sauvik Ray', maxLines: 1, overflow: TextOverflow.ellipsis, style: title16W500(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
              SpaceHepler.verticalSmall,
              Text(
                TimeUtils.dateFormat("2024-07-09 22:47:14"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: body12Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638),
              )
            ],
          ),
        )
      ],
    );
  }
}
