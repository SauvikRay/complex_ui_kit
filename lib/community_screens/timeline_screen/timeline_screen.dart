// import 'package:flutter/material.dart';

// import '../../utils/all_news_colors.dart';
// import '../../utils/common_style.dart';
// import '../../widgets/custom_devider.dart';

// import 'tabs/timeline_tab.dart';

// class TimelineScreen extends StatefulWidget {
//   const TimelineScreen({super.key});

//   @override
//   State<TimelineScreen> createState() => _TimelineScreenState();
// }

// class _TimelineScreenState extends State<TimelineScreen> with TickerProviderStateMixin {
//   late TabController tabController;
//   List<String> tabName = [
//     'Timeline',
//     'Post',
//     'Comments',
//     'Jobs',
//     'Cars',
//     'Review',
//     'My Content',
//     'My Document',
//     'My Post Comment',
//   ];
//   @override
//   void initState() {
//     tabController = TabController(length: tabName.length, vsync: this);
//     super.initState();
//   }

//   List<Widget> _makeTabList(List<String> tabNameList) {
//     return tabNameList
//         .map((tabName) => Tab(
//               child: Text(tabName),
//             ))
//         .toList();
//   }

//   List<Widget> _makeTabBarPage(List<String> tabNameList) {
//     return tabNameList
//         .map((tabName) => tabName == 'Timeline'
//             ? const TimeLineTab()
//             : Center(
//                 child: Text(tabName),
//               ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: PreferredSize(
//         //     preferredSize: const Size.fromHeight(kToolbarHeight),
//         //     child: Column(
//         //       children: [
//         //         Align(
//         //           alignment: Alignment.centerLeft,
//         //           child: TabBar(
//         //               controller: tabController,
//         //               padding: const EdgeInsets.all(0.0),
//         //               labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //               labelColor: contextColor(context: context, darkThemeColor: colorE5E5EA, lightThemeColor: color040601),
//         //               indicatorColor: color007AFF,
//         //               unselectedLabelColor: contextColor(context: context, darkThemeColor: color949494, lightThemeColor: color040601),
//         //               isScrollable: true,
//         //               labelStyle: selectedTab16W700(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
//         //               unselectedLabelStyle: unSelectedTab16W400(context: context, darkThemeColor: color979797, lightThemeColor: color040601),
//         //               tabs: _makeTabList(tabName)),
//         //         ),
//         //         customDivider(context: context, color: Colors.black12, thickness: 1),
//         //       ],
//         //     )),
//         body: Center(
//       child: Text('Time Line Page'),
//     )
//         // TabBarView(
//         //   controller: tabController,
//         //   physics: const AlwaysScrollableScrollPhysics(),
//         //   children: _makeTabBarPage(tabName),
//         // )
//         );
//   }
// }
