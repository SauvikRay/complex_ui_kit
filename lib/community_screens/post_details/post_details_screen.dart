import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/asset_icons.dart';
import '../../utils/common_style.dart';
import '../../utils/helper_functions.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../utils/time_utils.dart';
import '../../widgets/all_decoration.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/base_action_button.dart';
import '../../widgets/custom_devider.dart';
import '../../widgets/icon_widget.dart';
import '../../widgets/reuse_widget.dart';
import '../../widgets/view_all_widget.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemAnnotatedRegion(
      child: GestureDetector(
        onTap: () {
          hideKyBoard(context);
        },
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
              'Post',
              style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: color979797),
            ),
          ),
          // resizeToAvoidBottomInset: true,
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    SpaceHepler.verticalMedium,
                    const PostDetailsCardWidget(),
                    SpaceHepler.verticalSmall,
                  ]))),
              SliverList(
                  delegate: SliverChildListDelegate([
                customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              ])),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverList(delegate: SliverChildListDelegate([ViewAllWidget(title: 'Replies', endTitle: 'View Activity', onPressed: () {})])),
              ),
              SliverList(delegate: SliverChildListDelegate([customDivider(context: context, color: colorE5E5EA, thickness: 1.5), SpaceHepler.verticalMedium])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    SpaceHepler.verticalSmall,
                    SpaceHepler.verticalBig,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CommentWidget(),
                    ),
                    SpaceHepler.verticalBig,
                  ],
                ),
              ]))
            ],
          ),
          // bottomSheet: _commentBoxSection(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          bottomNavigationBar: CommentBoxWidget(),
        ),
      ),
    );
  }
}

class CommentBoxWidget extends StatelessWidget {
  const CommentBoxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('CommentBox ');
        showModalBottomSheet(
            context: context,
            barrierColor: Colors.black.withOpacity(0.5),
            enableDrag: true,
            backgroundColor: allNewsBackgroundColor(context),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
            isDismissible: true,
            isScrollControlled: true,
            constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 550),
            builder: (context) {
              return CommentModalWidget();
            });
      },
      child: CommentTypeBoxWidget(
        isAbsorbing: true,
      ),
    );
  }
}

class CommentTypeBoxWidget extends StatelessWidget {
  const CommentTypeBoxWidget({super.key, required this.isAbsorbing});
  final bool isAbsorbing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: color979797,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 5.0),
              child: AbsorbPointer(
                absorbing: isAbsorbing,
                child: CupertinoTextField(
                  controller: TextEditingController(),
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 2,
                  padding: const EdgeInsets.all(5.0),
                  placeholder: "",
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: MaterialButton(
                        // splashRadius: 15,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        height: 30,
                        minWidth: 30,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {},
                        child: const Icon(
                          Icons.tag_faces,
                          color: color007AFF,
                        )),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: MaterialButton(
                        // splashRadius: 15,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        height: 30,
                        minWidth: 30,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {},
                        child: SvgPicture.asset(
                          AssetIcons.icSend,
                        )),
                  ),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ),
          ),
          // Container(
          //     alignment: Alignment.center,
          //     child: MaterialButton(
          //       elevation: 0.0,
          //       padding: EdgeInsets.zero,
          //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //       minWidth: 60,
          //       height: 35,
          //       color: Colors.blue,
          //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), topRight: Radius.circular(50))),
          //       onPressed: () {},
          //       child: Text(
          //         "POST",
          //       ),
          //     ))
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 45.0,
              width: 45.0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
                child: CachedNetworkDynamic(
                  imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            SpaceHepler.horizontalSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sauvik Ray",
                    style: body14Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
                  ),
                  SpaceHepler.verticalSpace(5.0),
                  const Text(
                    "Lorem ipsum dolor sit amet consectetur. Vitae enim ridiculus cursus velit nullam aliquet amet lobortis interdum.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SpaceHepler.verticalSmall,
                  Row(
                    children: [
                      Text(
                        "2 min ago",
                        style: body14Normal(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
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
                          style: body14Bold(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
                        ),
                      )
                    ],
                  ),
                  SpaceHepler.verticalSmall,
                  //Reply Widget
                  const ReplyWidget(),
                ],
              ),
            )
          ],
        ),
        SpaceHepler.verticalMedium,
        customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
      ],
    );
  }
}

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 35.0,
          width: 35.0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            child: CachedNetworkDynamic(
              imageUrl: 'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg',
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        SpaceHepler.horizontalSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sauvik Ray",
                style: body14Bold(darkThemeColor: color656565, lightThemeColor: Colors.black, context: context),
              ),
              SpaceHepler.verticalSpace(5.0),
              const Text(
                "Lorem ipsum dolor sit amet consectetur. Vitae enim ridiculus cursus velit nullam aliquet amet lobortis interdum.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SpaceHepler.verticalSmall,
              Row(
                children: [
                  Text(
                    "2 min ago",
                    style: body14Normal(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
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
                      style: body14Bold(darkThemeColor: color979797, lightThemeColor: color979797, context: context),
                    ),
                  )
                ],
              ),
              SpaceHepler.verticalSmall,
            ],
          ),
        )
      ],
    );
  }
}

class PostDetailsCardWidget extends StatelessWidget {
  const PostDetailsCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // height: 380,
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
          Text(
            'Lorem ipsum dolor sit amet consectetur. Tempor massa nulla nisl integer. Dolor risus imperdiet nulla mattis in malesuada. Arcu ornare vel elit sagittis. Sit cursus integer sagittis aenean orci ultricies sed amet mi. Nunc proin mi rhoncus facilisi arcu feugiat faucibus. Sit eu et mus suscipit elementum aenean elit dolor. Cursus orci lobortis sem facilisis dictum. Nunc id euismod dictum lacus ornare ut laoreet. Diam ac in aliquam amet eu. Morbi sit lectus.',
            style: body14Normal(darkThemeColor: CupertinoColors.inactiveGray, lightThemeColor: color9E9E9E, context: context),
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

class CommentModalWidget extends StatefulWidget {
  const CommentModalWidget({
    super.key,
  });

  @override
  State<CommentModalWidget> createState() => _CommentModalWidgetState();
}

class _CommentModalWidgetState extends State<CommentModalWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKyBoard(context);
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpaceHepler.verticalSmall,
            Container(
              height: 5,
              width: 64,
              decoration: const BoxDecoration(color: color363638),
            ),
            SpaceHepler.verticalMedium,
            Text(
              'Comments',
              style: title24W700(darkThemeColor: Colors.white, lightThemeColor: color040601, context: context),
            ),
            SpaceHepler.verticalMedium,
            Expanded(
              child: CustomScrollView(slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                        width: double.infinity,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return CommentWidget();
                            },
                            separatorBuilder: (context, index) {
                              // return customDivider(context: context, color: colorE5E5EA, thickness: 1.5);
                              return SpaceHepler.verticalSmall;
                            },
                          )),
                          SpaceHepler.verticalMedium,
                        ])),
                  ])),
                ),
              ]),
            ),
            CommentTypeBoxWidget(
              isAbsorbing: false,
            ),
          ],
        ),
      ),
    );
  }
}
