import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

// Splash & Auth
import '../screens/splash/splash_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';

// Farmer
import '../screens/farmer/farmer_shell.dart';
import '../screens/farmer/dashboard_screen.dart';
import '../screens/farmer/animals/animal_list_screen.dart';
import '../screens/farmer/animals/add_animal_screen.dart';
import '../screens/farmer/animals/animal_detail_screen.dart';
import '../screens/farmer/health/health_dashboard_screen.dart';
import '../screens/farmer/health/vaccination_screen.dart';
import '../screens/farmer/health/treatment_screen.dart';
import '../screens/farmer/breeding/breeding_dashboard_screen.dart';
import '../screens/farmer/finance/finance_dashboard_screen.dart';
import '../screens/farmer/finance/expense_list_screen.dart';
import '../screens/farmer/finance/reports_screen.dart';
import '../screens/farmer/more_screen.dart';
import '../screens/farmer/more/farm_profile_screen.dart';
import '../screens/farmer/more/team_management_screen.dart';
import '../screens/farmer/more/subscription_screen.dart';

// Vet
import '../screens/vet/vet_shell.dart';
import '../screens/vet/vet_dashboard_screen.dart';
import '../screens/vet/vet_farms_screen.dart';
import '../screens/vet/vet_animal_health_screen.dart';
import '../screens/vet/vet_earnings_screen.dart';

// Admin
import '../screens/admin/admin_shell.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_farmers_screen.dart';
import '../screens/admin/admin_animals_screen.dart';
import '../screens/admin/admin_health_config_screen.dart';
import '../screens/admin/admin_more_screen.dart';
import '../screens/admin/more/admin_subscriptions_screen.dart';
import '../screens/admin/more/admin_payments_screen.dart';
import '../screens/admin/more/admin_partners_screen.dart';
import '../screens/admin/more/admin_notifications_screen.dart';
import '../screens/admin/more/admin_reports_screen.dart';
import '../screens/admin/more/admin_settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _farmerShellKey = GlobalKey<NavigatorState>();
final _vetShellKey = GlobalKey<NavigatorState>();
final _adminShellKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),

      // Auth flow
      GoRoute(path: '/role-selection', builder: (_, _) => const RoleSelectionScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/otp', builder: (_, _) => const OtpScreen()),

      // ─── Farmer Shell ───
      ShellRoute(
        navigatorKey: _farmerShellKey,
        builder: (_, _, child) => FarmerShell(child: child),
        routes: [
          GoRoute(path: '/farmer/dashboard', builder: (_, _) => const FarmerDashboardScreen()),
          GoRoute(
            path: '/farmer/animals',
            builder: (_, _) => const AnimalListScreen(),
            routes: [
              GoRoute(path: 'add', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AddAnimalScreen()),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return AnimalDetailScreen(animalId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/farmer/health',
            builder: (_, _) => const HealthDashboardScreen(),
            routes: [
              GoRoute(path: 'vaccination', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const VaccinationScreen()),
              GoRoute(path: 'treatment', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const TreatmentScreen()),
            ],
          ),
          GoRoute(
            path: '/farmer/finance',
            builder: (_, _) => const FinanceDashboardScreen(),
            routes: [
              GoRoute(path: 'expenses', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const ExpenseListScreen()),
              GoRoute(path: 'reports', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const ReportsScreen()),
            ],
          ),
          GoRoute(path: '/farmer/breeding', builder: (_, _) => const BreedingDashboardScreen()),
          GoRoute(
            path: '/farmer/more',
            builder: (_, _) => const MoreScreen(),
            routes: [
              GoRoute(path: 'profile', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const FarmProfileScreen()),
              GoRoute(path: 'team', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const TeamManagementScreen()),
              GoRoute(path: 'subscription', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const SubscriptionScreen()),
            ],
          ),
        ],
      ),

      // ─── Vet Shell ───
      ShellRoute(
        navigatorKey: _vetShellKey,
        builder: (_, _, child) => VetShell(child: child),
        routes: [
          GoRoute(path: '/vet/dashboard', builder: (_, _) => const VetDashboardScreen()),
          GoRoute(path: '/vet/farms', builder: (_, _) => const VetFarmsScreen()),
          GoRoute(path: '/vet/health', builder: (_, _) => const VetAnimalHealthScreen()),
          GoRoute(path: '/vet/earnings', builder: (_, _) => const VetEarningsScreen()),
        ],
      ),

      // ─── Admin Shell ───
      ShellRoute(
        navigatorKey: _adminShellKey,
        builder: (_, _, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: (_, _) => const AdminDashboardScreen()),
          GoRoute(path: '/admin/farmers', builder: (_, _) => const AdminFarmersScreen()),
          GoRoute(path: '/admin/animals', builder: (_, _) => const AdminAnimalsScreen()),
          GoRoute(path: '/admin/health', builder: (_, _) => const AdminHealthConfigScreen()),
          GoRoute(
            path: '/admin/more',
            builder: (_, _) => const AdminMoreScreen(),
            routes: [
              GoRoute(path: 'subscriptions', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminSubscriptionsScreen()),
              GoRoute(path: 'payments', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminPaymentsScreen()),
              GoRoute(path: 'partners', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminPartnersScreen()),
              GoRoute(path: 'notifications', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminNotificationsScreen()),
              GoRoute(path: 'reports', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminReportsScreen()),
              GoRoute(path: 'settings', parentNavigatorKey: _rootNavigatorKey, builder: (_, _) => const AdminSettingsScreen()),
            ],
          ),
        ],
      ),
    ],
  );
}
