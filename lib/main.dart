import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/clinic_repository.dart';

import 'screens/splash_screen.dart';
import 'screens/role_selection_screen.dart'; // Added import
import 'screens/patient_dashboard/patient_main_screen.dart';
import 'screens/doctor_dashboard/doctor_main_screen.dart';
import 'screens/clinic_admin/clinic_admin_main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiService = ApiService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ProxyProvider<ApiService, AuthRepository>(
          update: (_, api, __) => AuthRepository(api),
        ),
        ProxyProvider<ApiService, ClinicRepository>(
          update: (_, api, __) => ClinicRepository(api),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedSync',
      locale: localeProvider.locale,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainScreenController(),
    );
  }
}

class MainScreenController extends StatelessWidget {
  const MainScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (authProvider.isAuthenticated) {
          switch (authProvider.userRole) {
            case UserRole.doctor:
              return const DoctorMainScreen();
            case UserRole.clinicAdmin:
              return const ClinicAdminMainScreen();
            default:
              return const PatientMainScreen();
          }
        } else {
          // FIXED: Removed const
          return const RoleSelectionScreen();
        }
      },
    );
  }
}
