import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/shared/key_generation.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/spinner.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/onboarding/key/onboarding_key.dart';
import 'package:talao/personal/view/personal_page.dart';

class OnBoardingGenPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => OnBoardingGenPage(),
        settings: RouteSettings(name: '/onBoardingGenPage'),
      );

  @override
  _OnBoardingGenPageState createState() => _OnBoardingGenPageState();
}

class _OnBoardingGenPageState extends State<OnBoardingGenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      generateKey(context);
    });
  }

  Future<void> generateKey(BuildContext context) async {
    final log = Logger('talao-wallet/on-boarding/key-generation');
    final localizations = AppLocalizations.of(context)!;
    try {
      final mnemonic = (await SecureStorageProvider.instance.get('mnemonic'))!;
      final key = await KeyGeneration.privateKey(mnemonic);

      await SecureStorageProvider.instance.set('key', key);
      context.read<WalletBloc>().readyWalletBlocList();
      await Navigator.of(context).pushAndRemoveUntil(
          PersonalPage.route(
              isFromOnBoarding: true, profileModel: ProfileModel.empty),
          (Route<dynamic> route) => false);
    } catch (error) {
      log.severe('something went wrong when generating a key', error);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.snackBarError,
        content: Text(localizations.errorGeneratingKey),
      ));
      await Navigator.of(context).pushReplacement(OnBoardingKeyPage.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingGenTitle,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Spinner(),
      ),
    );
  }
}
