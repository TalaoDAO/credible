import 'package:provider/src/provider.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/pages/detail.dart';
import 'package:talao/app/pages/credentials/pages/grid.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/credentials/pick.dart';
import 'package:talao/app/pages/credentials/present.dart';
import 'package:talao/app/pages/credentials/receive.dart';
import 'package:talao/app/pages/credentials/stream.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialsModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/list',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsList(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/grid',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsGrid(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/detail',
          child: (context, args) => CredentialsDetail(item: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/receive',
          child: (context, args) => CredentialsReceivePage(
            url: args.data['uri'],
            onSubmit: (alias) {
              context.read<ScanBloc>().add(ScanEventCredentialOffer(
                    (args.data['uri']).toString(),
                    alias,
                    'key',
                  ));
            },
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/chapi-receive',
          child: (context, args) => CredentialsReceivePage(
            url: args.data['url'],
            onSubmit: (alias) {
              context.read<ScanBloc>().add(ScanEventCHAPIStore(
                    args.data['data'],
                    args.data['done'],
                  ));
            },
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/present',
          child: (context, args) {
            final localizations = AppLocalizations.of(context)!;

            return CredentialsPresentPage(
              title: localizations.credentialPresentTitle,
              resource: 'credential',
              url: args.data,
              onSubmit: (preview) {
                Modular.to.pushReplacementNamed(
                  '/credentials/pick',
                  arguments: (selection) {
                    context.read<ScanBloc>().add(
                          ScanEventVerifiablePresentationRequest(
                            url: args.data.toString(),
                            key: 'key',
                            credentials: selection,
                            challenge: preview['challenge'],
                            domain: preview['domain'],
                          ),
                        );
                  },
                );
              },
            );
          },
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/chapi-present',
          child: (context, args) {
            final localizations = AppLocalizations.of(context)!;
            final data = args.data['data'];
            final uri = args.data['uri'];
            final queries = data['query'] as List<dynamic>;

            if (queries.first['type'] == 'DIDAuth') {
              context.read<ScanBloc>().add(ScanEventCHAPIAskPermissionDIDAuth(
                    'key',
                    (done) {
                      print('done');
                    },
                    uri,
                    challenge: data['challenge'],
                    domain: data['domain'],
                  ));
              return CredentialsPresentPage(
                title: localizations.credentialPresentTitleDIDAuth,
                resource: 'DID',
                yes: 'Accept',
                url: uri,
                onSubmit: (preview) async {
                  await Modular.to.pushReplacementNamed('/credentials');
                },
              );
            } else if (queries.first['type'] == 'QueryByExample') {
              return CredentialsPresentPage(
                title: localizations.credentialPresentTitle,
                resource: 'credential',
                url: uri,
                onSubmit: (preview) {
                  Modular.to.pushReplacementNamed(
                    '/credentials/pick',
                    arguments: (selection) {
                      context.read<ScanBloc>().add(
                            ScanEventVerifiablePresentationRequest(
                              url: uri,
                              key: 'key',
                              credentials: selection,
                              challenge: preview['challenge'],
                              domain: preview['domain'],
                            ),
                          );
                    },
                  );
                },
              );
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          },
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/pick',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsPickPage(
              items: items,
              onSubmit: args.data,
            ),
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}
