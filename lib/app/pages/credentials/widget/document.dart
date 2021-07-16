import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/model/credential.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentWidget extends StatelessWidget {
  final CredentialModel item;

  const DocumentWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BaseBoxDecoration(
          color: UiKit.palette.credentialBackground,
          shapeColor: UiKit.palette.credentialDetail.withOpacity(0.2),
          value: 0.0,
          shapeSize: 256.0,
          anchors: <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: identityPass(context),
      );

  Widget identityPass(BuildContext context) {
    final credential = Credential.fromJson(item.data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: credential.displayDetail(context, item),
    );
  }
}
