// This is a basic Flutter widget test.
//
// The following imports are structured according to modern Flutter best practices.
// `package:finall_prj2/...` is the correct way to import files from your own
// project's `lib` folder into a test file. If your editor shows an error on
// these lines, it indicates a project-level IDE caching issue, not a code error.
import 'package:Medsync/generated/l10n.dart';
import 'package:Medsync/main.dart';
import 'package:Medsync/providers/auth_provider.dart';
import 'package:Medsync/providers/locale_provider.dart';

// Imports for external packages used in the test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts and shows Role Selection screen', (WidgetTester tester) async {
    // SETUP: To test the app, we must build a replica of its widget tree,
    // including all necessary providers and localization services.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: Builder(
          builder: (context) {
            final localeProvider = Provider.of<LocaleProvider>(context);
            // This MaterialApp is configured to exactly match the one in `main.dart`.
            return MaterialApp(
              locale: localeProvider.locale,
              localizationsDelegates: S.localizationsDelegates,
              supportedLocales: S.supportedLocales,
              home: const MainScreenController(),
            );
          },
        ),
      ),
    );

    // Let the widget tree build after the setup.
    await tester.pump();

    // VERIFICATION: Now we can verify that the correct UI is displayed.
    expect(find.text('Select Your Role'), findsOneWidget);
    expect(find.text('Patient'), findsOneWidget);
    expect(find.text('Doctor'), findsOneWidget);
  });
}
