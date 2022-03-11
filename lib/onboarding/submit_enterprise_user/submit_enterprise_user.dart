import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/onboarding/key/view/onboarding_key_page.dart';
import 'package:talao/onboarding/submit_enterprise_user/bloc/verify_rsa_and_did_cubit.dart';
import 'package:talao/onboarding/submit_enterprise_user/widgets/picked_file.dart';

import 'bloc/submit_enterprise_user_cubit.dart';
import 'widgets/pick_file_button.dart';

class SubmitEnterpriseUserPage extends StatefulWidget {
  const SubmitEnterpriseUserPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SubmitEnterpriseUserCubit()),
            BlocProvider(create: (_) => VerifyRSAAndDIDCubit()),
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
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Submit',
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
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('did:web:'),
            ),
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
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
            verified: () async {
              //TODO translate all message and texts
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      const Text('DID key and RSA key verified successfully')));
              await Navigator.of(context)
                  .pushReplacement(OnBoardingKeyPage.route());
            });
      }, builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return BaseButton.primary(
                context: context,
                margin: EdgeInsets.all(15),
                onPressed: () {
                  final rsaFile = context.read<SubmitEnterpriseUserCubit>().state.rsaFile;
                  if(_didController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Please enter your DID key')));
                    return;
                  }
                  if(rsaFile == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Please import your RSA key')));
                    return;
                  }
                  context.read<VerifyRSAAndDIDCubit>().verify(
                      'did:web:' + _didController.text,
                      context.read<SubmitEnterpriseUserCubit>().state.rsaFile!);
                },
                child: const Text('Confirm'));
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        );
      }),
    );
  }

  Future<void> _pickRSAJsonFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
        dialogTitle: 'Please select RSA key file(with json extension)',
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['json']);
    if (pickedFiles != null) {
      context
          .read<SubmitEnterpriseUserCubit>()
          .setRSAFile(pickedFiles.files.first);
    }
  }
}
