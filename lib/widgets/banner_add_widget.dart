import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../service/ads_service/ads_manager.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, required this.adSize, this.type});

  final BannerAdSize adSize;
  final String? type;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> with AutomaticKeepAliveClientMixin {
  BannerAd? bannerAd;
  bool isLoaded = false;
  @override
  void initState() {
    bannerAd = AdsManager().loadAd(widget.adSize, (isLoaded) {
      this.isLoaded = isLoaded;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return bannerAd != null
        ? Visibility(
            visible: isLoaded,
            child: AnimatedOpacity(
              opacity: isLoaded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 350),
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    height: bannerAd?.size.height.toDouble(),
                    width: bannerAd?.size.width.toDouble(),
                    child: AdWidget(
                      ad: bannerAd!,
                    )),
              ),
            ))
        : Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
