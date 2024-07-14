import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';

import '../utils/prefe_keys.dart';

final _storage = GetStorage();

class AppReviewManager {
  static const int minimumLaunchCount = 5;
  static Future<void> requestReviewIfAppropriate(InAppReview inAppReview) async {
    int actionCount = _storage.read(PrefKeys.reviewWorthyCount) ?? 0; //  prefs.getInt(;

    actionCount += 1;

    _storage.write(PrefKeys.reviewWorthyCount, actionCount);

    if (actionCount < minimumLaunchCount) {
      return;
    }

    String currentVersion = await _getAppVersion();
    String lastVersion = _storage.read(PrefKeys.lastReviewRequestAppVersion) ?? '';

    if (lastVersion == currentVersion) {
      _storage.write(PrefKeys.reviewWorthyCount, 0);
      return;
    }

    Timer(const Duration(milliseconds: 300), () async {
      if (kDebugMode) {
        log('Run the rate dialog');
      }
      // Trigger App Store review
      _storage.write(PrefKeys.reviewWorthyCount, 0);
      _storage.write(PrefKeys.lastReviewRequestAppVersion, currentVersion);
      // Add code here to request review in Flutter
      if (await inAppReview.isAvailable()) {
        debugPrint('Available');
        await inAppReview.requestReview();
      } else {
        debugPrint('Unavailable');
      }
    });
  }

  static Future<String> _getAppVersion() async {
    String version = _storage.read(PrefKeys.appVersion) ?? '1.0.0';
    return version;
  }
}
