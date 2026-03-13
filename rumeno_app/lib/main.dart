import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';
import 'providers/ecommerce_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RumenoApp());
}

class RumenoApp extends StatefulWidget {
  const RumenoApp({super.key});

  @override
  State<RumenoApp> createState() => _RumenoAppState();
}

class _RumenoAppState extends State<RumenoApp> {
  late final AuthProvider _authProvider;
  late final EcommerceProvider _ecommerceProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _ecommerceProvider = EcommerceProvider();
    _router = createRouter(_authProvider);
  }

  @override
  void dispose() {
    _router.dispose();
    _authProvider.dispose();
    _ecommerceProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _ecommerceProvider),
      ],
      child: MaterialApp.router(
        title: 'Rumeno - Farm Management',
        debugShowCheckedModeBanner: false,
        theme: RumenoTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
