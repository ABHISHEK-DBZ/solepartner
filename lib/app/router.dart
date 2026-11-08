import 'package:go_router/go_router.dart';

import '../features/assistant/assistant_screen.dart';
import '../features/customers/customer_detail_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/customers/udhaar_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/inventory/inventory_analytics_screen.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/inventory/product_detail_screen.dart';
import '../features/ledger/ledger_screen.dart';
import '../features/ledger/transaction_detail_screen.dart';
import '../features/more/more_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/payments/pay_screen.dart';
import '../features/payments/payment_detail_screen.dart';
import '../features/payments/payments_screen.dart';
import '../features/payments/policy_screen.dart';
import '../features/payments/wallet_screen.dart';
import '../features/settings/audit_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/home_shell.dart';
import '../features/suppliers/purchase_form_screen.dart';
import '../features/suppliers/supplier_detail_screen.dart';
import '../features/suppliers/suppliers_screen.dart';

GoRouter buildRouter({required bool hasMerchant}) {
  return GoRouter(
    initialLocation: hasMerchant ? '/' : '/welcome',
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(
          currentPath: state.uri.path,
          child: child,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/ledger',
            builder: (context, state) => const LedgerScreen(),
          ),
          GoRoute(
            path: '/copilot',
            builder: (context, state) => const AssistantScreen(),
          ),
          GoRoute(
            path: '/stock',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/ledger/:id',
        builder: (context, state) => TransactionDetailScreen(
          transactionId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/khata',
        builder: (context, state) => const CustomersScreen(),
      ),
      GoRoute(
        path: '/khata/udhaar',
        builder: (context, state) => const UdhaarScreen(),
      ),
      GoRoute(
        path: '/khata/:id',
        builder: (context, state) => CustomerDetailScreen(
          customerId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/stock/analytics',
        builder: (context, state) => const InventoryAnalyticsScreen(),
      ),
      GoRoute(
        path: '/stock/:id',
        builder: (context, state) => ProductDetailScreen(
          productId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/suppliers',
        builder: (context, state) => const SuppliersScreen(),
      ),
      GoRoute(
        path: '/suppliers/:id',
        builder: (context, state) => SupplierDetailScreen(
          supplierId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/suppliers/:id/purchase',
        builder: (context, state) => PurchaseFormScreen(
          supplierId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/payments/:id',
        builder: (context, state) => PaymentDetailScreen(
          paymentId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/pay/new',
        builder: (context, state) => const PayScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/policy',
        builder: (context, state) => const PolicyScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/audit',
        builder: (context, state) => const AuditScreen(),
      ),
    ],
  );
}
