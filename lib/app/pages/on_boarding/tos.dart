import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/markdown_page.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/spinner.dart';

class OnBoardingTosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final _log = Logger('credible/markdown_page');

    return BasePage(
      title: localizations.onBoardingTosTitle,
      scrollView: false,
      padding: EdgeInsets.zero,
      useSafeArea: false,
      navigation: Container(
        decoration: BoxDecoration(
          color: UiKit.palette.navBarBackground,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: UiKit.palette.shadow,
              offset: Offset(-1.0, -1.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  localizations.onBoardingTosText,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20.0),
                BaseButton.primary(
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/on-boarding/key');
                  },
                  child: Text(localizations.onBoardingTosButton),
                )
              ],
            ),
          ),
        ),
      ),
      body: displayTerms(context, _log),
    );
  }

  FutureBuilder<String> displayTerms(BuildContext context, Logger _log) {
    final localizations = AppLocalizations.of(context)!;
    final String path;
    if (localizations.localeName == 'fr') {
      path = 'assets/privacy_fr.md';
    } else {
      path = 'assets/privacy_en.md';
    }
    return FutureBuilder<String>(
        future: _loadFile(path),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Markdown(
              data: snapshot.data!,
              styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(color: UiKit.text.colorTextSubtitle1),
                  h2: TextStyle(color: UiKit.text.colorTextSubtitle2)),
              // onTapLink: (text, href, title) => _onTapLink(href),
            );
          }

          if (snapshot.error != null) {
            _log.severe(
                'something went wrong when loading $path', snapshot.error);
            return SizedBox.shrink();
          }

          return Spinner();
        });
  }

  Future<String> _loadFile(String path) async {
    return await rootBundle.loadString(path);
  }
}
