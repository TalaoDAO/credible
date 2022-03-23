import 'package:flutter/material.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class IssuerWebsitesPage extends StatelessWidget {
  final String? issuerFilter;

  const IssuerWebsitesPage(
    this.issuerFilter, {
    Key? key,
  }) : super(key: key);

  static Route route(String issuerType) => MaterialPageRoute(
        builder: (context) => IssuerWebsitesPage(issuerType),
        settings: RouteSettings(name: '/issuerWebsitesPage'),
      );
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.issuerWebsitesTitle,
      titleLeading: BackLeadingButton(),
      body: ListTile(
        onTap: (() => _launchURL('https://talao.co/gaiax/pass')),
        leading: Icon(Icons.language),
        title: Text('ParticipantCredential'),
        subtitle: Text('https://talao.co/gaiax/pass',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).colorScheme.markDownA,
                  decoration: TextDecoration.underline,
                )),
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
