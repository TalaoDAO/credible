import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/pages/credentials/models/credential_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentWidgetModel {
  final String author;
  final String status;

  const DocumentWidgetModel(this.author, this.status);

  factory DocumentWidgetModel.fromCredentialModel(CredentialModel model) {
    late String status;

    switch (model.status) {
      case CredentialStatus.active:
        status = 'Active';
        break;
      case CredentialStatus.expired:
        status = 'Expired';
        break;
      case CredentialStatus.revoked:
        status = 'Revoked';
        break;
    }

    return DocumentWidgetModel(model.issuer, status);
  }
}

class DocumentWidget extends StatelessWidget {
  final CredentialModel model;

  const DocumentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credential = Credential.fromJsonOrErrorPage(model.data);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black87,
              blurRadius: 2,
              spreadRadius: 1.0,
              offset: Offset(3, 3))
        ],
      ),
      child: Container(
        decoration: BaseBoxDecoration(
          color: credential.credentialSubject.backgroundColor,
          shapeColor: UiKit.palette.credentialDetail.withOpacity(0.05),
          value: 0.0,
          shapeSize: 256.0,
          anchors: <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: displayCredentialDetail(context),
      ),
    );
  }

  Widget displayCredentialDetail(BuildContext context) {
    final credential = Credential.fromJsonOrErrorPage(model.data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: credential.displayDetail(context, model),
    );
  }
}
