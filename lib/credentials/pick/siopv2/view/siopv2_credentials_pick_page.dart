import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/credentials/pick/siopv2/cubit/siopv2_credentials_pick_cubit.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/scan/scan.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';

class SIOPV2SIOPV2CredentialPickPage extends StatefulWidget {
  final credentials;
  final siopV2Param;

  const SIOPV2SIOPV2CredentialPickPage({
    Key? key,
    required this.credentials,
    required this.siopV2Param,
  }) : super(key: key);

  static Route route({credentials, siopV2Param}) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SIOPV2CredentialPickCubit(),
          child: SIOPV2SIOPV2CredentialPickPage(
              credentials: credentials, siopV2Param: siopV2Param),
        ),
        settings: RouteSettings(name: '/SIOPV2CredentialPickPage'),
      );

  @override
  _SiopV2SIOPV2CredentialPickPageState createState() =>
      _SiopV2SIOPV2CredentialPickPageState();
}

class _SiopV2SIOPV2CredentialPickPageState
    extends State<SIOPV2SIOPV2CredentialPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SIOPV2CredentialPickCubit, SIOPV2CredentialPickState>(
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
                      // final scanCubit = context.read<ScanCubit>();
                      // scanCubit.presentCredentialToSiopV2Request(
                      //     credential: widget.credentials[
                      //     state.selection.first],
                      //     sIOPV2Param: widget.siopV2Param);
                      // Navigator.of(context).pop();
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
              // ...List.generate(
              //   widget.credentials.length,
              //   (index) => CredentialsListPageItem(
              //     item: widget.credentials[index],
              //     selected: state.selection.contains(index),
              //     onTap: () =>
              //         context.read<SIOPV2CredentialPickCubit>().toggle(index),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
