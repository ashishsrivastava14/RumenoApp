import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';

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
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _router = createRouter(_authProvider);
  }

  @override
  void dispose() {
    _router.dispose();
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authProvider,
      child: MaterialApp.router(
        title: 'Rumeno - Farm Management',
        debugShowCheckedModeBanner: false,
        theme: RumenoTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
