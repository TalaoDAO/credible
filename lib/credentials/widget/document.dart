import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';

class DocumentWidget extends StatelessWidget {
  final CredentialModel model;

  const DocumentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.credentialPreview.credentialSubject.displayDetail(
      context,
      model,
    );
  }
}
