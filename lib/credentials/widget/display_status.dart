import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/enum/credential_status.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisplayStatus extends StatelessWidget {
  DisplayStatus(this.item, this.displayLabel, {Key? key});

  final CredentialModel item;
  final bool displayLabel;

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletCubit>();
    final currentRevocationStatus = item.revocationStatus;

    final localizations = AppLocalizations.of(context)!;
    return FutureBuilder(
        future: item.status,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (currentRevocationStatus == RevocationStatus.unknown) {
              wallet.handleUnknownRevocationStatus(item);
            }
            switch (snapshot.data) {
              case CredentialStatus.active:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.activeCredential,
                        size: 32,
                      ),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              localizations.active,
                              style: Theme.of(context).textTheme.caption!.apply(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .activeCredential),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                );
              case CredentialStatus.expired:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.alarm_off,
                        color: Theme.of(context).colorScheme.expiredCredential,
                        size: 32,
                      ),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              localizations.expired,
                              style: Theme.of(context).textTheme.caption!.apply(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .expiredCredential,
                                  ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                );
              case CredentialStatus.revoked:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.block,
                        color: Theme.of(context).colorScheme.revokedCredential,
                        size: 32,
                      ),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              localizations.revoked,
                              style: Theme.of(context).textTheme.caption!.apply(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .revokedCredential,
                                  ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                );
              default:
                return Container(
                    height: 20, child: CircularProgressIndicator());
            }
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator()),
                ),
                displayLabel
                    ? SizedBox(
                        width: 63,
                      )
                    : SizedBox.shrink()
              ],
            );
          }
        });
  }
}
