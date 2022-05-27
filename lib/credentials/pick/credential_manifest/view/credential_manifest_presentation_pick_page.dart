import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/credentials/pick/credential_manifest/credential_manifest_pick.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/scan/scan.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';

class CredentialManifestPickPage extends StatefulWidget {
  final Uri uri;
  final Map<String, dynamic> preview;

  const CredentialManifestPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  static Route route(Uri routeUri, Map<String, dynamic> preview) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => CredentialManifestPickCubit(
            presentationDefinition: preview['credential_manifest']
                ['presentation_definition'],
            credentialList: context.read<WalletCubit>().state.credentials),
        child: CredentialManifestPickPage(uri: routeUri, preview: preview),
      ),
      settings: RouteSettings(name: '/CredentialManifestPickPage'),
    );
  }

  @override
  _CredentialManifestPickPageState createState() =>
      _CredentialManifestPickPageState();
}

class _CredentialManifestPickPageState
    extends State<CredentialManifestPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CredentialManifestPickCubit,
        CredentialManifestPickState>(
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
                              .map((i) => state.filteredCredentialList[i])
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
                l10n.credentialPickSelect,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 12.0),
              ...List.generate(
                state.filteredCredentialList.length,
                (index) => CredentialsListPageItem(
                  item: state.filteredCredentialList[index],
                  selected: state.selection.contains(index),
                  onTap: () =>
                      context.read<CredentialManifestPickCubit>().toggle(index),
                ),
              ),
            ],
          ),
        );
      },
    );
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
