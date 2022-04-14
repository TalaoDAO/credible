import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/issuer_websites_page/feature/kyc_feature.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class IssuerWebsitesPage extends StatelessWidget {
  final String? issuerFilter;

  const IssuerWebsitesPage(
    this.issuerFilter, {
    Key? key,
  }) : super(key: key);

  static Route route(String? issuerType) => MaterialPageRoute(
        builder: (context) => IssuerWebsitesPage(issuerType),
        settings: RouteSettings(name: '/issuerWebsitesPage'),
      );
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.issuerWebsitesTitle,
      titleLeading: BackLeadingButton(),
      body: Column(
        children: [
          BaseButton.primary(
            context: context,
            onPressed: () {
              _launchURL('https://talao.co/gaiax/pass');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.language),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(l10n.participantCredential),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          KYCButton(),
        ],
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}

class KYCButton extends StatelessWidget {
  KYCButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// Sending email and DID to passbase
    final email = context.read<ProfileCubit>().state.model.email;
    setKYCEmail(email);
    final did = context.read<DIDCubit>().state.did;
    setKYCMetadat(did);

    return Stack(
      children: [
        BaseButton.primary(
          context: context,
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(''),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: PassbaseButton(
            height: 49,
            onFinish: (identityAccessKey) {
              // do stuff in case of success
            },
            onSubmitted: (identityAccessKey) {
              // do stuff in case of success
            },
            onError: (errorCode) {
              // do stuff in case of cancel
            },
            onStart: () {
              // do stuff in case of start
            },
          ),
        ),
      ],
    );
  }
}
