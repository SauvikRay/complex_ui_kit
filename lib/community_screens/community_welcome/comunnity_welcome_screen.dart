import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ui_kit/widgets/custom_appbar.dart';
import '../../utils/asset_icons.dart';
import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/helper_functions.dart';
import '../../utils/size_helper.dart';
import '../../utils/system_annoteded_region.dart';
import '../../widgets/appbar_with_tabbar.dart';
import '../../widgets/base_action_button.dart';
import '../../widgets/base_edit_text.dart';
import '../community_navigation_bar.dart';

class CommunityWelcomeScreen extends StatefulWidget {
  const CommunityWelcomeScreen({super.key});

  @override
  State<CommunityWelcomeScreen> createState() => _CommunityWelcomeScreenState();
}

class _CommunityWelcomeScreenState extends State<CommunityWelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      OnBoardingPageOne(
        onPressed: () {
          _pageController.animateToPage(1, duration: const Duration(milliseconds: 350), curve: Curves.decelerate);
        },
      ),
      OnBoardingPageTwo(
        onPressed: () {
          Get.offAll(() => CommunityNavigationScreen());
        },
      )
    ];
  }

  String _changeAppbarTitle(int index) {
    switch (index) {
      case 0:
        return 'Join Community';
      case 1:
        return 'Select Area';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
        Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    return Semantics(
      container: true,

      child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: systemBrightness == Brightness.dark ? Brightness.dark : Brightness.light,
        statusBarColor: systemBrightness == Brightness.dark ? scaffoldDarkBackground : colorWhite,
        statusBarIconBrightness: systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: systemBrightness == Brightness.dark ? scaffoldDarkBackground : colorWhite,
      ),
        child: Material(
          child: GestureDetector(
            onTap: () {
              hideKyBoard(context);
            },
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar:FlutterCupertinoAppBarWithTabBar(
                  backgroundColor: allNewsBackgroundColor(context),
                  middle: Text(
                    _changeAppbarTitle(_currentPageIndex),
                    style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: color979797),
                  ),
                  leading: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
          
                // CupertinoNavigationBar(
                //   backgroundColor: allNewsBackgroundColor(context),
                //   padding: EdgeInsetsDirectional.zero,
                //   leading: Material(
                //     color: Colors.transparent,
                //     child: IconButton(
                //       splashRadius: 20,
                //       onPressed: () {
                //         Get.back();
                //       },
                //       icon: const Icon(Icons.arrow_back_rounded),
                //     ),
                //   ),
                //   middle: AnimatedSwitcher(
                //     duration: const Duration(milliseconds: 500),
                //     transitionBuilder: (child, animation) {
                //       return FadeTransition(
                //         opacity: animation,
                //         child: child,
                //       );
                //     },
                //     child: Text(
                //       key: ValueKey(_currentPageIndex),
                //       _changeAppbarTitle(_currentPageIndex),
                //       style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: Colors.white),
                //     ),
                //   ),
                // ),
          
                body: Center(
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (index) {
                        _currentPageIndex = index;
                        setState(() {});
                      },
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        return pages[index];
                      }),
                )),
          ),
        ),
      ),
    );
  }
}

class OnBoardingPageOne extends StatelessWidget {
  const OnBoardingPageOne({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 284,
                child: Text(
                  "Welcome to AllNews Community",
                  textAlign: TextAlign.center,
                  style: title24W700(context: context, lightThemeColor: color040601, darkThemeColor: Colors.white),
                ),
              ),
            ),
            SpaceHepler.verticalMedium,
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 320,
                child: Text(
                  "Lorem ipsum dolor sit amet consectetur. Sed feugiat iaculis phasellus vel vitae ac et suspendisse.",
                  textAlign: TextAlign.center,
                  style: body12W400(context: context, lightThemeColor: color040601, darkThemeColor: Colors.white),
                ),
              ),
            ),
            SpaceHepler.verticalBig,
            SpaceHepler.verticalMedium,
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(AssetIcons.icCommunity1),
            ),
            SpaceHepler.verticalBig,
            SpaceHepler.verticalMedium,
            SizedBox(
              width: 260,
              child: BaseActionButton(title: 'Join Community', bgColor: color007AFF, textColor: Colors.white, onPress: onPressed),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingPageTwo extends StatelessWidget {
  const OnBoardingPageTwo({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    _selectStatePopUp() {
      showCupertinoModalPopup<void>(
        context: context,

        // barrierColor: Colors.black.withOpacity(.5),
        builder: (BuildContext context) => SearchBoxWithItemSheet(),
      );
    }

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 284,
                child: Text(
                  "Welcome to AllNews Community",
                  textAlign: TextAlign.center,
                  style: title24W700(context: context, lightThemeColor: color040601, darkThemeColor: Colors.white),
                ),
              ),
            ),
            SpaceHepler.verticalMedium,
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 320,
                child: Text(
                  "To see news and local content near you, select your area",
                  textAlign: TextAlign.center,
                  style: body12W400(context: context, lightThemeColor: color040601, darkThemeColor: Colors.white),
                ),
              ),
            ),
            SpaceHepler.verticalMedium,
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(AssetIcons.icCommunity2),
            ),
            SpaceHepler.verticalMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: OutlinedDropBox(
                onPressed: () {
                  _selectStatePopUp();
                },
                hintText: 'Select State',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SvgPicture.asset(
                    AssetIcons.icState,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SpaceHepler.verticalMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: OutlinedDropBox(
                onPressed: () {
                  _selectStatePopUp();
                },
                hintText: 'Select Local government',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SvgPicture.asset(
                    AssetIcons.icGovt,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SpaceHepler.verticalMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: OutlinedDropBox(
                onPressed: () {
                  _selectStatePopUp();
                },
                hintText: 'Select town',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SvgPicture.asset(
                    AssetIcons.icState,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SpaceHepler.verticalBig,
            SpaceHepler.verticalMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: BaseActionButton(title: 'Save & continue', bgColor: color007AFF, textColor: Colors.white, onPress: onPressed),
            ),
            SpaceHepler.verticalBig,
          ],
        ),
      ),
    );
  }
}

class OutlinedDropBox extends StatelessWidget {
  const OutlinedDropBox({super.key, required this.onPressed, this.controller, this.prefixIcon, this.hintText});
  final VoidCallback onPressed;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: GestureDetector(
        onTap: onPressed,
        child: AbsorbPointer(
          child: TextFormField(
            // enabled: false,
            controller: controller,
            onTap: () {
              log('TextField Tap');
              hideKyBoard(context);
            },
            decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 35,
                ),
                prefixIcon: prefixIcon,
                hintText: hintText,
                border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: color979797.withOpacity(0.6)), borderRadius: BorderRadius.circular(100))),
          ),
        ),
      ),
    );
  }
}

class SearchBoxWithItemSheet extends StatelessWidget {
  const SearchBoxWithItemSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController(text: '');
    return Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: GestureDetector(
        onTap: () {
          hideKyBoard(context);
        },
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 400),
            child: SizedBox(
              width: double.infinity,
              child: Column(
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
                    'Select State',
                    style: title24W700(darkThemeColor: Colors.white, lightThemeColor: color040601, context: context),
                  ),
                  SpaceHepler.verticalBig,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: BaseEditText(
                      textController: searchController,
                      placeHolder: 'Search State',
                    ),
                  ),
                  SpaceHepler.verticalMedium,
                  Expanded(
                      child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: strList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        minVerticalPadding: 20,
                        title: Text(
                          strList[index],
                          style: body14W400(darkThemeColor: Colors.white, lightThemeColor: color363638, context: context),
                        ),
                        onTap: () {
                          hideKyBoard(context);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        color: colorE5E5EA,
                      );
                    },
                  )),
                  const Divider(
                    height: 1,
                    color: color363638,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> strList = [
  'Khulna',
  'Dhaka',
  'Rajshahi',
  'Barishal',
  'Syllet',
  'Pabna',
  'Gopalgonj',
  'Hatirjhil',
  'KuaKata',
  'Bandarbon',
  'Noyakhali',
  'Kumilla',
  'Chadpur',
  'jhalokhathi',
  'Kustia',
  'Jessore'
];
