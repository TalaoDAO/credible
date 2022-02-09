import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/pages/on_boarding/key.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/spinner.dart';

class OnBoardingTosPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => OnBoardingTosPage(),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final _log = Logger('credible/markdown_page');

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: localizations.onBoardingTosTitle,
      scrollView: false,
      padding: EdgeInsets.zero,
      useSafeArea: false,
      navigation: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
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
                  context: context,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(OnBoardingKeyPage.route());
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
    final languagesList = ['fr', 'it', 'es', 'de'];
    if (languagesList.contains(localizations.localeName)) {
      path = 'assets/privacy_${localizations.localeName}.md';
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
                h1: TextStyle(color: Theme.of(context).colorScheme.markDownH1),
                h2: TextStyle(color: Theme.of(context).colorScheme.markDownH2),
                a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
                p: TextStyle(color: Theme.of(context).colorScheme.markDownP),
                // onTapLink: (text, href, title) => _onTapLink(href),
              ),
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
