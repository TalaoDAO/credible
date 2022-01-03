import 'package:intl/intl.dart';
import 'package:talao/app/shared/ui/talao/constraints.dart';
import 'package:talao/app/shared/ui/talao/palette.dart';
import 'package:talao/app/shared/ui/talao/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'base/constraints.dart';
import 'base/palette.dart';
import 'base/text.dart';
import 'credible/constraints.dart';
import 'credible/palette.dart';
import 'credible/text.dart';
import 'degen/constraints.dart';
import 'degen/palette.dart';
import 'degen/text.dart';

const UiKit = Ui._talao();

class Ui {
  final UiPalette palette;
  final UiConstraints constraints;
  final UiText text;

  // ignore: unused_element
  const Ui._credible({
    this.palette = const CrediblePalette(),
    this.constraints = const CredibleConstraints(),
    this.text = const CredibleText(),
  });

  // ignore: unused_element
  const Ui._degen({
    this.palette = const DegenPalette(),
    this.constraints = const DegenConstraints(),
    this.text = const DegenText(),
  });

  // ignore: unused_element
  const Ui._talao({
    this.palette = const TalaoPalette(),
    this.constraints = const TalaoConstraints(),
    this.text = const TalaoText(),
  });

    String displayDate(AppLocalizations localizations, DateTime _issuanceDate) {
    return DateFormat.yMd(localizations.localeName)
                  .format(_issuanceDate);
  }

}
