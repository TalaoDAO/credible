import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/credentials/pick/view/credentials_pick_page.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/scan/scan.dart';

class CredentialsPresentPage extends StatefulWidget {
  final Uri uri;

  const CredentialsPresentPage({
    Key? key,
    required this.uri,
  }) : super(key: key);

  static Route route({required Uri uri}) {
    return MaterialPageRoute(
      builder: (context) => CredentialsPresentPage(uri: uri),
      settings: RouteSettings(name: '/credentialsPresent'),
    );
  }

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState extends State<CredentialsPresentPage> {
  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;

    return BasePage(
      padding: const EdgeInsets.all(16.0),
      title: l10n.credentialPresentTitle,
      titleTrailing: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.close),
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          if (state is ScanStatePreview) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.175,
                      height: MediaQuery.of(context).size.width * 0.175,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.profileDummy,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        '${l10n.credentialPresentRequiredCredential} credential(s).',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 16.0),
                // DocumentWidget(
                //     model: DocumentWidgetModel.fromCredentialModel(
                //         CredentialModel(id: '', image: '', data: {'issuer': ''}))),
                const SizedBox(height: 24.0),
                BaseButton.transparent(
                  context: context,
                  onPressed: () => Navigator.of(context).pushReplacement(
                      CredentialsPickPage.route(widget.uri, state.preview!)),
                  child: Text(
                    l10n.credentialPresentConfirm,
                  ),
                ),
                const SizedBox(height: 8.0),
                BaseButton.primary(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    l10n.credentialPresentCancel,
                  ),
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
