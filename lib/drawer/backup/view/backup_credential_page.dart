import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/drawer/global_information/bloc/did_bloc.dart';
import 'package:talao/drawer/global_information/view/did_display.dart';
import 'package:talao/drawer/global_information/view/display_application_contacts.dart';
import 'package:talao/drawer/global_information/view/issuer_verification_setting.dart';
import 'package:talao/l10n/l10n.dart';

class BackupCredentialPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => BackupCredentialPage(),
        settings: RouteSettings(name: '/backupCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.backupCredential,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseButton.primary(
            context: context,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () async {
              var directory = await getTemporaryDirectory();
              var file = File('${directory.path}/my_files.txt');
              print(directory.path);
              await file.writeAsString('My name is Khan');
              await OpenFile.open(file.path);
            },
            child: Text("Backup - Change this text"),
          )
        ],
      ),
    );
  }
}
