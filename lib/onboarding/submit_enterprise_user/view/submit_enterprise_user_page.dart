import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/wallet_type/choose_wallet_type.dart';
import 'package:talao/personal/view/personal_page.dart';

import '../cubit/submit_enterprise_user_cubit.dart';
import '../cubit/submit_enterprise_user_state.dart';
import '../cubit/verify_rsa_and_did_cubit.dart';
import '../cubit/verify_rsa_and_did_state.dart';
import 'widgets/pick_file_button.dart';
import 'widgets/picked_file.dart';

class SubmitEnterpriseUserPage extends StatefulWidget {
  const SubmitEnterpriseUserPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SubmitEnterpriseUserCubit()),
            BlocProvider(
              create: (_) => VerifyRSAAndDIDCubit(
                secureStorageProvider: SecureStorageProvider.instance,
                didCubit: context.read<DIDCubit>(),
                didKitProvider: DIDKitProvider.instance,
              ),
            ),
          ],
          child: SubmitEnterpriseUserPage(),
        ),
        settings: RouteSettings(name: '/submitEnterpriseUserPage'),
      );

  @override
  _SubmitEnterpriseUserPageState createState() =>
      _SubmitEnterpriseUserPageState();
}

class _SubmitEnterpriseUserPageState extends State<SubmitEnterpriseUserPage> {
  late final TextEditingController _didController = TextEditingController();

  @override
  void initState() {
    _didController.text = 'did:web:';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.l10n;
    return BasePage(
      title: localization.submit,
      titleLeading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () =>
            Navigator.of(context).pushReplacement(ChooseWalletTypePage.route()),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localization.insertYourDIDKey,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 20,
          ),
          BaseTextField(
            controller: _didController,
            prefixConstraint: BoxConstraints(minHeight: 0, minWidth: 0),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            localization.importYourRSAKeyJsonFile,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<SubmitEnterpriseUserCubit, SubmitEnterpriseUserState>(
              builder: (_, state) {
            if (state.rsaFile == null) {
              return PickFileButton(
                  onTap: () => _pickRSAJsonFile(localization));
            } else {
              return PickedFile(
                fileName: state.rsaFile!.name,
                onDeleteButtonPress: () {
                  context.read<SubmitEnterpriseUserCubit>().setRSAFile(null);
                },
              );
            }
          }),
        ],
      ),
      navigation: BlocConsumer<VerifyRSAAndDIDCubit, VerifyRSAAndDIDState>(
          listener: (_, state) {
        state.maybeWhen(
            orElse: () => null,
            error: (errorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorState.getMessage(context)),
                backgroundColor: Theme.of(context).colorScheme.error,
              ));
            },
            verified: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(localization.didKeyAndRSAKeyVerifiedSuccessfully)));
              final model = ProfileModel.empty().copyWith(isEnterprise: true);
              await context.read<ProfileCubit>().update(model);
              await Navigator.of(context).pushReplacement(PersonalPage.route(
                  profileModel: model, isFromOnBoarding: true));
            });
      }, builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return BaseButton.primary(
                context: context,
                height: 40,
                margin: EdgeInsets.all(15),
                onPressed: () {
                  final rsaFile =
                      context.read<SubmitEnterpriseUserCubit>().state.rsaFile;
                  if (_didController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(localization.pleaseEnterYourDIDKey),
                        backgroundColor: Theme.of(context).colorScheme.error));
                    return;
                  }
                  if (rsaFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(localization.pleaseImportYourRSAKey),
                        backgroundColor: Theme.of(context).colorScheme.error));
                    return;
                  }
                  context.read<VerifyRSAAndDIDCubit>().verify(
                      _didController.text,
                      context.read<SubmitEnterpriseUserCubit>().state.rsaFile!);
                },
                child: Text(localization.confirm));
          },
          loading: () {
            return SizedBox(
              height: 48,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _pickRSAJsonFile(AppLocalizations localization) async {
    var storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localization.storagePermissionDeniedMessage)));
      return;
    }

    if (storagePermission.isPermanentlyDenied) {
      await _showPermissionPopup();
      return;
    }

    if (storagePermission.isGranted || storagePermission.isLimited) {
      final pickedFiles = await FilePicker.platform.pickFiles(
          dialogTitle: localization.pleaseSelectRSAKeyFileWithJsonExtension,
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['json', 'txt']);
      if (pickedFiles != null) {
        context
            .read<SubmitEnterpriseUserCubit>()
            .setRSAFile(pickedFiles.files.first);
      }
    }
  }

  Future<void> _showPermissionPopup() async {
    var localizations = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog(
            title: localizations.storagePermissionRequired,
            subtitle: localizations.storagePermissionPermanentlyDeniedMessage,
            yes: localizations.ok,
            no: localizations.cancel,
          ),
        ) ??
        false;

    if (confirm) {
      await openAppSettings();
    }
  }
}
