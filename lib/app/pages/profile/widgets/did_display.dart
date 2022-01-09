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
        var blockChainAdress = '';
        if (did.length > 7) {
          blockChainAdress = did.substring(7);
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
                  ),
                  Text(Constants.defaultDIDMethodName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.blockChainAdress} : ',
                  ),
                  Expanded(
                    child: Text(
                      blockChainAdress,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${localizations.didDisplayId} : ',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      did,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: did));
              },
              child: Text(
                localizations.didDisplayCopy,
              ),
            ),
          ],
        );
      },
    );
  }
}
