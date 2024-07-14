import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/asset_icons.dart';
import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/helper_functions.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../widgets/all_decoration.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/base_action_button.dart';
import '../../widgets/custom_cupertino_segment_control.dart';
import '../../widgets/custom_devider.dart';
import '../../widgets/drawer_tile_widget.dart';
import '../../widgets/reuse_widget.dart';

enum CreatePostType { public, myArea }

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  CreatePostType _selectedSegment = CreatePostType.public;
  final TextEditingController _postController = TextEditingController();
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
            'Create Post',
            style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: color979797),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            hideKyBoard(context);
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpaceHepler.verticalBig,
                //Custom Segment Control
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 300,
                    child: CustomCupertinoSegmentedControl(
                        selectedColor: color007AFF,
                        unselectedColor: Colors.transparent,
                        groupValue: _selectedSegment,
                        children: <CreatePostType, Widget>{
                          CreatePostType.public: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Public',
                              style: body14W400(
                                  darkThemeColor: _selectedSegment == CreatePostType.public ? Colors.white : color007AFF,
                                  lightThemeColor: _selectedSegment == CreatePostType.public ? Colors.white : color007AFF,
                                  context: context),
                            ),
                          ),
                          CreatePostType.myArea: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text('My Area',
                                style: body14W400(
                                    darkThemeColor: _selectedSegment == CreatePostType.myArea ? Colors.white : color007AFF,
                                    lightThemeColor: _selectedSegment == CreatePostType.myArea ? Colors.white : color007AFF,
                                    context: context)),
                          )
                        },
                        onValueChanged: (CreatePostType data) {
                          setState(() {
                            _selectedSegment = data;
                          });
                        }),
                  ),
                ),
                SpaceHepler.verticalMedium,
                //Post Box
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: borderBoxDecoration,
                  // height: ,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SpaceHepler.horizontalSmall,
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(hintText: "Share Your Information", border: InputBorder.none),
                        keyboardType: TextInputType.multiline,
                        maxLines: 18,
                      )),
                    ],
                  ),
                ),
                SpaceHepler.verticalBig,
                SpaceHepler.verticalSmall,

                customDivider(context: context, color: Colors.black12, thickness: 1),
                SpaceHepler.verticalSpace(3),
                DrawerTileWidget(
                  title: 'Upload Photos',
                  textStyle: title16Normal(darkThemeColor: Colors.white, lightThemeColor: color363638, context: context),
                  icon: AssetIcons.icUpload,
                  height: 30,
                  width: 30,
                  onPressed: () {},
                ),
                SpaceHepler.verticalSpace(3),
                customDivider(context: context, color: Colors.black12, thickness: 1),
                SpaceHepler.verticalSpace(3),
                DrawerTileWidget(
                  title: 'Select Location',
                  isActive: false,
                  textStyle: title16Normal(darkThemeColor: Colors.white, lightThemeColor: color363638, context: context),
                  icon: AssetIcons.icLocation,
                  height: 30,
                  width: 30,
                  onPressed: () {},
                ),
                SpaceHepler.verticalSpace(3),
                customDivider(context: context, color: Colors.black12, thickness: 1),
                SpaceHepler.verticalBig,
                SizedBox(width: 260, child: BaseActionButton(title: 'Publish Post', bgColor: color007AFF, textColor: Colors.white, onPress: () {})),
                SpaceHepler.verticalSmall,
                SizedBox(width: 260, child: OutLineBaseButton(title: 'Clear Post', textColor: color007AFF, onPress: () {})),
                SpaceHepler.verticalBig,
                SpaceHepler.verticalBig,
                SpaceHepler.verticalBig,
                SpaceHepler.verticalBig,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
