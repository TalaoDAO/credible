import 'package:intl/intl.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/voucher/offer/offer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';

part 'voucher.g.dart';

@JsonSerializable(explicitToJson: true)
class Voucher extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String identifier;
  final Offer offer;
  @override
  final Author issuedBy;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Voucher(
    this.id,
    this.type,
    this.issuedBy,
    this.identifier,
    this.offer,
  ) : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display Loyalty card');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: 508.67 / 319.67,
            child: Container(
              height: 319.67,
              width: 508.67,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                            'assets/image/voucher.png',
                          ))),
                  child: AspectRatio(

                      /// random size, copy from professional student card
                      aspectRatio: 508.67 / 319.67,
                      child: Container(
                        height: 319.67,
                        width: 508.67,
                        child: CustomMultiChildLayout(
                          delegate: VoucherDelegate(position: Offset.zero),
                          children: [
                            LayoutId(
                                id: 'voucherValue',
                                child: Transform.rotate(
                                  angle: 0.53,
                                  child: Row(
                                    children: [
                                      TextWithVoucherStyle(
                                          value: NumberFormat.currency(
                                                  name: offer.currency,
                                                  locale:
                                                      localizations.localeName)
                                              .format(
                                                  double.parse(offer.value))),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ))),
            )),
      ],
    );
  }
}

class VoucherDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  VoucherDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('voucherValue')) {
      layoutChild('voucherValue', BoxConstraints.loose(size));
      positionChild(
          'voucherValue', Offset(size.width * 0.27, size.height * 0.95));
    }
  }

  @override
  bool shouldRelayout(covariant VoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class TextWithVoucherStyle extends StatelessWidget {
  const TextWithVoucherStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ImageCardText(
          text: value,
          textStyle: TextStyle(
              inherit: true,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
