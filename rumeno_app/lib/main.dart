import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'l10n/app_localizations.dart';
import 'providers/admin_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ecommerce_provider.dart';
import 'providers/locale_provider.dart';
import 'services/home_widget_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Start 2-second demo refresh for the home screen widget
  HomeWidgetService.startDemoRefresh();
  runApp(const RumenoApp());
}

class RumenoApp extends StatefulWidget {
  const RumenoApp({super.key});

  @override
  State<RumenoApp> createState() => _RumenoAppState();
}

class _RumenoAppState extends State<RumenoApp> with WidgetsBindingObserver {
  late final AdminProvider _adminProvider;
  late final AuthProvider _authProvider;
  late final EcommerceProvider _ecommerceProvider;
  late final LocaleProvider _localeProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _adminProvider = AdminProvider();
    _authProvider = AuthProvider();
    _ecommerceProvider = EcommerceProvider();
    _localeProvider = LocaleProvider();
    _router = createRouter(_authProvider);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      HomeWidgetService.startDemoRefresh();
    } else if (state == AppLifecycleState.paused) {
      HomeWidgetService.stopDemoRefresh();
      HomeWidgetService.updateWidget();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    _adminProvider.dispose();
    _authProvider.dispose();
    _ecommerceProvider.dispose();
    _localeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _adminProvider),
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _ecommerceProvider),
        ChangeNotifierProvider.value(value: _localeProvider),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp.router(
            title: 'Rumeno - Farm Management',
            debugShowCheckedModeBanner: false,
            theme: RumenoTheme.lightTheme,
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
