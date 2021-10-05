import 'package:talao/app/app_module.dart';
import 'package:talao/app/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  // ignore: omit_local_variable_types, unused_local_variable
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  testWidgets('display CertificateOfEmployment', (WidgetTester tester) async {
    final qrCodeFinder = find.bySemanticsLabel('QR Code');
    await tester.pumpWidget(ModularApp(
      module: AppModule(),
      child: AppWidget(),
    ));
    // await binding.takeScreenshot('screenshot-homePage');
    expect(qrCodeFinder, findsOneWidget);
    await tester.tap(qrCodeFinder);
    await tester.pumpAndSettle();
    // await binding.takeScreenshot('screenshot-QRCodePage');
  });
}
