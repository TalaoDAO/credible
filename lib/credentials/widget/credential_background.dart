import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/credentials/widget/credential_container.dart';

class CredentialBackground extends StatelessWidget {
  const CredentialBackground({
    Key? key,
    required this.model,
    required this.child,
  }) : super(key: key);

  final CredentialModel model;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        decoration: BaseBoxDecoration(
          color: model.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 0.0,
          shapeSize: 256.0,
          anchors: <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
