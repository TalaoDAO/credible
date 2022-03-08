import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';

class SubmitEnterpriseUserPage extends StatefulWidget {
  const SubmitEnterpriseUserPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => SubmitEnterpriseUserPage(),
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
        ],
      ),
      navigation:
          BaseButton.primary(context: context, child: const Text('Confirm')),
    );
  }
}
