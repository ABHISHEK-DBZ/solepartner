import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models.dart';
import '../../domain/rules/ledger_rules.dart';

final AutoDisposeStreamProvider<List<LedgerEntry>> dashboardEntriesProvider =
    StreamProvider.autoDispose<List<LedgerEntry>>((ref) {
  return ref.watch(ledgerRepositoryProvider).watchEntries(limit: 1200);
});

final AutoDisposeProvider<AsyncValue<DashboardSummary>> dashboardSummaryProvider =
    Provider.autoDispose<AsyncValue<DashboardSummary>>((ref) {
  final AsyncValue<List<LedgerEntry>> entries =
      ref.watch(dashboardEntriesProvider);
  final AsyncValue<List<CustomerView>> customers =
      ref.watch(allCustomersProvider);
  final AsyncValue<List<ProductView>> products = ref.watch(allProductsProvider);

  if (entries.isLoading || customers.isLoading || products.isLoading) {
    return const AsyncValue<DashboardSummary>.loading();
  }
  if (entries.hasError) {
    return AsyncValue<DashboardSummary>.error(
      entries.error!,
      entries.stackTrace!,
    );
  }
  if (customers.hasError) {
    return AsyncValue<DashboardSummary>.error(
      customers.error!,
      customers.stackTrace!,
    );
  }
  if (products.hasError) {
    return AsyncValue<DashboardSummary>.error(
      products.error!,
      products.stackTrace!,
    );
  }

  return AsyncValue<DashboardSummary>.data(
    LedgerRules.summarise(
      entries: entries.requireValue,
      products: products.requireValue,
      customers: customers.requireValue,
      now: DateTime.now(),
    ),
  );
});
