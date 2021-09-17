import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/pages/credentials/models/credential_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _LabeledItem extends StatelessWidget {
  final String icon;
  final String label;
  final String hero;
  final String value;

  const _LabeledItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.hero,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 16.0,
            height: 16.0,
            color: UiKit.text.colorTextBody1,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TooltipText(
              tag: hero,
              text: value,
              tooltip: '$label $value',
              style: GoogleFonts.poppins(
                color: UiKit.text.colorTextBody1,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
    final credential = Credential.fromJsonOrDummy(item.data);

    return _BaseItem(
      enabled: !(item.status != CredentialStatus.active),
      onTap: onTap ??
          () => Modular.to.pushNamed(
                '/credentials/detail',
                arguments: item,
              ),
      color: credential.backgroundColor,
      child: displayListElement(context),
    );
  }

  Row displayListElement(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(item.data);

    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
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
              SizedBox(
                height: 16,
              ),
              displayStatus(item),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: credential.displayList(context, item),
        ),
      ],
    );
  }

  Widget displayStatus(CredentialModel item) {
    switch (item.status) {
      case CredentialStatus.active:
        return Icon(Icons.check_circle, color: Colors.green);
      case CredentialStatus.expired:
        return Icon(Icons.alarm_off, color: Colors.yellow);
      case CredentialStatus.revoked:
        return Icon(Icons.block, color: Colors.red);
      default:
        return Icon(Icons.offline_bolt);
    }
  }
}
