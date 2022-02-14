import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UiDate {
  UiDate._();

  static String displayDate(AppLocalizations localizations, String dateString) {
    if (dateString == '') return '';
    final date = DateFormat('y-M-dThh:mm:ssZ').parse(dateString);

    return DateFormat.yMd(localizations.localeName).format(date);
  }
}
