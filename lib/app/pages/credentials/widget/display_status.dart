import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/models/credential_status.dart';
import 'package:talao/app/pages/credentials/models/revokation_status.dart';

class DisplayStatus extends StatelessWidget {
  DisplayStatus(this.item, this.displayLabel, {Key? key});
  final CredentialModel item;
  final bool displayLabel;

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletBloc>();
    final currentRevocationStatus = item.revocationStatus;
    return FutureBuilder(
        future: item.status,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (currentRevocationStatus == RevocationStatus.unknown) {
              wallet.updateCredential(item);
            }
            switch (snapshot.data) {
              case CredentialStatus.active:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.check_circle, color: Colors.green),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Active',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(color: Colors.green)))
                        : SizedBox.shrink()
                  ],
                );
              case CredentialStatus.expired:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.alarm_off, color: Colors.orange),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Expired',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(color: Colors.orange)))
                        : SizedBox.shrink()
                  ],
                );
              case CredentialStatus.revoked:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.block, color: Colors.red),
                    ),
                    displayLabel
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Revoked',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(color: Colors.red)))
                        : SizedBox.shrink()
                  ],
                );
              default:
                return CircularProgressIndicator();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
