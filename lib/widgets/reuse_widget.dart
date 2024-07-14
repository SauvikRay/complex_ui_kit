import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/size_helper.dart';
import '../utils/time_utils.dart';

class PhotoSingleReuse extends StatelessWidget {
  const PhotoSingleReuse({
    super.key,
    required this.modelImage,
    required this.modelCreated,
    required this.modelTitle,
  });

  final String modelImage;
  final String modelCreated;
  final String modelTitle;

  @override
  Widget build(BuildContext context) {
    log('Photo item build');
    Brightness systemBrigthness = MediaQuery.of(context).platformBrightness;
    return SizedBox(
      height: AllScreenSize.responsiveWidth(context, 154.0),
      width: AllScreenSize.responsiveWidth(context, 170.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(children: [
          SizedBox(
              height: AllScreenSize.responsiveWidth(context, 154.0),
              width: double.infinity,
              child: CachedNetworkDynamic(
                imageUrl: modelImage,
                boxFit: BoxFit.cover,
              )),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: AllScreenSize.responsiveWidth(context, 3.0), vertical: AllScreenSize.responsiveWidth(context, 2.5)),
                color: const Color(0xFF040601).withOpacity(0.50),
                child: Text(
                  TimeUtils.timePassed(modelCreated),
                  style: styleF12W400(context: context, color: color979797, systemBrigthness: Brightness.light),
                )),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.0, -1),
                  end: const Alignment(0.0, 0.6),
                  colors: [
                    color000000.withOpacity(0.0),
                    color000000.withOpacity(0.20),
                    color000000.withOpacity(0.40),
                    color000000.withOpacity(0.70),
                  ],
                ),
              ),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                modelTitle,
                style: styleF16W500(context: context, color: colorWhite, systemBrigthness: systemBrigthness),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class VideoReuseWidget extends StatelessWidget {
  const VideoReuseWidget({
    super.key,
    required this.modelImage,
    required this.modelCreated,
    required this.modelTitle,
    this.videoLogo = false,
    required this.svgPicture,
  });

  final String modelImage;
  final String modelCreated;
  final String modelTitle;

  final Widget svgPicture;
  final bool videoLogo;

  @override
  Widget build(BuildContext context) {
    log('Video Reuse build');
    Brightness systemBrigthNess = MediaQuery.of(context).platformBrightness;
    return Container(
      width: AllScreenSize.responsiveWidth(context, 168.0),
      decoration: BoxDecoration(
          color: systemBrigthNess == Brightness.dark ? color363638 : Colors.white,
          boxShadow: [
            BoxShadow(color: systemBrigthNess == Brightness.dark ? CupertinoColors.black.withOpacity(.2) : Colors.grey.withOpacity(0.4), blurRadius: 10, spreadRadius: 1, offset: const Offset(4, 4)),
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: AllScreenSize.responsiveWidth(context, 100.0),
                    width: double.infinity,
                    child: CachedNetworkDynamic(
                      imageUrl: modelImage,
                      boxFit: BoxFit.cover,
                    )),
                Visibility(
                  visible: videoLogo,
                  child: Center(
                    child: Image.asset(
                      "assets/images/video_logo.png",
                      scale: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modelTitle,
                    maxLines: 2,
                    style: styleF16Normal(context: context, color: colorBlack12, systemBrigthness: systemBrigthNess),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TimeUtils.timePassed(modelCreated),
                            style: styleF12W400(context: context, color: color979797, systemBrigthness: Brightness.light),
                          ),
                          svgPicture,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class CachedNetworkDynamic extends StatelessWidget {
  const CachedNetworkDynamic({super.key, required this.imageUrl, this.boxFit = BoxFit.cover, this.isFromNewsDetails = false, this.height, this.width});

  final String imageUrl;
  final BoxFit? boxFit;
  final bool? isFromNewsDetails;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return isFromNewsDetails == true
        ? Image.network(
            imageUrl,
            fit: boxFit,
            loadingBuilder: (context, child, loadingProgress) {
              return const Center(child: CupertinoActivityIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/default.png",
                fit: BoxFit.cover,
              );
            },
          )
        : CachedNetworkImage(
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/default.png",
              fit: BoxFit.cover,
            ),
            fit: boxFit,
            cacheKey: imageUrl,
            imageUrl: imageUrl,
            repeat: ImageRepeat.noRepeat,
            imageBuilder: (context, imageProvider) {
              debugPrint('Cached Newtowk image build multiple');
              return Container(height: height, width: width, decoration: (BoxDecoration(image: DecorationImage(image: imageProvider, fit: boxFit))));
            },
            placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
          );
  }
}
