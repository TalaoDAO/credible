import 'package:talao/scan/bloc/scan.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/credentials/list/credentials_list.dart';
import 'package:talao/credentials/widget/document.dart';

class CredentialsReceivePage extends StatelessWidget {
  final Uri url;

  const CredentialsReceivePage({
    Key? key,
    required this.url,
  }) : super(key: key);

  static Route route(routeUrl) => MaterialPageRoute(
        builder: (context) => CredentialsReceivePage(
          url: routeUrl,
        ),
        settings: RouteSettings(name: '/credentialsReceive'),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      padding: const EdgeInsets.all(24.0),
      title: localizations.credentialReceiveTitle,
      titleTrailing: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.close),
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (listenerContext, state) {
          if (state is ScanStateSuccess) {
            // Navigator.of(listenerContext)
            //     .pushReplacement(CredentialsList.route());
          }
          if (state is ScanStateIdle) {
            Navigator.of(listenerContext)
                .pushReplacement(CredentialsList.route());
          }
        },
        builder: (builderContext, state) {
          if (state is ScanStatePreview) {
            final credential = CredentialModel.fromJson(state.preview);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          '${url.host} ${localizations.credentialReceiveHost}',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(builderContext).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                DocumentWidget(model: credential),
                const SizedBox(height: 24.0),
                BaseButton.primary(
                  context: context,
                  onPressed: () async {
                    final alias = await showDialog<String>(
                      context: builderContext,
                      builder: (context) => TextFieldDialog(
                        title: localizations.credentialPickAlertMessage,
                      ),
                    );
                    context.read<ScanBloc>().add(ScanEventCredentialOffer(
                          url.toString(),
                          CredentialModel.copyWithAlias(
                              oldCredentialModel: credential, newAlias: alias),
                          'key',
                        ));
                  },
                  child: Text(localizations.credentialReceiveConfirm),
                ),
                const SizedBox(height: 8.0),
                BaseButton.transparent(
                  context: context,
                  onPressed: () => Navigator.of(builderContext).pop(),
                  child: Text(localizations.credentialReceiveCancel),
                ),
              ],
            );
          }

          return LinearProgressIndicator();
        },
      ),
    );
  }
}
