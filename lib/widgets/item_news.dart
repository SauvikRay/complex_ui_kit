import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/utils/size_helper.dart';
import '../service/device_type.dart';
import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/time_utils.dart';
import 'reuse_widget.dart';

class ListTileNews extends StatelessWidget {
  final String? imageUrl;
  final String? newsTitle;
  final String? newsDate;
  final String? newsCategory;
  final Widget? svgPicture;
  final bool? visibility;
  final bool isFab;
  final bool isFromLatest;

  const ListTileNews(
      {super.key,
      required this.imageUrl,
      required this.newsTitle,
      required this.newsDate,
      required this.newsCategory,
      required this.isFab,
      required this.svgPicture,
      this.visibility = false,
      required this.isFromLatest});

  @override
  Widget build(BuildContext context) {
    Brightness systemBrigthness = MediaQuery.of(context).platformBrightness;
    return Container(
      padding: const EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 5.0),
      height: GetDeviceType().deviceType(context) == DeviceType.tablet ? 80 : 110.0,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: systemBrigthness == Brightness.dark ? scaffoldDarkBackground : color979797, width: 0.5))),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: 114,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    child: CachedNetworkDynamic(
                      imageUrl: imageUrl ?? "",
                      boxFit: BoxFit.cover,
                    )),
              ),
              Visibility(
                  visible: visibility!,
                  child: Container(
                    alignment: Alignment.center,
                    height: 87,
                    width:114 ,
                    child: Image.asset(
                      "assets/images/video_logo.png",
                      scale: 16,
                    ),
                  )),
            ],
          ),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: SizedBox(
              height: 87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsTitle ?? "",
                    style: styleF16Normal(context: context, color: color040601, systemBrigthness: systemBrigthness),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // spacerHeight(context, 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: newsCategory!.length > 15 ? "$newsCategory".substring(0, 10) : "$newsCategory",
                              style: styleF12W400(context: context, color: color979797, systemBrigthness: Brightness.light).copyWith(),
                              children: [
                                TextSpan(
                                    text: newsCategory != '' ? " - ${TimeUtils.timePassed(newsDate ?? '')}" : TimeUtils.timePassed(newsDate ?? ''),
                                    style: styleF12W400(context: context, color: color979797, systemBrigthness: Brightness.light)),
                              ]),
                        ),
                      ),
                      svgPicture != null ? svgPicture! : const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SpaceHepler.horizontalSmall
        ],
      ),
    );
  }
}
