import 'package:talao/app/pages/profile/blocs/did.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/constants.dart';

class DIDDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer(
      bloc: context.read<DIDBloc>(),
      listener: (context, state) {
        if (state is DIDStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      builder: (context, state) {
        final did = state is DIDStateDefault ? state.did : '';
        var blockChainAddress = '';
        if (did.length > 7) {
          blockChainAddress = did.substring(7);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.blockChainDisplayMethod} : ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    Constants.defaultDIDMethodName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.blockChainAdress} : ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Expanded(
                    child: Text(
                      blockChainAddress != ''
                          ? '${blockChainAddress.substring(0, 10)} ... ${blockChainAddress.substring(blockChainAddress.length - 10)}'
                          : '',
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: blockChainAddress));
              },
              child: Text(localizations.adressDisplayCopy),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.didDisplayId} : ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Expanded(
                    child: Text(
                      did != ''
                          ? '${did.substring(0, 10)} ... ${did.substring(did.length - 10)}'
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: did));
              },
              child: Text(localizations.didDisplayCopy),
            ),
          ],
        );
      },
    );
  }
}
