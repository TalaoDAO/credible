import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';

class AutomaticCredentialSelection extends StatelessWidget {
  const AutomaticCredentialSelection(List<CredentialModel> items, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScanBloc>();
    if(bloc.state is ScanStateCHAPIStoreQueryByExample) {
    final uri = bloc.state.uri;
    /// filter items, ask for approbation
    /// and add ScanEventCHAPIGetQueryByExample event
    context.read<ScanBloc>().add(ScanEventCHAPIGetQueryByExample(
                    'key',
                    [],
                    uri,
                    (done) {
                      print('done');
                    },
                    challenge: data['challenge'],
                    domain: data['domain'],
                  ));
    }
    return Text('sodijosidf');
  }
}
