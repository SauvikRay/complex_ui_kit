import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../community_screens/community_welcome/comunnity_welcome_screen.dart';
import '../utils/asset_icons.dart';
import '../utils/colors.dart';
import '../utils/size_helper.dart';
import '../widgets/drawer_tile_widget.dart';
import 'drawer_controller.dart';

class AllNewsDrawer extends StatelessWidget {
  const AllNewsDrawer({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.put(NewsDrawerController());
    return Drawer(
      backgroundColor: allNewsBackgroundColor(context),
      width: 220,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpaceHepler.verticalSpace(30),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(MediaQuery.of(context).platformBrightness == Brightness.dark ? AssetIcons.icMainDarkLogo : AssetIcons.icMainLightLogo)),
            SpaceHepler.verticalMedium,
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            DrawerTileWidget(
              title: 'News',
              icon: AssetIcons.icNewsDrawerLight,
              isActive: drawerController.findActivePage(routeNAme: '/NewsNavigationScreen'),
              onPressed: () {
                scaffoldKey.currentState?.closeDrawer();
                if (Get.currentRoute == '/NewsNavigationScreen') {
                  return;
                }
                // Get.offAll(() => const NewsNavigationScreen());
              },
            ),
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            DrawerTileWidget(
              title: 'Community',
              icon: 'assets/images/ic_drawer_community.svg',
              isActive: drawerController.findActivePage(routeNAme: '/CommunityNavigationScreen'),
              onPressed: () {
                scaffoldKey.currentState?.closeDrawer();
                if (Get.currentRoute == '/CommunityNavigationScreen') {
                  return;
                }
                // Get.offAll(() => const CommunityNavigationScreen());
                Get.to(() => const CommunityWelcomeScreen());
              },
            ),
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            const Spacer(),
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            DrawerTileWidget(
              title: 'Rate Us',
              icon: 'assets/images/ic_drawer_rate.svg',
              onPressed: () {},
            ),
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            DrawerTileWidget(
              title: 'Share Us',
              icon: 'assets/images/ic_drawer_community.svg',
              onPressed: () {},
            ),
            const Divider(
              color: colorF2F2F7,
              height: 2,
            ),
            DrawerTileWidget(
              title: 'Logout',
              icon: 'assets/images/ic_drawer_logout.svg',
              onPressed: () {},
            ),
            SpaceHepler.verticalMedium,
            SpaceHepler.verticalMedium,
          ],
        ),
      ),
    );
  }
}
