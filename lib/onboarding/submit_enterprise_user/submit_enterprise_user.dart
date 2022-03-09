import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/onboarding/key/view/onboarding_key_page.dart';
import 'package:talao/onboarding/submit_enterprise_user/widgets/picked_file.dart';

import 'bloc/submit_enterprise_user_cubit.dart';
import 'widgets/pick_file_button.dart';

class SubmitEnterpriseUserPage extends StatefulWidget {
  const SubmitEnterpriseUserPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider<SubmitEnterpriseUserCubit>(
          create: (_) => SubmitEnterpriseUserCubit(),
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
      navigation: BaseButton.primary(
          context: context,
          margin: EdgeInsets.all(15),
          onPressed: () async {
            await SecureStorageProvider.instance
                .set(SecureStorageKeys.did, _didController.text);
            await Navigator.of(context)
                .pushReplacement(OnBoardingKeyPage.route());
          },
          child: const Text('Confirm')),
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
