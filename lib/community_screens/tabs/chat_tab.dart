import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/helper_functions.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/reuse_widget.dart';
import '../community_widgets.dart/search_box_widget.dart';
import '../post_details/post_details_screen.dart';

class ChaTab extends StatelessWidget {
  const ChaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            SearchBoxWidget(
              searchController: TextEditingController(),
              hintText: 'Search Chat',
            ),
            SpaceHepler.verticalSmall,
          ])),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 120,
            child: CustomScrollView(
               physics:const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  sliver: SliverList.separated(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const UserImageIconWidget(height: 60, width: 60),
                            SpaceHepler.verticalSmall,
                            Text(
                              'Sauvik',
                              style: body14Normal(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SpaceHepler.horizontalSmall;
                      }),
                )
              ],
            ),
          ),
        ])),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverList.separated(
              itemCount: 30,
              itemBuilder: (context, index) {
                return UserChatListWidget(
                  onPressed: () {
                    Get.to(() => const ChatDetailsScreen());
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SpaceHepler.verticalSmall;
              }),
        )
      ],
    );
  }
}

class UserChatListWidget extends StatelessWidget {
  const UserChatListWidget({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: Row(
        children: [
          const UserImageIconWidget(
            height: 50,
            width: 50,
          ),
          SpaceHepler.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'My Name My name',
                      style: body14Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
                    ),
                    const Spacer(),
                    Text(
                      '2 min',
                      style: body12Normal(darkThemeColor: color656565, lightThemeColor: color9E9E9E, context: context),
                    )
                  ],
                ),
                SpaceHepler.verticalSmall,
                const Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserImageIconWidget extends StatelessWidget {
  const UserImageIconWidget({
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color007AFF.withOpacity(0.25), width: 5), borderRadius: BorderRadius.circular(100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkDynamic(
            height: height, //50,
            width: width,
            imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
            boxFit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SystemAnnotatedRegion(
        child: GestureDetector(
      onTap: () {
        hideKyBoard(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: allNewsBackgroundColor(context),
        appBar: CupertinoAppbar(
          leadingWidget: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 20,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserImageIconWidget(height: 30, width: 30),
              SpaceHepler.horizontalSmall,
              Text(
                'Sauvik',
                style: title16Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
              )
            ],
          ),
        ),
        body: CustomScrollView(
           physics:const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              sliver: SliverList.separated(
                itemCount: 10,
                itemBuilder: (context, index) {
                  bool isEven = index % 2 == 0 ? true : false;
                  return isEven
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(color: colorFAFAFA, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: body14Normal(darkThemeColor: color656565, lightThemeColor: color9E9E9E, context: context),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1.5, color: colorFAFAFA)),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: body14Normal(darkThemeColor: color656565, lightThemeColor: color9E9E9E, context: context),
                          ),
                        );
                },
                separatorBuilder: (context, index) {
                  return SpaceHepler.verticalMedium;
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const CommentTypeBoxWidget(
            isAbsorbing: false,
          ),
        ),
      ),
    ));
  }
}
