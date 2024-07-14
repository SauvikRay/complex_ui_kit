import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/asset_icons.dart';
import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../utils/time_utils.dart';
import '../../widgets/all_decoration.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/reuse_widget.dart';
import '../community_widgets.dart/search_box_widget.dart';
import '../tabs/news_feed_tab.dart';

class CommunitySearchScreen extends StatelessWidget {
  const CommunitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
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
        title: SearchBoxWidget(
          searchController: searchController,
          hintText: 'Search',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            SpaceHepler.verticalMedium,
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Search result for "Localnews”'),
            ),
          ])),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, mainAxisExtent: 250),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const SearchItemCard();
                }),
          )
        ],
      ),
    ));
  }
}

class SearchItemCard extends StatelessWidget {
  const SearchItemCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 245,
        width: 180,
        decoration: borderBoxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          TextSpan(text: 'Local News', style: body14Bold(darkThemeColor: colorE5E5EA, lightThemeColor: color363638, context: context)),
                          TextSpan(text: " Have an Update ", style: body14Normal(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color363638)),
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SpaceHepler.verticalSmall,
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: const CachedNetworkDynamic(
                height: 115,
                boxFit: BoxFit.cover,
                imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
              ),
            ),
            SpaceHepler.verticalSmall,
            Text(
              'Abia imposes night-time restriction on tricycles, motorcycles and other small vehicles.',
              maxLines: 1,
              style: body14Bold(darkThemeColor: CupertinoColors.inactiveGray, lightThemeColor: color363638, context: context),
            ),
            SpaceHepler.verticalSmall,
            Text(TimeUtils.dateFormat("2024-07-09 22:47:14")),
          ],
        ),
      ),
    );
  }
}
