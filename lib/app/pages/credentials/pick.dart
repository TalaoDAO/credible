import 'package:provider/src/provider.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/list_item.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/query_by_example/query_by_example.dart';

class CredentialsPickPage extends StatefulWidget {
  final List<CredentialModel> items;
  final void Function(List<CredentialModel>) onSubmit;

  const CredentialsPickPage({
    Key? key,
    required this.items,
    required this.onSubmit,
  }) : super(key: key);

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
    return BasePage(
      title: 'Present credentials',
      titleTrailing: IconButton(
        onPressed: () {
          Modular.to.pushReplacementNamed('/credentials/list');
        },
        icon: Icon(
          Icons.close,
          color: UiKit.palette.icon,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      navigation: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: kBottomNavigationBarHeight * 1.75,
          child: Tooltip(
            message: localizations.credentialPickPresent,
            child: BaseButton.primary(
              onPressed: () {
                if (selection.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('localizations.credentialPickSelect'),
                  ));
                } else {
                  widget
                      .onSubmit(selection.map((i) => widget.items[i]).toList());
                  Modular.to.pushReplacementNamed('/credentials/list');
                }
              },
              child: Text(localizations.credentialPickPresent),
            ),
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
            widget.items.length,
            (index) => CredentialsListItem(
              item: widget.items[index],
              selected: selection.contains(index),
              onTap: () => toggle(index),
            ),
          ),
        ],
      ),
    );
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
