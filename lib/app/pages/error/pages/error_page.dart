import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({Key? key, required this.errorMessage}) : super(key: key);

  static Route route(String errorMessage) => MaterialPageRoute(
        builder: (context) => ErrorPage(errorMessage: errorMessage),
      );
      
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.genericError,
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      navigation: CustomNavBar(index: 0),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMessage),
            ),
          ],
        ),
      ),
    );
  }
}
