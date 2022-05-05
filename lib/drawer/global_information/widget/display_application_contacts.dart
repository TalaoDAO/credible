import 'package:flutter/material.dart';
import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/l10n/l10n.dart';

class DisplayTalaoContacts extends StatelessWidget {
  const DisplayTalaoContacts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        InkWell(
          onTap: () => LaunchUrl.launch(Constants.appContactWebsiteUrl),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '${l10n.appContactWebsite} : ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  Constants.appContactWebsiteName,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.markDownA,
                        decoration: TextDecoration.underline,
                      ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => LaunchUrl.launch('mailto:${Constants.appContactMail}'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '${l10n.personalMail} : ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  Constants.appContactMail,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.markDownA,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
