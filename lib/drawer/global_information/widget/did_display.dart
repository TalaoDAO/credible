import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/did/cubit/did_state.dart';
import 'package:talao/did/did.dart';
import 'package:talao/l10n/l10n.dart';

class DIDDisplay extends StatelessWidget {
  final bool isEnterpriseUser;

  const DIDDisplay({Key? key, required this.isEnterpriseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<DIDCubit, DIDState>(
      listener: (context, state) {
        if (state is DIDStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message!.color,
            content: Text(state.message?.getMessage(context) ?? ''),
          ));
        }
      },
      builder: (context, state) {
        final did = state is DIDStateDefault ? state.did! : '';
        var blockChainAddress = '';
        if (did.length > 7) {
          blockChainAddress = did.substring(7);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!isEnterpriseUser)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '${l10n.blockChainDisplayMethod} : ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      //TODO : Can we change did method name according to the user type?
                      Constants.defaultDIDMethodName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            if (!isEnterpriseUser)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '${l10n.blockChainAdress} : ',
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
            if (!isEnterpriseUser)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: blockChainAddress));
                  },
                  child: Text(l10n.adressDisplayCopy),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${l10n.didDisplayId} : ',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: did));
                },
                child: Text(l10n.didDisplayCopy),
              ),
            ),
          ],
        );
      },
    );
  }
}
