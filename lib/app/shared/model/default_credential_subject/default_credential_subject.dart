import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document/body.dart';
import 'package:credible/app/pages/credentials/widget/document/header.dart';
import 'package:credible/app/pages/credentials/widget/labeled_item.dart';
import 'package:credible/app/shared/model/credential_subject.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_credential_subject.g.dart';

@JsonSerializable()
class DefaultCredentialSubject extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;

  factory DefaultCredentialSubject.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectFromJson(json);

  DefaultCredentialSubject(this.id, this.type) : super(id, type);

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TooltipText(
          tag: 'credential/${item.id}/id',
          text: item.id,
          style: GoogleFonts.poppins(
            color: UiKit.text.colorTextBody1,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LabeledItem(
                  icon: 'assets/icon/location-target.svg',
                  label: 'Issued by:',
                  hero: 'credential/${item.id}/issuer',
                  value: item.issuer,
                ),
              ),
              const SizedBox(width: 16.0),
              if (item.expirationDate != null)
                Expanded(
                  child: LabeledItem(
                    icon: 'assets/icon/time-clock.svg',
                    label: 'Valid thru:',
                    hero: 'credential/${item.id}/valid',
                    value: DateFormat(DateFormat.YEAR_NUM_MONTH_DAY)
                        .format(item.expirationDate!),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DocumentHeader(item: item),
          const SizedBox(height: 48.0),
          // const DocumentTicketSeparator(),
          DocumentBody(
            item: item,
          ),
        ],
      ),
    );
  }
}
