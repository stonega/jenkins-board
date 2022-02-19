import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._();

  static bool isUrl(String input) {
    RegExp regexUrl = RegExp(
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

    if (input.isEmpty) return false;
    return regexUrl.hasMatch(input);
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      log('Can not launch url');
    }
  }

  static String formatDate(DateTime timestamp) {
    return DateFormat.yMd().add_Hm().format(timestamp);
  }
}
