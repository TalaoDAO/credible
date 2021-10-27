import 'package:flutter/material.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class displayTalaoContacts extends StatelessWidget {
  const displayTalaoContacts({
    Key? key,
  }) : super(key: key);

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        InkWell(
          onTap: () => _launchURL(Constants.appContactWebsiteUrl),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${localizations.appContactWebsite} : '),
                Text(
                  Constants.appContactWebsiteName,
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => _launchURL('mailto:${Constants.appContactMail}'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${localizations.personalMail} : '),
                Text(
                  'contact@talao.io',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
