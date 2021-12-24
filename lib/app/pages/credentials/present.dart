import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/credentials/widget/ask_user_permission_did_auth.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/spinner.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialsPresentPage extends StatefulWidget {
  final Uri url;
  final String resource;
  final String? yes;
  final String? no;
  final void Function(Map<String, dynamic>, dynamic) onSubmit;

  const CredentialsPresentPage({
    Key? key,
    required this.url,
    this.yes,
    this.no,
    required this.resource,
    required this.onSubmit,
  }) : super(key: key);

  static Route route(
      {required Uri url,
      String? yes,
      String? no,
      required String resource,
      required void Function(Map<String, dynamic>, dynamic) onSubmit}) {
    return MaterialPageRoute(
      builder: (context) => CredentialsPresentPage(
        url: url,
        yes: yes,
        no: no,
        resource: resource,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState extends State<CredentialsPresentPage> {
  final VoidCallback goBack = () {};

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    var title = localizations.credentialPresentTitle;
    if (widget.resource == 'DID') {
      title = localizations.credentialPresentTitleDIDAuth;
    }

    return BasePage(
      padding: const EdgeInsets.all(16.0),
      title: title,
      titleTrailing: IconButton(
        onPressed: () =>
            Navigator.of(context).pushReplacement(CredentialsList.route()),
        icon: Icon(
          Icons.close,
          color: UiKit.palette.icon,
        ),
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanStateSuccess) {
            goBack();
          }
        },
        builder: (context, state) {
          if (state is ScanStateWorking) {
            return Spinner();
          }

          if (state is ScanStatePreview) {
            return _credentialPreview(state, context, localizations);
          }

          if (state is ScanStateCHAPIAskPermissionDIDAuth) {
            return AskUserPermissionDIDAuth();
          }

          return Container();
        },
      ),
    );
  }

  Column _credentialPreview(ScanStatePreview state, BuildContext context,
      AppLocalizations localizations) {
    final preview = state.preview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.175,
              height: MediaQuery.of(context).size.width * 0.175,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TooltipText(
                text:
                    '${localizations.credentialPresentRequiredCredential} ${widget.resource}.',
                maxLines: 3,
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
          borderColor: UiKit.palette.primary,
          onPressed: () => widget.onSubmit(preview, context),
          child: Text(
            widget.yes ?? localizations.credentialPresentConfirm,
          ),
        ),
        const SizedBox(height: 8.0),
        BaseButton.primary(
          onPressed: goBack,
          child: Text(
            widget.no ?? localizations.credentialPresentCancel,
          ),
        ),
      ],
    );
  }
}
