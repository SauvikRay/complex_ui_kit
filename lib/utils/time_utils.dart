import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

DateTime? worldCurrentTime;
Future<void> worldTime() async {
  var detroit = getLocation('Europe/London');
  worldCurrentTime = TZDateTime.now(detroit);
  log('Europe Time :$worldCurrentTime');
}

class TimeUtils {
  static String dateFormat(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMM dd,yyyy').format(dateTime);
    // log(formattedDate.toString());
    return formattedDate;
  }

  static String timePassed(String time) {
    // log('Time pass called $time');
    String returnTime = '';

    tz.Location london = tz.getLocation('Europe/London');

    // Assuming 'self' is in ISO 8601 format for simplicity
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var previousDate = inputFormat.parse(time, true).toUtc();

    // var nowDate = DateTime.now().toUtc();
    DateTime nowDate = inputFormat.tryParse('$worldCurrentTime', true)!.toUtc();

    // Convert both dates to London time
    var previousDateInLondon = tz.TZDateTime.from(previousDate, london);
    // log('previousDateInLondon:  ${previousDateInLondon.toLocal()}');
    var nowDateInLondon = tz.TZDateTime.from(nowDate, london);

    // log('nowDateInLondon:  ${nowDateInLondon.toUtc()}');

    var duration = nowDateInLondon.difference(previousDateInLondon);
    returnTime = formatDuration(duration); // Implement this based on your needs

    return returnTime;
  }

// Dart doesn't have a direct equivalent to RelativeDateTimeFormatter or DateComponentsFormatter,
// so you might need to implement something similar based on Duration calculations.
  static String formatDuration(Duration duration) {
    if (duration.inDays >= 1) {
      //Calculate Months
      if (duration.inDays >= 30 && duration.inDays < 365) {
        var months = int.parse(duration.inDays.toString()) * 0.032855;
        return '${months.round()} months ago';
      } else if (duration.inDays >= 365) {
        var year = int.parse(duration.inDays.toString()) * 0.00273973;
        return year.round() > 1 ? '${year.round()} years ago' : '${year.round()} year ago';
      }
      return duration.inDays > 1 ? '${duration.inDays} days ago' : '${duration.inDays} day ago';
    } else if (duration.inHours >= 1) {
      return duration.inHours > 1 ? '${duration.inHours} hours ago' : '${duration.inHours} hour ago';
    } else if (duration.inMinutes >= 1) {
      return duration.inMinutes > 1 ? '${duration.inMinutes} minutes ago' : '${duration.inMinutes} minute ago';
    } else {
      return 'Just now';
    }
  }
}
