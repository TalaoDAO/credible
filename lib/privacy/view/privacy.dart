import 'package:talao/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(
      builder: (context) => PrivacyPage(),
      settings: RouteSettings(name: '/privacyPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languagesList = ['fr', 'it', 'es', 'de'];
    var filePath = 'en';
    if (languagesList.contains(localizations.localeName)) {
      filePath = localizations.localeName;
    }
    return MarkdownPage(
        title: localizations.privacyTitle,
        file: 'assets/privacy/privacy_$filePath.md');
  }
}
