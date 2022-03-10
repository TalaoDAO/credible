import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/shared/extension/verification_state.dart';
import 'package:talao/app/shared/enum/verification_status.dart';
import 'package:talao/credentials/detail/cubit/credential_details_cubit.dart';
import 'package:talao/credentials/widget/display_status.dart';
import 'package:talao/credentials/widget/document.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/app/shared/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

class CredentialsDetailsPage extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  static Route route(CredentialModel routeItem) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<CredentialDetailsCubit>(
        create: (context) => CredentialDetailsCubit(
          walletCubit: context.read<WalletCubit>(),
          didKitProvider: DIDKitProvider.instance,
        ),
        child: CredentialsDetailsPage(item: routeItem),
      ),
      settings: RouteSettings(name: '/CredentialsDetailsPages'),
    );
  }

  @override
  _CredentialsDetailsPageState createState() => _CredentialsDetailsPageState();
}

class _CredentialsDetailsPageState extends State<CredentialsDetailsPage> {
  final logger = Logger('talao-wallet/credentials/detail');

  @override
  void initState() {
    super.initState();
    context.read<CredentialDetailsCubit>().setTitle(widget.item.alias!);
    context.read<CredentialDetailsCubit>().verify(widget.item);
  }

  void delete() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: l10n.credentialDetailDeleteConfirmationDialog,
              yes: l10n.credentialDetailDeleteConfirmationDialogYes,
              no: l10n.credentialDetailDeleteConfirmationDialogNo,
            );
          },
        ) ??
        false;

    if (confirm) {
      await context.read<WalletCubit>().deleteById(widget.item.id);
    }
  }

  void _edit() async {
    final l10n = context.l10n;
    logger.info('Start edit flow');
    var credentialDetailsCubit = context.read<CredentialDetailsCubit>();
    final newAlias = await showDialog<String>(
      context: context,
      builder: (_) => TextFieldDialog(
        title: l10n.credentialDetailEditConfirmationDialog,
        initialValue: credentialDetailsCubit.state.title,
        yes: l10n.credentialDetailEditConfirmationDialogYes,
        no: l10n.credentialDetailEditConfirmationDialogNo,
      ),
    );

    logger.info('Edit flow answered with: $newAlias');

    if (newAlias != null && newAlias != credentialDetailsCubit.state.title) {
      logger.info('New alias is different, going to update credential');
      credentialDetailsCubit.update(widget.item, newAlias);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CredentialDetailsCubit, CredentialDetailsState>(
      builder: (context, state) {
        return BasePage(
          title: state.title != '' ? state.title : l10n.credential,
          titleTag: 'credential/${state.title ?? widget.item.id}/issuer',
          titleLeading: BackLeadingButton(),
          titleTrailing: IconButton(
            onPressed: _edit,
            icon: Icon(Icons.edit),
          ),
          navigation: widget.item.shareLink != ''
              ? SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 5.0,
                    ),
                    height: kBottomNavigationBarHeight,
                    child: Tooltip(
                      message: l10n.credentialDetailShare,
                      child: BaseButton.primary(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push(QrCodeDisplayPage.route(
                              widget.item.id, widget.item));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icon/qr-code.svg',
                              width: 24.0,
                              height: 24.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 16.0),
                            Text(l10n.credentialDetailShare),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocumentWidget(
                model: widget.item,
              ),
              const SizedBox(height: 64.0),
              ...<Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      l10n.credentialDetailStatus,
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        state.verificationState.icon,
                        color: state.verificationState.color,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.verificationState.message,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(color: state.verificationState.color),
                      ),
                    ),
                  ],
                ),
              ],
              Center(
                child: DisplayStatus(widget.item, true),
              ),
              const SizedBox(height: 64.0),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.error.withOpacity(0.1),
                ),
                onPressed: delete,
                child: Text(
                  l10n.credentialDetailDelete,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .apply(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
