import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// import '../news_screens/home/userdetails/bookmarks/bookmark_controller.dart';
import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/size_helper.dart';

class NewsDetailsAppbar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const NewsDetailsAppbar({super.key, required this.title, required this.newsUrl, required this.onBoorkMark, required this.onShare});
  final String title;
  final VoidCallback onShare;
  final VoidCallback? onBoorkMark;
  // final BookmarkController bookmarkController;
  final String newsUrl;

  @override
  Widget build(BuildContext context) {
    Brightness systemBrigthness = MediaQuery.of(context).platformBrightness;
    return CupertinoNavigationBar(
      automaticallyImplyMiddle: false,
      backgroundColor: systemBrigthness == Brightness.dark ? colorBlack12 : colorF2F2F7,
      padding: EdgeInsetsDirectional.zero,
      automaticallyImplyLeading: false,
      leading: SizedBox(
        width: 180.0,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
              splashRadius: 5.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back(result: true);
              },
              icon: Row(
                children: [
                  const Icon(CupertinoIcons.back),
                  Text(
                    title.toUpperCase(),
                    style: styleF14W600(context: context, color: colorGrey, systemBrigthness: systemBrigthness),
                  )
                ],
              )),
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            height: 35,
            minWidth: 35,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: onShare,
            child: SvgPicture.asset(
              systemBrigthness == Brightness.dark ? "assets/images/share_icon_white.svg" : "assets/images/share_icon_dark.svg",
              width: 20.0,
              height: 20.0,
              fit: BoxFit.fill,
            ),
          ),
          MaterialButton(
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              height: 35,
              minWidth: 35,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              onPressed: onBoorkMark,
              child: Obx(() {
                // if (bookmarkController.slugList.contains(newsUrl)) {
                if (newsUrl != '') {
                  return SvgPicture.asset(
                    "assets/images/svg_active.svg",
                    width: 20.0,
                    height: 20.0,
                  );
                } else {
                  return SvgPicture.asset(
                    systemBrigthness == Brightness.dark ? "assets/images/ic_bookmark_white.svg" : "assets/images/ic_bookmark_details.svg",
                    width: 20.0,
                    height: 20.0,
                  );
                }
              })),
          spacerWidth(context, 10),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kMinInteractiveDimension - 5);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
