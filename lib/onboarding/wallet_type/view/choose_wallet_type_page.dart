import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/key/onboarding_key.dart';
import 'package:talao/onboarding/onboarding.dart';

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
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        title: l10n.walletType,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrollView: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.createPersonalWalletTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      l10n.createPersonalWalletText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 20.0),
                    BaseButton.primary(
                      context: context,
                      onPressed: () {
                        context
                            .read<ChooseWalletTypeCubit>()
                            .onChangeWalletType(WalletTypes.personal);
                        Navigator.of(context).push(OnBoardingKeyPage.route());
                      },
                      child: Text(l10n.createPersonalWalletButtonTitle),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.createEnterpriseWalletTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      l10n.createEnterpriseWalletText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 20.0),
                    BaseButton.primary(
                      context: context,
                      onPressed: () {
                        context
                            .read<ChooseWalletTypeCubit>()
                            .onChangeWalletType(WalletTypes.enterprise);
                        Navigator.of(context)
                            .push(SubmitEnterpriseUserPage.route());
                      },
                      child: Text(l10n.createEnterpriseWalletButtonTitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
