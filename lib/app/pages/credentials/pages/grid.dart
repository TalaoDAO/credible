import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/stream.dart';
import 'package:talao/app/pages/credentials/widget/grid_item.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialsGrid extends StatelessWidget {
  final List<CredentialModel> items;

  const CredentialsGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  Route route() => MaterialPageRoute(
      builder: (context) => CredentialsStream(
            child: (context, items) => CredentialsGrid(
              items: items,
            ),
          ));

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      child: BasePage(
        title: localizations.credentialListTitle,
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        navigation: CustomNavBar(index: 0),
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children:
              items.map((item) => CredentialsGridItem(item: item)).toList(),
        ),
      ),
    );
  }
}
