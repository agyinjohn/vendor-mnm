import 'package:intl/intl.dart';

String formatDate(String date) {
  try {
    // Parse the date string
    final DateTime parsedDate = DateTime.parse(date);

    // Format it into the desired format
    final String formattedDate =
        DateFormat('EEEE, MMMM d, y').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle invalid date strings
    return 'Invalid date';
  }
}

String formatDateTime(String dateTime) {
  try {
    // Parse the ISO 8601 date-time string
    final DateTime parsedDateTime = DateTime.parse(dateTime);

    // Format it into the desired format
    final String formattedDateTime =
        DateFormat('EEEE, MMMM d, y h:mm a').format(parsedDateTime);

    return formattedDateTime;
  } catch (e) {
    // Handle invalid date-time strings
    return 'Invalid date-time';
  }
}
