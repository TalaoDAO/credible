import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/pages/detail.dart';
import 'package:talao/app/pages/credentials/widget/display_status.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';

class CredentialsGridItem extends StatelessWidget {
  final CredentialModel item;

  CredentialsGridItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Navigator.of(context).push(CredentialsDetail.route(item)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: 'credential/${item.id}/icon',
                      child: Icon(
                        Icons.person,
                        size: 48.0,
                      ),
                    ),
                    TooltipText(
                      tag: 'credential/${item.id}/issuer',
                      text: item.issuer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Hero(
                    tag: 'credential/${item.id}/status',
                    child: DisplayStatus(item, false),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
