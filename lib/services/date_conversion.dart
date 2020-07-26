import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateConversion {
  String myDate(int timestamp) {
    initializeDateFormatting();
    DateTime now = DateTime.now();
    DateTime timePost = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat format;
    if(now.difference(timePost).inDays > 0) {
      //format = DateFormat("dd/MM/yyyy");
      format = DateFormat.yMMMMd("fr_FR");
    } else {
      format = DateFormat.Hm("fr_FR");
    }
    return format.format(timePost).toString();
  }
}