import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayStatus extends StatelessWidget {
  const DisplayStatus({
    Key? key,
    required this.item,
    required this.displayLabel,
  }) : super(key: key);

  final CredentialModel item;
  final bool displayLabel;

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletCubit>();
    final currentRevocationStatus = item.revocationStatus;

    final l10n = context.l10n;
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
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.activeCredential,
                      size: 32,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        l10n.active,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .activeCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            case CredentialStatus.expired:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.alarm_off,
                      color: Theme.of(context).colorScheme.expiredCredential,
                      size: 32,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        l10n.expired,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .expiredCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            case CredentialStatus.revoked:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.block,
                      color: Theme.of(context).colorScheme.revokedCredential,
                      size: 32,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        l10n.revoked,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .revokedCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            default:
              return const SizedBox(
                height: 20,
                child: CircularProgressIndicator(),
              );
          }
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(height: 32, child: CircularProgressIndicator()),
              ),
              SizedBox(width: 63)
            ],
          );
        }
      },
    );
  }
}
