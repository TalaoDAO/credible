import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/onboarding/key/onboarding_key.dart';

import '../../submit_enterprise_user/view/submit_enterprise_user_page.dart';
import '../cubit/choose_wallet_type_cubit.dart';
import '../cubit/choose_wallet_type_state.dart';
import '../cubit/wallet_type_enum.dart';

class ChooseWalletTypePage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider<ChooseWalletTypeCubit>(
          create: (_) => ChooseWalletTypeCubit(SecureStorageProvider.instance),
          child: ChooseWalletTypePage(),
        ),
        settings: RouteSettings(name: '/onBoardingChooseWalletTypePage'),
      );

  const ChooseWalletTypePage({Key? key}) : super(key: key);

  @override
  _ChooseWalletTypePageState createState() => _ChooseWalletTypePageState();
}

class _ChooseWalletTypePageState extends State<ChooseWalletTypePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Wallet Type',
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrollView: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your wallet type',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 20.0),
            BlocBuilder<ChooseWalletTypeCubit, ChooseWalletTypeState>(
                builder: (context, state) {
              return DropdownButton<WalletTypes>(
                value: state.selectedWallet,
                items: WalletTypes.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.stringValue(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged:
                    context.read<ChooseWalletTypeCubit>().onChangeWalletType,
              );
            })
          ],
        ),
      ),
      navigation: BaseButton.primary(
        margin: EdgeInsets.all(12),
        context: context,
        child: const Text('Continue'),
        onPressed: () {
          if (context
              .read<ChooseWalletTypeCubit>()
              .isPersonalWalletSelected()) {
            Navigator.of(context).pushReplacement(OnBoardingKeyPage.route());
          } else {
            Navigator.of(context)
                .pushReplacement(SubmitEnterpriseUserPage.route());
          }
        },
      ),
    );
  }
}
