import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/email_pass/email_pass.dart';
import 'package:talao/app/shared/model/over18/over18.dart';
import 'package:talao/app/shared/model/voucher/voucher.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:talao/credentials/detail/credentials_detail.dart';
import 'package:talao/credentials/widget/credential_container.dart';
import 'package:talao/credentials/widget/credential_selection_padding.dart';
import 'package:talao/credentials/widget/display_status.dart';

class _BaseItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final bool? selected;
  final Color color;
  final bool isCustom;

  const _BaseItem({
    Key? key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.selected,
    this.color = Colors.white,
    this.isCustom = false,
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
          child: widget.isCustom
              ? InkWell(
                  onTap: widget.onTap,
                  child: IntrinsicHeight(child: widget.child))
              : CredentialContainer(
                  child: Container(
                    // margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BaseBoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.color,
                      shapeColor: Theme.of(context).colorScheme.documentShape,
                      value: 1.0,
                      anchors: <Alignment>[
                        Alignment.bottomRight,
                      ],
                    ),
                    child: Material(
                      color: Theme.of(context).colorScheme.transparent,
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

class CredentialsListPageItem extends StatelessWidget {
  final CredentialModel item;
  final VoidCallback? onTap;
  final bool? selected;

  CredentialsListPageItem({
    Key? key,
    required this.item,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseItem(
      enabled: true,
      isCustom: true,
      onTap: onTap ??
          () => Navigator.of(context).push(
                CredentialsDetailsPage.route(item),
              ),
      color: item.backgroundColor,
      child: selected == null
          ? displayListElement(context)
          : displaySelectionElement(context),
    );
  }

  Widget displayListElement(BuildContext context) {
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
                    ? CredentialIcon(credential: credential)
                    : selected!
                        ? CredentialCheckedBox()
                        : CredentialUncheckedBox(),
              ),
              SizedBox(height: 16.0),
              DisplayStatus(item, false),
            ],
          ),
        ),
        Expanded(
          child: item.credentialPreview.credentialSubject
              .displayInList(context, item),
        ),
      ],
    );
  }

  Widget displaySelectionElement(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(item.data);
    return CredentialSelectionPadding(
      child: Column(
        children: <Widget>[
          CredentialContainer(
            child: item.credentialPreview.credentialSubject
                .displayInList(context, item),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroFix(
                  tag: 'credential/${item.id}/icon',
                  child: selected == null
                      ? CredentialIcon(credential: credential)
                      : selected!
                          ? CredentialCheckedBox()
                          : CredentialUncheckedBox(),
                ),
                SizedBox(width: 8.0),
                DisplayStatus(item, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialUncheckedBox extends StatelessWidget {
  const CredentialUncheckedBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box_outline_blank,
      size: 32.0,
      color: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

class CredentialCheckedBox extends StatelessWidget {
  const CredentialCheckedBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box,
      size: 32.0,
      color: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

class CredentialIcon extends StatelessWidget {
  const CredentialIcon({
    Key? key,
    required this.credential,
  }) : super(key: key);

  final Credential credential;

  @override
  Widget build(BuildContext context) {
    return Icon(
      credential.credentialSubject.icon.icon,
      size: 24.0,
      color: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
