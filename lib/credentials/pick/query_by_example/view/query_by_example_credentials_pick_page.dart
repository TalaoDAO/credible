import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/credentials/pick/query_by_example/cubit/query_by_example_credentials_pick_cubit.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/scan/scan.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/query_by_example/query_by_example.dart';

class QueryByExampleCredentialPickPage extends StatefulWidget {
  final Uri uri;
  final Map<String, dynamic> preview;

  const QueryByExampleCredentialPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  static Route route(Uri routeUri, Map<String, dynamic> preview) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => QueryByExampleCredentialPickCubit(),
          child: QueryByExampleCredentialPickPage(
              uri: routeUri, preview: preview),
        ),
        settings: RouteSettings(name: '/QueryByExampleCredentialPickPage'),
      );

  @override
  _QueryByExampleCredentialPickPageState createState() =>
      _QueryByExampleCredentialPickPageState();
}

class _QueryByExampleCredentialPickPageState
    extends State<QueryByExampleCredentialPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final queryByExampleCubit = context.read<QueryByExampleCubit>().state;
    var reasonList = '';
    if (queryByExampleCubit.type != '') {
      /// get all the reasons
      queryByExampleCubit.credentialQuery.forEach((e) {
        reasonList += getTranslation(e.reason, l10n) + '\n';
      });
    }
    return BlocBuilder<WalletCubit, WalletState>(
        builder: (context, walletState) {
      return BlocBuilder<QueryByExampleCredentialPickCubit,
          QueryByExampleCredentialPickState>(
        builder: (context, state) {
          return BasePage(
            title: l10n.credentialPickTitle,
            titleTrailing: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: kBottomNavigationBarHeight + 16,
                child: Tooltip(
                  message: l10n.credentialPickPresent,
                  child: Builder(builder: (context) {
                    return BaseButton.primary(
                      context: context,
                      onPressed: () {
                        if (state.selection.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.snackBarError,
                            content: Text(l10n.credentialPickSelect),
                          ));
                        } else {
                          final scanCubit = context.read<ScanCubit>();
                          scanCubit.verifiablePresentationRequest(
                            url: widget.uri.toString(),
                            keyId: SecureStorageKeys.key,
                            credentials: state.selection
                                .map((i) => walletState.credentials[i])
                                .toList(),
                            challenge: widget.preview['challenge'],
                            domain: widget.preview['domain'],
                          );
                        }
                      },
                      child: Text(l10n.credentialPickPresent),
                    );
                  }),
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                Text(
                  reasonList == ''
                      ? l10n.credentialPickSelect
                      : l10n.credentialPresentConfirm,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(reasonList,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12.0),
                ...List.generate(
                  walletState.credentials.length,
                  (index) => CredentialsListPageItem(
                    item: walletState.credentials[index],
                    selected: state.selection.contains(index),
                    onTap: () => context
                        .read<QueryByExampleCredentialPickCubit>()
                        .toggle(index),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

String getTranslation(List<Translation> translations, AppLocalizations l10n) {
  var _translation;
  var translated =
      translations.where((element) => element.language == l10n.localeName);
  if (translated.isEmpty) {
    var titi = translations.where((element) => element.language == 'en');
    if (titi.isEmpty) {
      _translation = '';
    } else {
      _translation = titi.single.value;
    }
  } else {
    _translation = translated.single.value;
  }
  return _translation;
}
