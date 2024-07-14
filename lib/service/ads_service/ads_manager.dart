import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_key.dart';

class AdsManager {
  static final AdsManager _instance = AdsManager._internal();
  final storage = GetStorage();

  final bannerAdUnitId = GetPlatform.isAndroid ? AdsKey.androidBanner : AdsKey.iosBanner;

  final interstitialAdUnitId = GetPlatform.isAndroid ? AdsKey.androidInterstitial : AdsKey.iosInterstitial;

  InterstitialAd? _interstitialAd;

  int failedAdsRetryCount = 5;
  int retryCount = 0;
  final String LOAD_COUNT = "LOAD_COUNT";
  final String LOAD_FREQUENT_COUNT = "LOAD_FREQUENT_COUNT";

  factory AdsManager() {
    return _instance;
  }

  AdsManager._internal() {
    // initialization logic
  }

  BannerAd loadAd(BannerAdSize adSize, Function(bool isLoaded) onAdLoad, {String caller = ""}) {
    BannerAd bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: _getBannerAdSize(adSize),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded. $caller');
          onAdLoad(true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
          onAdLoad(false);
        },
      ),
    )..load();

    return bannerAd;
  }
// NativeAd loadNativeAds( Function(bool isLoaded) onAdLoad){

//   return NativeAd(
//     //This key is demo
//     adUnitId:Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/2247696110'
//       : 'ca-app-pub-3940256099942544/3986624511',
//   request:const AdRequest(),
//   listener: NativeAdListener(
//     onAdLoaded: (ad){
//         onAdLoad(true);
//     },
//      onAdFailedToLoad: (ad, err) {
//           debugPrint('NativeAd failed to load: $err');
//           // Dispose the ad here to free resources.
//           ad.dispose();
//           onAdLoad(false);
//         },

//   ),
//   nativeAdOptions: NativeAdOptions(),
//   nativeTemplateStyle:NativeTemplateStyle(templateType: TemplateType.small),

//   )..load();
// }

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    int count = storage.read(LOAD_COUNT) ?? 0;
    int timeToLoadAds = storage.read(LOAD_FREQUENT_COUNT) ?? 0;

    if (_interstitialAd == null) {
      int randomCount = randomInt(1, 4);
      storage.write(LOAD_FREQUENT_COUNT, randomCount);

      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              debugPrint('$ad loaded.');
              // Keep a reference to the ad so you can show it later.
              _interstitialAd = ad;
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('InterstitialAd failed to load: $error');
              _interstitialAd = null;
              if (retryCount < failedAdsRetryCount) {
                loadInterstitialAd();
                retryCount++;
              }
            },
          ));
    }

    if (timeToLoadAds <= count && _interstitialAd != null) {
      _interstitialAd?.show();
      _interstitialAd = null;
      loadInterstitialAd();
      count = 0;
      int randomCount = randomInt(1, 4);
      storage.write(LOAD_FREQUENT_COUNT, randomCount);
      print("onAdShow:  on show $randomCount");
    }
    count++;

    //Log.d(TAG, "loadInterstitialAd: " + count);
    storage.write(LOAD_COUNT, count);
  }

  AdSize _getBannerAdSize(BannerAdSize size) {
    if (Get.size.width > 600) {
      return const AdSize(width: 728, height: 90);
    }
    if (size == BannerAdSize.SMALL) {
      return AdSize.banner;
    } else if (size == BannerAdSize.MEDIUM) {
      return AdSize.mediumRectangle;
    } else if (size == BannerAdSize.LARGE) {
      return AdSize.largeBanner;
    } else if (size == BannerAdSize.FULL) {
      return AdSize.fullBanner;
    } else if (size == BannerAdSize.LEADERBOARD) {
      return AdSize.leaderboard;
    }
    return AdSize.banner;
  }

  int randomInt(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}

enum BannerAdSize { SMALL, MEDIUM, LARGE, FULL, LEADERBOARD, ADAPTIVE }
