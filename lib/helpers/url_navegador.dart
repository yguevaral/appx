
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

void showUrlNavegadorInterno(String url) {

    FlutterWebBrowser.openWebPage(
      url: url,
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );

  }