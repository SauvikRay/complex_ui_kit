import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../drawer/nav_drawer.dart';

import '../utils/asset_icons.dart';
import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/size_helper.dart';
import '../widgets/appbar_with_tabbar.dart';
import '../widgets/base_action_button.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_cupertino_segment_control.dart';
import '../widgets/custom_devider.dart';
import '../widgets/icon_list_tile.dart';
import 'community_controller.dart';
import 'community_profile/community_profile.dart';
import 'search_screen/search_screen.dart';
import 'tabs/chat_tab.dart';
import 'tabs/news_feed_tab.dart';
import 'tabs/post_tab.dart';
import 'tabs/timeline_tab.dart';
import 'timeline_screen/timeline_controller.dart';

class CommunityNavigationScreen extends StatefulWidget {
  const CommunityNavigationScreen({super.key});

  @override
  State<CommunityNavigationScreen> createState() => _CommunityNavigationScreenState();
}

class _CommunityNavigationScreenState extends State<CommunityNavigationScreen> with TickerProviderStateMixin {
  final CommunityController communityController = Get.put(CommunityController());
  final TimelineController timelineController = Get.put(TimelineController());
  GlobalKey communityTabBarKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey tabBarKey = GlobalKey();
  int currentIndex = 0;

  late TabController tabController;
  late TabController tabBarViewController;
  int titleindex = 0;
  List<String> appBarTitle = ['Timeline', 'Post', 'Comments', 'Jobs', 'Cars', 'Review', 'My Content', 'My Document', 'My Post Comment', 'News Feed', 'Listings', 'Follow', 'Chat'];
  List<String> tabName = ['Timeline', 'Post', 'Comments', 'Jobs', 'Cars', 'Review', 'My Content', 'My Document', 'My Post Comment'];
  List<Widget> pageList = const <Widget>[
    NewsFeedTab(),
    Center(
      child: Text('Listings '),
    ),
    Center(
      child: Text('Follow'),
    ),
    ChaTab()
  ];

  String _buildAppBarTitle(int index) {
    log('Title index ${titleindex}');
    return appBarTitle[index];
  }

  List<Widget> _buildTabList(List<String> tabNameList) {
    return tabNameList
        .map((tabName) => Tab(
              child: Text(tabName),
            ))
        .toList();
  }

  List<Widget> tabBarItemList = [];
  List<Widget> _buildTabBarPage() {
    if (tabBarItemList.isEmpty) {
      for (int i = 0; i < tabName.length; i++) {
        if (tabName[i] == 'Timeline') {
          tabBarItemList.add(const TimeLineTab());
        } else if (tabName[i] == 'Post') {
          tabBarItemList.add(const PostTab());
        } else {
          tabBarItemList.add(Center(
            child: Text(tabName[i]),
          ));
        }
      }
      tabBarItemList.addAll(pageList);
    }
    return tabBarItemList;
  }

  @override
  void initState() {
    tabController = TabController(length: tabName.length, vsync: this);

    tabBarViewController = TabController(length: tabName.length + pageList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AllNewsDrawer(scaffoldKey: scaffoldKey),
      appBar: FlutterCupertinoAppBarWithTabBar(
        padding: EdgeInsetsDirectional.zero,
        backgroundColor: allNewsBackgroundColor(context),
        automaticallyImplyMiddle: true,
        leading: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 20,
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu_rounded),
        ),
        middle: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.0, -2.0), end: const Offset(0, 0.0)).animate(animation),
              child: child,
            );
          },
          child: Text(
            key: ValueKey(_buildAppBarTitle(titleindex)),
            _buildAppBarTitle(titleindex),
            style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: color979797),
          ),
        ),
        trailing: titleindex == 9
            ? _searchAndFilter()
            : GestureDetector(
                onTap: () {
                  Get.to(() => const CommunityProfileScreen());
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 15.0),
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  width: 100.0,
                  child: SvgPicture.asset(
                    "assets/images/ic_profile.svg",
                    width: 20.0,
                    height: 20.0,
                    semanticsLabel: 'Profile',
                  ),
                ),
              ),
        bottom: currentIndex >= 2
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: tabController,
                        padding: const EdgeInsets.all(0.0),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        labelColor: contextColor(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color040601),
                        indicatorColor: color007AFF,
                        unselectedLabelColor: contextColor(context: context, darkThemeColor: color949494, lightThemeColor: color040601),
                        isScrollable: true,
                        labelStyle: selectedTab16W700(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
                        unselectedLabelStyle: unSelectedTab16W400(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
                        tabs: _buildTabList(tabName),
                        onTap: (int tabIndex) {
                          _onTapBarTap(tabIndex);
                        },
                      ),
                    ),
                    customDivider(context: context, color: Colors.black12, thickness: 1),
                  ],
                ),
              ),
      ),

      // CupertinoAppbar(
      //   title: Text(
      //     _buildAppBarTitle(titleindex),
      //     style: title16W500(context: context, lightThemeColor: color363638, darkThemeColor: color979797),
      //   ),
      //   leadingWidget: IconButton(
      //     padding: EdgeInsets.zero,
      //     splashRadius: 20,
      //     onPressed: () {
      //       scaffoldKey.currentState?.openDrawer();
      //     },
      //     icon: const Icon(Icons.menu_rounded),
      //   ),
      //   trailingWidget: titleindex == 9
      //       ? _searchAndFilter()
      //       : Container(
      //           padding: const EdgeInsets.only(right: 15.0),
      //           alignment: Alignment.centerRight,
      //           color: Colors.transparent,
      //           width: 100.0,
      //           child: SvgPicture.asset(
      //             "assets/images/ic_profile.svg",
      //             width: 20.0,
      //             height: 20.0,
      //             semanticsLabel: 'Profile',
      //           ),
      //         ),
      //   toolbarHeight: currentIndex >= 2 ? null : 50 + MediaQuery.paddingOf(context).top,
      //   bottom: currentIndex >= 2
      //       ? null
      //       : PreferredSize(
      //           preferredSize: const Size.fromHeight(25),
      //           child: AnimatedOpacity(
      //             opacity: currentIndex >= 2 ? 0 : 1,
      //             duration: const Duration(seconds: 1),
      //             child: Column(
      //               children: [
      //                 Align(
      //                   alignment: Alignment.centerLeft,
      //                   child: TabBar(
      //                     controller: tabController,
      //                     padding: const EdgeInsets.all(0.0),
      //                     labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      //                     labelColor: contextColor(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color040601),
      //                     indicatorColor: color007AFF,
      //                     unselectedLabelColor: contextColor(context: context, darkThemeColor: color949494, lightThemeColor: color040601),
      //                     isScrollable: true,
      //                     labelStyle: selectedTab16W700(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
      //                     unselectedLabelStyle: unSelectedTab16W400(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
      //                     tabs: _buildTabList(tabName),
      //                     onTap: (int tabIndex) {
      //                       _onTapBarTap(tabIndex);
      //                     },
      //                   ),
      //                 ),
      //                 customDivider(context: context, color: Colors.black12, thickness: 1),
      //               ],
      //             ),
      //           )),
      // ),

      body: TabBarView(
        controller: tabBarViewController,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildTabBarPage(),
      ),
      bottomNavigationBar: CustomCupertinoTabBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // log('bottom tab index $index');
          _onBottomNavigationTap(index);
        },
        // activeColor: color007AFF,
        // inactiveColor: iconColor(context),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetIcons.icHome,
              semanticsLabel: 'Timeline',
              colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AssetIcons.icHome,
              colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
              semanticsLabel: 'Timeline',
            ),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetIcons.icNewsFeed,
              semanticsLabel: 'News Feed',
              colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AssetIcons.icNewsFeed,
              colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
              semanticsLabel: 'News Feed',
            ),
            label: 'News Feed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetIcons.icList,
              semanticsLabel: 'Listings',
              colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AssetIcons.icList,
              colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
              semanticsLabel: 'Listings',
            ),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetIcons.icfollow,
              semanticsLabel: 'Follow',
              colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AssetIcons.icfollow,
              colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
              semanticsLabel: 'Follow',
            ),
            label: 'Follow',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetIcons.icChat,
              semanticsLabel: 'Chat',
              colorFilter: ColorFilter.mode(iconColor(context), BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AssetIcons.icChat,
              colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
              semanticsLabel: 'Chat',
            ),
            label: 'Chat',
          )
        ],
      ),
    );
  }

  _searchAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BaseIconButton(
              onPressed: () {
                Get.to(() => const CommunitySearchScreen(), transition: Transition.rightToLeft);
              },
              icon: AssetIcons.icCommunitySearch,
            ),
            SpaceHepler.horizontalSmall,
            BaseIconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return const FilterWidget();
                    });
              },
              icon: AssetIcons.icFilter,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapBarTap(int tabIndex) {
    tabBarViewController.animateTo(tabIndex, duration: Durations.medium3, curve: Curves.ease);
    if (tabIndex == 0) {
      setState(() {
        currentIndex = tabIndex;
        titleindex = tabIndex;
      });
    }
    setState(() {
      titleindex = tabIndex;
    });
  }

  void _onBottomNavigationTap(int index) {
    return setState(() {
      currentIndex = index;

      if (index == 0) {
        tabController.animateTo(0, duration: Durations.medium3, curve: Curves.ease);
        tabBarViewController.animateTo(0, duration: Durations.medium3, curve: Curves.ease);
        titleindex = 0;
      } else {
        // log('Maked page index $pageIndex');
        if (tabController.index > 0) {
          tabController.animateTo(0, duration: Durations.medium3, curve: Curves.ease);
        }
        titleindex = 8 + currentIndex;
        tabBarViewController.animateTo(8 + currentIndex, duration: Durations.medium3, curve: Curves.ease);
      }

      // log('Current tabbarView index = ${tabBarViewController.index}');
    });
  }
}

enum SortBy { latest, oldest }

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  SortBy _selectedSegment = SortBy.latest;
  List<IconListTileModel> iconList = [
    IconListTileModel(icon: AssetIcons.icJournalist, title: 'Journalist'),
    IconListTileModel(icon: AssetIcons.icCompany, title: 'Companies'),
    IconListTileModel(icon: AssetIcons.icCelebraty, title: 'Celebrities'),
    IconListTileModel(icon: AssetIcons.icPlayer, title: 'Sport Player'),
    IconListTileModel(icon: AssetIcons.icPlayer, title: 'Sport Team'),
    IconListTileModel(icon: AssetIcons.icLocalNews, title: 'Local News'),
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 550),
        child: SizedBox(
            width: double.infinity,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SpaceHepler.verticalSmall,
              Container(
                height: 5,
                width: 64,
                decoration: const BoxDecoration(color: color363638),
              ),
              SpaceHepler.verticalBig,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetIcons.icFilter2),
                  SpaceHepler.horizontalSmall,
                  Text(
                    'Filter',
                    style: title24W700(darkThemeColor: Colors.white, lightThemeColor: color040601, context: context),
                  ),
                ],
              ),
              SpaceHepler.verticalBig,
              customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              Flexible(
                  child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: iconList.length,
                itemBuilder: (context, index) {
                  IconListTileModel iconTile = iconList[index];
                  return IconListTile(
                      icon: iconTile.icon,
                      title: iconTile.title,
                      onPressed: () {
                        // Get.to(() => CreatePostScreen());
                      });
                },
                separatorBuilder: (context, index) {
                  return customDivider(context: context, color: colorE5E5EA, thickness: 1.5);
                },
              )),
              customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              SpaceHepler.verticalMedium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'Sort By :',
                      style: body14Bold(darkThemeColor: CupertinoColors.inactiveGray, lightThemeColor: color363638, context: context),
                    ),
                    const Spacer(),
                    CustomCupertinoSegmentedControl(
                        selectedColor: color007AFF,
                        unselectedColor: Colors.transparent,
                        groupValue: _selectedSegment,
                        children: <SortBy, Widget>{
                          SortBy.latest: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Latest',
                              style: body14W400(
                                  darkThemeColor: _selectedSegment == SortBy.latest ? Colors.white : color007AFF,
                                  lightThemeColor: _selectedSegment == SortBy.latest ? Colors.white : color007AFF,
                                  context: context),
                            ),
                          ),
                          SortBy.oldest: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Oldest',
                                style: body14W400(
                                    darkThemeColor: _selectedSegment == SortBy.oldest ? Colors.white : color007AFF,
                                    lightThemeColor: _selectedSegment == SortBy.oldest ? Colors.white : color007AFF,
                                    context: context)),
                          )
                        },
                        onValueChanged: (SortBy data) {
                          setState(() {
                            _selectedSegment = data;
                          });
                        }),
                  ],
                ),
              ),
              SpaceHepler.verticalSmall,
              customDivider(context: context, color: colorE5E5EA, thickness: 1.5),
              SpaceHepler.verticalMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 130, child: BaseActionButton(title: 'Set Filter', bgColor: color007AFF, textColor: Colors.white, onPress: () {})),
                  SpaceHepler.horizontalSmall,
                  SizedBox(
                      width: 130,
                      child: OutLineBaseButton(
                          title: 'Cancel',
                          textColor: color007AFF,
                          onPress: () {
                            Get.back();
                          }))
                ],
              ),
              SpaceHepler.verticalMedium,
              SpaceHepler.verticalMedium,
            ])),
      ),
    );
  }
}
