import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentHelper {
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await _loadConsentData();
      } else {
        await _initialize();
      }
      completer.complete();
    }, (error) {
      completer.complete(error);
    });
    if (kDebugMode) {
      log('Comple $completer');
    }
    return completer.future;
  }

  Future<FormError?> _loadConsentData() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm((consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show((formError) {
          completer.complete(_loadConsentData());
        });
      } else {
        await _initialize();
        completer.complete();
      }
    }, (formError) {
      completer.complete(formError);
    });
    if (kDebugMode) {
      log('_loadConsentData: $completer');
    }
    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();

    /**
     * Here you can place any other initialization of any
     * other component that depends on consent management,
     * for example the initialization of Google Analytics
     * or Google Crashlytics would go here.
     */
  }
}
