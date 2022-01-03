import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/professional_student_card/identity_pass.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/material.dart';

class DocumentWidget extends StatelessWidget {
  final CredentialModel model;

  const DocumentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.credentialPreview.credentialSubject is IdentityPass) {
      return model.displayDetail(context, model);
    }
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
          color: model.backgroundColor,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: model.displayDetail(context, model),
    );
  }
}
