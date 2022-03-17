import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';
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
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context)
            .pushReplacement(ChooseWalletTypePage.route());
        return false;
      },
      child: BasePage(
        title: 'Submit',
        titleLeading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushReplacement(ChooseWalletTypePage.route()),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Insert your DID key',
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
              'Import your RSA key json file',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SubmitEnterpriseUserCubit, SubmitEnterpriseUserState>(
                builder: (_, state) {
              if (state.rsaFile == null) {
                return PickFileButton(onTap: _pickRSAJsonFile);
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
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              },
              verified: () async {
                //TODO translate all message and texts
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'DID key and RSA key verified successfully')));

                await Navigator.of(context).pushReplacement(PersonalPage.route(
                    profileModel: ProfileModel.empty,
                    isFromOnBoarding: true,
                    isEnterprise: true));
              });
        }, builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return BaseButton.primary(
                  context: context,
                  margin: EdgeInsets.all(15),
                  onPressed: () {
                    final rsaFile =
                        context.read<SubmitEnterpriseUserCubit>().state.rsaFile;
                    if (_didController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter your DID key'),
                          backgroundColor:
                              Theme.of(context).colorScheme.error));
                      return;
                    }
                    if (rsaFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please import your RSA key'),
                          backgroundColor:
                              Theme.of(context).colorScheme.error));
                      return;
                    }
                    context.read<VerifyRSAAndDIDCubit>().verify(
                        _didController.text,
                        context
                            .read<SubmitEnterpriseUserCubit>()
                            .state
                            .rsaFile!);
                  },
                  child: const Text('Confirm'));
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
      ),
    );
  }

  Future<void> _pickRSAJsonFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
        dialogTitle: 'Please select RSA key file(with json extension)',
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
