import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

// Splash & Auth
import '../screens/splash/splash_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';

// Shop / Ecommerce
import '../screens/shop/shop_home_screen.dart';
import '../screens/shop/product_detail_screen.dart';
import '../screens/shop/cart_screen.dart';
import '../screens/shop/checkout_screen.dart';
import '../screens/shop/order_success_screen.dart';
import '../screens/shop/orders_screen.dart';
import '../screens/shop/order_detail_screen.dart';
import '../screens/shop/search_screen.dart';
import '../screens/shop/category_screen.dart';
import '../screens/shop/shop_account_screen.dart';
import '../screens/shop/vendor_register_screen.dart';

// Farmer
import '../screens/farmer/farmer_shell.dart';
import '../screens/farmer/dashboard_screen.dart';
import '../screens/farmer/animals/animal_list_screen.dart';
import '../screens/farmer/animals/add_animal_screen.dart';
import '../screens/farmer/animals/animal_detail_screen.dart';
import '../screens/farmer/animals/kid_management_screen.dart';
import '../screens/farmer/health/health_dashboard_screen.dart';
import '../screens/farmer/health/vaccination_screen.dart';
import '../screens/farmer/health/treatment_screen.dart';
import '../screens/farmer/health/deworming_screen.dart';
import '../screens/farmer/health/lab_reports_screen.dart';
import '../screens/farmer/breeding/breeding_dashboard_screen.dart';
import '../screens/farmer/finance/finance_dashboard_screen.dart';
import '../screens/farmer/finance/animal_feed_calculator_screen.dart';
import '../screens/farmer/finance/expense_list_screen.dart';
import '../screens/farmer/finance/reports_screen.dart';
import '../screens/farmer/milk/milk_log_screen.dart';
import '../screens/farmer/more_screen.dart';
import '../screens/farmer/more/farm_profile_screen.dart';
import '../screens/farmer/more/team_management_screen.dart';
import '../screens/farmer/more/subscription_screen.dart';
import '../screens/farmer/more/notification_settings_screen.dart';
import '../screens/farmer/more/help_support_screen.dart';
import '../screens/farmer/more/data_export_screen.dart';
import '../screens/farmer/more/farm_sanitization_screen.dart';
import '../screens/farmer/groups/group_list_screen.dart';
import '../screens/farmer/sale/farm_shop_screen.dart';
import '../screens/farmer/sale/sell_animal_screen.dart';
import '../screens/farmer/sale/sell_produce_screen.dart';
import '../screens/farmer/sale/sale_history_screen.dart';

// Vet
import '../screens/vet/vet_shell.dart';
import '../screens/vet/vet_dashboard_screen.dart';
import '../screens/vet/vet_farms_screen.dart';
import '../screens/vet/vet_animal_health_screen.dart';
import '../screens/vet/vet_earnings_screen.dart';
import '../screens/vet/vet_farm_detail_screen.dart';
import '../screens/vet/vet_consultations_screen.dart';
import '../screens/vet/vet_schedule_screen.dart';

// Admin
import '../screens/admin/admin_shell.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_farmers_screen.dart';
import '../screens/admin/admin_animals_screen.dart';
import '../screens/admin/admin_health_config_screen.dart';
import '../screens/admin/admin_more_screen.dart';
import '../screens/admin/admin_farm_screen.dart';
import '../screens/admin/admin_shop_screen.dart';
import '../screens/admin/admin_vets_screen.dart';
import '../screens/admin/more/admin_subscriptions_screen.dart';
import '../screens/admin/more/admin_payments_screen.dart';
import '../screens/admin/more/admin_partners_screen.dart';
import '../screens/admin/more/admin_notifications_screen.dart';
import '../screens/admin/more/admin_reports_screen.dart';
import '../screens/admin/more/admin_settings_screen.dart';
import '../screens/admin/more/admin_vendors_screen.dart';
import '../screens/admin/more/admin_marketplace_screen.dart';

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
      GoRoute(
        path: '/role-selection',
        builder: (_, _) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectTo: redirect);
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return OtpScreen(redirectTo: redirect);
        },
      ),

      // ─── Shop / Ecommerce ───
      GoRoute(path: '/shop', builder: (_, _) => const ShopHomeScreen()),
      GoRoute(path: '/shop/search', builder: (_, _) => const SearchScreen()),
      GoRoute(path: '/shop/cart', builder: (_, _) => const CartScreen()),
      GoRoute(
        path: '/shop/checkout',
        builder: (_, _) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/shop/product/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/shop/category/:category',
        builder: (_, state) {
          final category = state.pathParameters['category'] ?? '';
          return CategoryScreen(categoryKey: category);
        },
      ),
      GoRoute(path: '/shop/orders', builder: (_, _) => const OrdersScreen()),
      GoRoute(
        path: '/shop/order/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderDetailScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/shop/order-success/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderSuccessScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/shop/account',
        builder: (_, _) => const ShopAccountScreen(),
      ),
      GoRoute(
        path: '/shop/vendor-register',
        builder: (_, _) => const VendorRegisterScreen(),
      ),

      // ─── Farmer Shell ───
      ShellRoute(
        navigatorKey: _farmerShellKey,
        builder: (_, _, child) => FarmerShell(child: child),
        routes: [
          GoRoute(
            path: '/farmer/dashboard',
            builder: (_, _) => const FarmerDashboardScreen(),
          ),
          GoRoute(
            path: '/farmer/animals',
            builder: (_, _) => const AnimalListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AddAnimalScreen(),
              ),
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
              GoRoute(
                path: 'vaccination',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const VaccinationScreen(),
              ),
              GoRoute(
                path: 'treatment',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const TreatmentScreen(),
              ),
              GoRoute(
                path: 'deworming',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const DewormingScreen(),
              ),
              GoRoute(
                path: 'lab-reports',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const LabReportsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/farmer/finance',
            builder: (_, _) => const FinanceDashboardScreen(),
            routes: [
              GoRoute(
                path: 'feed-calculator',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AnimalFeedCalculatorScreen(),
              ),
              GoRoute(
                path: 'expenses',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const ExpenseListScreen(),
              ),
              GoRoute(
                path: 'reports',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const ReportsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/farmer/milk',
            builder: (_, _) => const MilkLogScreen(),
            routes: [
              GoRoute(
                path: 'log',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const MilkLogScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/farmer/kids',
            builder: (_, _) => const KidManagementScreen(),
          ),
          GoRoute(
            path: '/farmer/breeding',
            builder: (_, _) => const BreedingDashboardScreen(),
          ),
          GoRoute(
            path: '/farmer/groups',
            builder: (_, _) => const GroupListScreen(),
          ),
          GoRoute(
            path: '/farmer/more',
            builder: (_, _) => const MoreScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const FarmProfileScreen(),
              ),
              GoRoute(
                path: 'team',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const TeamManagementScreen(),
              ),
              GoRoute(
                path: 'subscription',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const SubscriptionScreen(),
              ),
              GoRoute(
                path: 'notifications',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'help',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const HelpSupportScreen(),
              ),
              GoRoute(
                path: 'export',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const DataExportScreen(),
              ),
              GoRoute(
                path: 'sanitization',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const FarmSanitizationScreen(),
              ),
            ],
          ),
        ],
      ),

      // ─── Farmer sale routes (outside shell for full-screen navigation) ───
      GoRoute(
        path: '/farmer/sale',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const FarmShopScreen(),
        routes: [
          GoRoute(
            path: 'sell-animal',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (_, _) => const SellAnimalScreen(),
          ),
          GoRoute(
            path: 'sell-produce',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (_, state) {
              final type = (state.extra as String?) ?? 'Produce';
              return SellProduceScreen(initialType: type);
            },
          ),
          GoRoute(
            path: 'history',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (_, _) => const SaleHistoryScreen(),
          ),
        ],
      ),

      // ─── Vet Shell ───
      ShellRoute(
        navigatorKey: _vetShellKey,
        builder: (_, _, child) => VetShell(child: child),
        routes: [
          GoRoute(
            path: '/vet/dashboard',
            builder: (_, _) => const VetDashboardScreen(),
          ),
          GoRoute(
            path: '/vet/farms',
            builder: (_, _) => const VetFarmsScreen(),
          ),
          GoRoute(
            path: '/vet/health',
            builder: (_, _) => const VetAnimalHealthScreen(),
          ),
          GoRoute(
            path: '/vet/earnings',
            builder: (_, _) => const VetEarningsScreen(),
          ),
        ],
      ),

      // ─── Vet detail routes (outside shell to get full-screen navigation) ───
      GoRoute(
        path: '/vet/farms/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return VetFarmDetailScreen(farmerId: id);
        },
      ),
      GoRoute(
        path: '/vet/consultations',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const VetConsultationsScreen(),
      ),
      GoRoute(
        path: '/vet/schedule',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const VetScheduleScreen(),
      ),

      // ─── Admin Shell ───
      ShellRoute(
        navigatorKey: _adminShellKey,
        builder: (_, _, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/farmers',
            builder: (_, _) => const AdminFarmersScreen(),
          ),
          // Farm module (animals + health merged)
          GoRoute(
            path: '/admin/farm',
            builder: (_, _) => const AdminFarmScreen(),
            routes: [
              GoRoute(
                path: 'health-config',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminHealthConfigScreen(),
              ),
              GoRoute(
                path: 'animals',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminAnimalsScreen(),
              ),
            ],
          ),
          // Shop / Ecommerce module
          GoRoute(
            path: '/admin/shop',
            builder: (_, _) => const AdminShopScreen(),
          ),
          // Vets module
          GoRoute(
            path: '/admin/vets',
            builder: (_, _) => const AdminVetsScreen(),
          ),
          GoRoute(
            path: '/admin/more',
            builder: (_, _) => const AdminMoreScreen(),
            routes: [
              GoRoute(
                path: 'subscriptions',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminSubscriptionsScreen(),
              ),
              GoRoute(
                path: 'payments',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminPaymentsScreen(),
              ),
              GoRoute(
                path: 'partners',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminPartnersScreen(),
              ),
              GoRoute(
                path: 'notifications',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminNotificationsScreen(),
              ),
              GoRoute(
                path: 'reports',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminReportsScreen(),
              ),
              GoRoute(
                path: 'settings',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminSettingsScreen(),
              ),
              GoRoute(
                path: 'vendors',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminVendorsScreen(),
              ),
              GoRoute(
                path: 'marketplace',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AdminMarketplaceScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
