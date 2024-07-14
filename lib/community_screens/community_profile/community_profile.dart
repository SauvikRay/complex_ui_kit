import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/asset_icons.dart';
import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/base_action_button.dart';
import '../../widgets/reuse_widget.dart';

class CommunityProfileScreen extends StatefulWidget {
  const CommunityProfileScreen({super.key});

  @override
  State<CommunityProfileScreen> createState() => _CommunityProfileScreenState();
}

class _CommunityProfileScreenState extends State<CommunityProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SystemAnnotatedRegion(
      child: Scaffold(
        appBar: CupertinoAppbar(
          leadingWidget: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 20,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            'Profile',
            style: title16Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              SpaceHepler.verticalBig,
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(width: 3, color: color007AFF), boxShadow: [
                    BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5), spreadRadius: 0, offset: Offset(0, 2)),
                  ]),
                  child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const CachedNetworkDynamic(imageUrl: "https://as1.ftcdn.net/v2/jpg/05/90/59/88/1000_F_590598870_TOcGd4cUZzPoEMlxSc7XYwcupHOE0vLM.webp"))),
                ),
              ),
              SpaceHepler.verticalSmall,
              Center(
                  child: Text(
                'Jimmy Agunsaki',
                style: title16Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
              )),
              SpaceHepler.verticalMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButtonWithIconText(
                    onPressed: () {},
                    icon: AssetIcons.icfollow2,
                    title: 'Follow',
                  ),
                  SpaceHepler.horizontalSmall,
                  OutlineButtonWithIconText(
                    onPressed: () {},
                    icon: AssetIcons.icMessage,
                    title: 'Message',
                  ),
                ],
              ),
              SpaceHepler.verticalMedium,
              //Details Row
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearDetailsRow(
                          icon1: AssetIcons.icCalender,
                          title1: 'Follow',
                        ),
                        SpaceHepler.verticalSmall,
                        LinearDetailsRow(
                          icon1: AssetIcons.icLocation,
                          title1: 'Location',
                        ),
                        SpaceHepler.verticalSmall,
                        LinearDetailsRow(
                          icon1: AssetIcons.icGroup,
                          title1: '0 Followers',
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearDetailsRow(
                          icon1: AssetIcons.icHeart,
                          title1: 'Single',
                        ),
                        SpaceHepler.verticalSmall,
                        LinearDetailsRow(
                          icon1: AssetIcons.icGroup,
                          title1: 'Following',
                        ),
                        SpaceHepler.verticalSmall,
                        LinearDetailsRow(
                          icon1: AssetIcons.icGender,
                          title1: 'Male',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SpaceHepler.verticalMedium,
              //Bio Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1.5, color: colorE0E0E0)),
                  child: Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: body14Normal(darkThemeColor: color656565, lightThemeColor: color9E9E9E, context: context),
                  ),
                ),
              ),
              SpaceHepler.verticalMedium,
//Seller Review
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller Review',
                      style: title16Bold(darkThemeColor: color656565, lightThemeColor: color000000, context: context),
                    ),
                    SpaceHepler.verticalSmall,
                    Row(
                      children: [
                        Text(
                          '4.7',
                          style: title16Bold(darkThemeColor: color656565, lightThemeColor: color000000, context: context),
                        ),
                        SpaceHepler.horizontalSmall,
                        RatingBar.builder(
                          itemSize: 20,
                          initialRating: 2.4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: color007AFF,
                          ),
                          onRatingUpdate: (rating) {
                            debugPrint('$rating');
                          },
                        )
                      ],
                    ),
                    SpaceHepler.verticalSmall,
                    Text(
                      '1,320 reviews',
                      style: body14W400(darkThemeColor: color656565, lightThemeColor: color000000, context: context),
                    ),
                    SpaceHepler.verticalMedium,
                    ListView.separated(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: body14Normal(darkThemeColor: color000000, lightThemeColor: color000000, context: context),
                            ),
                            SpaceHepler.horizontalSmall,
                            Expanded(
                              child: LinearProgressIndicator(
                                value: 0.5,
                                valueColor: const AlwaysStoppedAnimation<Color>(color007AFF),
                                minHeight: 6,
                                backgroundColor: const Color(0xffD6D6D6),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SpaceHepler.horizontalSmall,
                            Text(
                              '50%',
                              style: body14Normal(darkThemeColor: color000000, lightThemeColor: color000000, context: context),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SpaceHepler.verticalSmall;
                      },
                    ),
                    SpaceHepler.verticalMedium,
                    ListView.separated(
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SpaceHepler.verticalSmall;
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: colorE0E0E0, width: 1.5)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: ClipOval(
                                      child: CachedNetworkDynamic(
                                        height: 45,
                                        width: 45,
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
                                      Text('Popoola Ife', style: body14Bold(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
                                      RatingBar.builder(
                                        itemSize: 20,
                                        initialRating: 2.4,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: color007AFF,
                                        ),
                                        onRatingUpdate: (rating) {
                                          debugPrint('$rating');
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Lorem ipsum dolor sit amet consectetur. Vitae enim ridiculus cursus velit nullam aliquet amet lobortis interdum.',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: body12Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638.withOpacity(0.7)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SpaceHepler.verticalSmall,
                                      Row(
                                        children: [
                                          Text(
                                            "2 min ago",
                                            style: body12Normal(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
                                          ),
                                          SpaceHepler.horizontalSpace(5),
                                          MaterialButton(
                                            onPressed: () {},
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            height: 15,
                                            minWidth: 50,
                                            child: Text(
                                              "Reply",
                                              style: body12W400(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    SpaceHepler.verticalBig,
                    SpaceHepler.verticalBig,
                  ],
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}

class LinearDetailsRow extends StatelessWidget {
  const LinearDetailsRow({
    super.key,
    required this.icon1,
    required this.title1,
    // required this.icon2,
    // required this.title2,
  });
  final String icon1;
  final String title1;
  // final String icon2;
  // final String title2;
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon1,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
        ),
        SpaceHepler.horizontalSmall,
        Text(
          title1,
          style: body14Normal(darkThemeColor: color656565, lightThemeColor: color363638, context: context),
        ),
      ],
    );
  }
}
