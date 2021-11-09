import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/display_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class _BaseItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final bool? selected;
  final Color color;

  const _BaseItem({
    Key? key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.selected,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  __BaseItemState createState() => __BaseItemState();
}

class __BaseItemState extends State<_BaseItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // controller?.dispose();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: !widget.enabled ? 0.33 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
              // margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BaseBoxDecoration(
                color: widget.color,
                shapeColor: UiKit.palette.credentialDetail.withOpacity(0.1),
                value: 1.0,
                anchors: <Alignment>[
                  Alignment.bottomRight,
                ],
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: UiKit.palette.shadow,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IntrinsicHeight(child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class CredentialsListItem extends StatelessWidget {
  final CredentialModel item;
  final VoidCallback? onTap;
  final bool? selected;

  CredentialsListItem({
    Key? key,
    required this.item,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseItem(
      enabled: true,
      onTap: onTap ??
          () => Modular.to.pushNamed(
                '/credentials/detail',
                arguments: item,
              ),
      color: item.backgroundColor,
      child: displayListElement(context),
    );
  }

  Row displayListElement(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(item.data);

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroFix(
                tag: 'credential/${item.id}/icon',
                child: selected == null
                    ? credential.credentialSubject.icon
                    : selected!
                        ? Icon(
                            Icons.check_box,
                            size: 24.0,
                            color: UiKit.palette.icon,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            size: 24.0,
                            color: UiKit.palette.icon,
                          ),
              ),
              SizedBox(height: 16.0),
              DisplayStatus(item, false),
            ],
          ),
        ),
        Expanded(
          child: item.displayList(context, item),
        ),
      ],
    );
  }
}
