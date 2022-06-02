import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
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

class CredentialManifestOfferPickPage extends StatefulWidget {
  final Uri uri;
  final CredentialModel credential;

  const CredentialManifestOfferPickPage({
    Key? key,
    required this.uri,
    required this.credential,
  }) : super(key: key);

  static Route route(Uri routeUri, CredentialModel credential) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) {
          final presentationDefinition =
              credential.credentialManifest?.presentationDefinition;
          if (presentationDefinition != null) {
            return CredentialManifestPickCubit(
                presentationDefinition: presentationDefinition.toJson(),
                credentialList: context.read<WalletCubit>().state.credentials);
          }
          return CredentialManifestPickCubit(
              presentationDefinition: {},
              credentialList: context.read<WalletCubit>().state.credentials);
        },
        child: CredentialManifestOfferPickPage(
            uri: routeUri, credential: credential),
      ),
      settings: RouteSettings(name: '/CredentialManifestPickPage'),
    );
  }

  @override
  _CredentialManifestOfferPickPageState createState() =>
      _CredentialManifestOfferPickPageState();
}

class _CredentialManifestOfferPickPageState
    extends State<CredentialManifestOfferPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
        builder: (context, walletState) {
      return BlocBuilder<CredentialManifestPickCubit,
          CredentialManifestPickState>(
        builder: (context, state) {
          final credentialCandidateList = List.generate(
            state.filteredCredentialList.length,
            (index) => CredentialsListPageItem(
              item: state.filteredCredentialList[index],
              selected: state.selection.contains(index),
              onTap: () =>
                  context.read<CredentialManifestPickCubit>().toggle(index),
            ),
          );
          final _purpose = widget.credential.credentialManifest
              ?.presentationDefinition?.inputDescriptors.first.purpose;
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
            navigation: credentialCandidateList.isNotEmpty
                ? SafeArea(
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .snackBarError,
                                  content: Text(l10n.credentialPickSelect),
                                ));
                              } else {
                                final selectedCredentialsList = state.selection
                                    .map((i) => state.filteredCredentialList[i])
                                    .toList();
                                context.read<ScanCubit>().credentialOffer(
                                      url: widget.uri.toString(),
                                      credentialModel: widget.credential,
                                      keyId: 'key',
                                      signatureOwnershipProof:
                                          selectedCredentialsList.first,
                                    );
                              }
                            },
                            child: Text(l10n.credentialPickPresent),
                          );
                        }),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            body: Column(
              children: <Widget>[
                _purpose != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _purpose,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    : SizedBox.shrink(),
                credentialCandidateList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          l10n.credentialSelectionListEmptyError,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text(
                        l10n.credentialPickSelect,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                const SizedBox(height: 12.0),
                ...credentialCandidateList,
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
