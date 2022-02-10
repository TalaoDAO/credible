import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/credentials/widget/list_item.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/query_by_example/query_by_example.dart';

class CredentialsPickPage extends StatefulWidget {
  final Uri uri;
  final Map<String, dynamic> preview;

  const CredentialsPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  static Route route(Uri routeUri, Map<String, dynamic> preview) =>
      MaterialPageRoute(
        builder: (context) => CredentialsPickPage(
          uri: routeUri,
          preview: preview,
        ),
      );

  @override
  _CredentialsPickPageState createState() => _CredentialsPickPageState();
}

class _CredentialsPickPageState extends State<CredentialsPickPage> {
  final selection = <int>{};

  void toggle(int index) {
    if (selection.contains(index)) {
      selection.remove(index);
    } else {
      selection.add(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final queryByExampleCubit = context.read<QueryByExampleCubit>().state;
    var reasonList = '';
    if (queryByExampleCubit.type != '') {
      /// get all the reasons
      queryByExampleCubit.credentialQuery.forEach((e) {
        reasonList += getTranslation(e.reason, localizations) + '\n';
      });
    }
    return BlocBuilder<WalletBloc, WalletBlocState>(
        builder: (builderContext, walletState) {
      return BasePage(
        title: localizations.credentialPickTitle,
        titleTrailing: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(CredentialsList.route());
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
              message: localizations.credentialPickPresent,
              child: Builder(builder: (builderContext) {
                return BaseButton.primary(
                  context: context,
                  onPressed: () {
                    if (selection.isEmpty) {
                      ScaffoldMessenger.of(builderContext)
                          .showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(localizations.credentialPickSelect),
                      ));
                    } else {
                      final scanBloc = builderContext.read<ScanBloc>();
                      scanBloc.add(
                        ScanEventVerifiablePresentationRequest(
                          url: widget.uri.toString(),
                          key: 'key',
                          credentials: selection
                              .map((i) => walletState.credentials[i])
                              .toList(),
                          challenge: widget.preview['challenge'],
                          domain: widget.preview['domain'],
                        ),
                      );
                      Navigator.of(builderContext)
                          .pushReplacement(CredentialsList.route());
                    }
                  },
                  child: Text(localizations.credentialPickPresent),
                );
              }),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Text(
              reasonList == ''
                  ? localizations.credentialPickSelect
                  : localizations.credentialPresentConfirm,
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
              (index) => CredentialsListItem(
                item: walletState.credentials[index],
                selected: selection.contains(index),
                onTap: () => toggle(index),
              ),
            ),
          ],
        ),
      );
    });
  }
}

String getTranslation(
    List<Translation> translations, AppLocalizations localizations) {
  var _translation;
  var translated = translations
      .where((element) => element.language == localizations.localeName);
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
