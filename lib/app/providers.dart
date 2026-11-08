import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/db/app_database.dart';
import '../data/db/database_provider.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/ledger_repository.dart';
import '../data/repositories/merchant_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/supplier_repository.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/ai_config.dart';
import '../domain/models.dart';
import '../domain/wallet/wallet_models.dart';
import '../domain/wallet/wallet_repository.dart';
import '../services/assistant_service.dart';
import '../services/command_executor.dart';
import '../services/payment_service.dart';
import '../services/solana_service.dart';
import '../services/speech_service.dart';

final Provider<InventoryRepository> inventoryRepositoryProvider =
    Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(databaseProvider));
});

final Provider<LedgerRepository> ledgerRepositoryProvider =
    Provider<LedgerRepository>((ref) {
  return LedgerRepository(
    ref.watch(databaseProvider),
    ref.watch(inventoryRepositoryProvider),
  );
});

final Provider<CustomerRepository> customerRepositoryProvider =
    Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(databaseProvider));
});

final Provider<SupplierRepository> supplierRepositoryProvider =
    Provider<SupplierRepository>((ref) {
  return SupplierRepository(
    ref.watch(databaseProvider),
    ref.watch(inventoryRepositoryProvider),
    ref.watch(ledgerRepositoryProvider),
  );
});

final Provider<PaymentRepository> paymentRepositoryProvider =
    Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.watch(databaseProvider),
    ref.watch(ledgerRepositoryProvider),
  );
});

final Provider<MerchantRepository> merchantRepositoryProvider =
    Provider<MerchantRepository>((ref) {
  return MerchantRepository(ref.watch(databaseProvider));
});

final Provider<FlutterSecureStorage> secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    ref.watch(databaseProvider),
    ref.watch(secureStorageProvider),
  );
});

final Provider<SpeechService> speechServiceProvider =
    Provider<SpeechService>((ref) {
  final SpeechService service = SpeechService();
  ref.onDispose(() {
    service.stop();
    service.stopSpeaking();
  });
  return service;
});

final Provider<SolanaService> solanaServiceProvider =
    Provider<SolanaService>((ref) {
  return SolanaService();
});

final Provider<WalletRepository> walletRepositoryProvider =
    Provider<WalletRepository>((ref) {
  final WalletRepository repo = MobileWalletRepository(
    solanaService: ref.watch(solanaServiceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final StateNotifierProvider<WalletController, WalletSnapshot>
    walletProvider = StateNotifierProvider<WalletController, WalletSnapshot>(
  (ref) => WalletController(
    ref.watch(walletRepositoryProvider),
  ),
);

final Provider<PaymentService> paymentServiceProvider =
    Provider<PaymentService>((ref) {
  return PaymentService(
    ref.watch(paymentRepositoryProvider),
    ref.watch(solanaServiceProvider),
  );
});

final Provider<CommandExecutor> commandExecutorProvider =
    Provider<CommandExecutor>((ref) {
  return CommandExecutor(
    ledger: ref.watch(ledgerRepositoryProvider),
    customers: ref.watch(customerRepositoryProvider),
    inventory: ref.watch(inventoryRepositoryProvider),
  );
});

final Provider<AssistantService> assistantServiceProvider =
    Provider<AssistantService>((ref) {
  return AssistantService(
    ledger: ref.watch(ledgerRepositoryProvider),
    customers: ref.watch(customerRepositoryProvider),
    inventory: ref.watch(inventoryRepositoryProvider),
    payments: ref.watch(paymentRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    walletBalanceLamports: () async {
      final WalletSnapshot snapshot = ref.read(walletProvider);
      if (snapshot.balanceLamports != null) return snapshot.balanceLamports;
      await ref.read(walletProvider.notifier).refresh();
      return ref.read(walletProvider).balanceLamports;
    },
  );
});

// --- Profile and preferences ------------------------------------------------

final StreamProvider<MerchantProfile?> merchantProfileProvider =
    StreamProvider<MerchantProfile?>((ref) {
  return ref.watch(merchantRepositoryProvider).watchMerchant();
});

final FutureProvider<AiConfig?> aiConfigProvider = FutureProvider<AiConfig?>(
  (ref) => ref.watch(settingsRepositoryProvider).loadAiConfig(),
);

final AutoDisposeFutureProvider<bool> voiceRepliesProvider =
    FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).voiceResponsesEnabled(),
);

final AutoDisposeFutureProvider<bool> cloudConsentProvider =
    FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).cloudConsentEnabled(),
);

// --- Shared live streams -----------------------------------------------------

final AutoDisposeStreamProvider<List<CustomerView>> allCustomersProvider =
    StreamProvider.autoDispose<List<CustomerView>>((ref) {
  return ref.watch(customerRepositoryProvider).watchCustomers();
});

final AutoDisposeStreamProvider<List<ProductView>> allProductsProvider =
    StreamProvider.autoDispose<List<ProductView>>((ref) {
  return ref.watch(inventoryRepositoryProvider).watchProducts();
});

final AutoDisposeStreamProvider<List<SupplierView>> allSuppliersProvider =
    StreamProvider.autoDispose<List<SupplierView>>((ref) {
  return ref.watch(supplierRepositoryProvider).watchSuppliers();
});

final AutoDisposeStreamProvider<List<Payee>> allPayeesProvider =
    StreamProvider.autoDispose<List<Payee>>((ref) {
  return ref.watch(paymentRepositoryProvider).watchPayees();
});

final AutoDisposeStreamProvider<List<PaymentProposal>> allPaymentsProvider =
    StreamProvider.autoDispose<List<PaymentProposal>>((ref) {
  return ref.watch(paymentRepositoryProvider).watchPayments();
});

final AutoDisposeStreamProvider<SpendingPolicy> spendingPolicyProvider =
    StreamProvider.autoDispose<SpendingPolicy>((ref) {
  return ref.watch(paymentRepositoryProvider).watchPolicy();
});

// --- Wallet -----------------------------------------------------------------

class WalletController extends StateNotifier<WalletSnapshot> {
  WalletController(this._repo)
      : super(WalletSnapshot(
          connected: _repo.currentState.isConnected,
          address: _repo.currentState.address,
          balanceLamports: _repo.currentState.balanceLamports,
          lastActivity: _repo.currentState.lastActivity,
        )) {
    _subscription = _repo.watchState().listen((WalletState ws) {
      state = WalletSnapshot(
        connected: ws.isConnected,
        address: ws.address,
        balanceLamports: ws.balanceLamports,
        balanceError: ws.balanceError,
        lastActivity: ws.lastActivity,
        isMwaSupported: ws.isMwaSupported,
      );
    });
    if (state.connected) {
      refresh();
    }
  }

  final WalletRepository _repo;
  late final StreamSubscription<WalletState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    await _repo.refreshBalance();
  }

  Future<void> connect() async {
    await _repo.connect();
  }

  Future<void> disconnect() async {
    await _repo.disconnect();
  }
}
