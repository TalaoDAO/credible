import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/document/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DocumentBodyWidgetModel {
  final String author;
  final String email;
  final String npi;
  final String issuedAt;

  final Map<String, dynamic> rawData;

  const DocumentBodyWidgetModel(
      this.author, this.email, this.npi, this.issuedAt, this.rawData);

  factory DocumentBodyWidgetModel.fromCredentialModel(CredentialModel model) =>
      DocumentBodyWidgetModel(
          model.issuer, 'email', 'npi', 'issuedAt', model.data);
}

class DocumentBody extends StatelessWidget {
  final CredentialModel model;
  final Widget? trailing;

  const DocumentBody({
    Key? key,
    required this.model,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documentBodyWidgetModel =
        DocumentBodyWidgetModel.fromCredentialModel(model);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: DocumentItemWidget(
                  label: 'NPI:',
                  value: documentBodyWidgetModel.npi,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DocumentItemWidget(
                  label: 'Issued by:',
                  value: documentBodyWidgetModel.author,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          DocumentItemWidget(
            label: 'Email:',
            value: documentBodyWidgetModel.email,
          ),
          const SizedBox(height: 20.0),
          DocumentItemWidget(
              label: 'Issued at:', value: documentBodyWidgetModel.issuedAt),
          if (trailing != null) const SizedBox(height: 20.0),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
