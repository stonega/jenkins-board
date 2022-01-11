import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._();

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      log('Can not launch url');
    }
  }
}
