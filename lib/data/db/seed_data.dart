import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final MerchantProfile? existing = await (db.select(db.merchantProfiles)..limit(1)).getSingleOrNull();
    if (existing != null) return;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    // 1. Merchant Profile
    await db.into(db.merchantProfiles).insert(
      MerchantProfilesCompanion.insert(
        shopName: 'Rahul Kirana Store',
        ownerName: 'Rahul',
        businessType: 'Kirana store',
        languageCode: 'en',
        currencyCode: 'INR',
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 2. Customers
    final int rameshId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Ramesh Store',
        phone: '+91 98765 43210',
        address: 'MG Road, Main Market',
        notes: 'Regular customer',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
      ),
    );

    final int sureshId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Suresh Traders',
        phone: '+91 98123 45678',
        address: 'Station Road',
        notes: 'Wholesale buyer',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
    );

    final int anilId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Anil Kirana',
        phone: '+91 98989 89898',
        address: 'Bazaar Chowk',
        notes: 'Monthly billing',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    );

    final int mehtaId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Mehta General Store',
        phone: '+91 98711 22334',
        address: 'Subhash Nagar',
        notes: 'Prompt payer',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    );

    // 3. Suppliers
    final int singhSupplierId = await db.into(db.suppliers).insert(
      SuppliersCompanion.insert(
        name: 'Singh Distributors',
        phone: '+91 98223 34455',
        address: 'Industrial Area, Phase 2',
        notes: 'FMCG and Packaged foods supplier',
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
    );

    await db.into(db.suppliers).insert(
      SuppliersCompanion.insert(
        name: 'Mumbai Grocery Hub',
        phone: '+91 98334 45566',
        address: 'APMC Market, Vashi',
        notes: 'Grains & Pulses',
        createdAt: now.subtract(const Duration(days: 80)),
        updatedAt: now,
      ),
    );

    // 4. Payees (Solana Devnet)
    await db.into(db.payees).insert(
      PayeesCompanion.insert(
        name: 'Singh Distributors',
        walletAddress: '8rZ7q4Kx5pLmNoPqRsTuVwXyZ1234567890abcdefgh',
        createdAt: now,
      ),
    );

    await db.into(db.payees).insert(
      PayeesCompanion.insert(
        name: 'Ramesh Store',
        walletAddress: '3aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcdef',
        createdAt: now,
      ),
    );

    // 5. Products matching Mockup 5
    await db.into(db.products).insert(
      ProductsCompanion.insert(
        name: 'Maggi Noodles 70g',
        sku: 'MG-001',
        barcode: '8901058852319',
        category: 'Grocery',
        unit: 'pack',
        purchasePricePaise: const Value(1100),
        sellingPricePaise: const Value(1400),
        stockQty: const Value(42),
        minStockQty: const Value(20),
        supplierId: Value(singhSupplierId),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.into(db.products).insert(
      ProductsCompanion.insert(
        name: 'Parle-G Biscuits',
        sku: 'PG-002',
        barcode: '8901719101015',
        category: 'Snacks',
        unit: 'pack',
        purchasePricePaise: const Value(800),
        sellingPricePaise: const Value(1000),
        stockQty: const Value(120),
        minStockQty: const Value(30),
        supplierId: Value(singhSupplierId),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.into(db.products).insert(
      ProductsCompanion.insert(
        name: 'Coca-Cola 750ml',
        sku: 'CC-750',
        barcode: '8901764012236',
        category: 'Beverages',
        unit: 'bottle',
        purchasePricePaise: const Value(3200),
        sellingPricePaise: const Value(4000),
        stockQty: const Value(36),
        minStockQty: const Value(15),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.into(db.products).insert(
      ProductsCompanion.insert(
        name: 'Aashirvaad Atta 5kg',
        sku: 'AA-005',
        barcode: '8901030383725',
        category: 'Grocery',
        unit: 'bag',
        purchasePricePaise: const Value(21000),
        sellingPricePaise: const Value(24000),
        stockQty: const Value(18),
        minStockQty: const Value(10),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.into(db.products).insert(
      ProductsCompanion.insert(
        name: 'Tata Salt 1kg',
        sku: 'TS-001',
        barcode: '8901030010003',
        category: 'Grocery',
        unit: 'pack',
        purchasePricePaise: const Value(2200),
        sellingPricePaise: const Value(2800),
        stockQty: const Value(50),
        minStockQty: const Value(15),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 6. Customer credit / udhaar balances
    // Ramesh Store: +₹12,500 outstanding (due in 7 days)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditGiven,
        amountPaise: 1450000, // ₹14,500
        cashDeltaPaise: 0,
        creditDeltaPaise: 1450000,
        customerId: Value(rameshId),
        method: PaymentMethod.credit,
        note: 'Weekly provisions credit',
        source: EntrySource.manual,
        occurredAt: now.subtract(const Duration(days: 14)),
        createdAt: now.subtract(const Duration(days: 14)),
      ),
    );

    // Suresh Traders: +₹8,000 outstanding (overdue 3 days)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditGiven,
        amountPaise: 800000, // ₹8,000
        cashDeltaPaise: 0,
        creditDeltaPaise: 800000,
        customerId: Value(sureshId),
        method: PaymentMethod.credit,
        note: 'Snacks & beverages wholesale',
        source: EntrySource.manual,
        occurredAt: now.subtract(const Duration(days: 33)),
        createdAt: now.subtract(const Duration(days: 33)),
      ),
    );

    // Anil Kirana: +₹4,200 outstanding (due in 5 days)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditGiven,
        amountPaise: 420000, // ₹4,200
        cashDeltaPaise: 0,
        creditDeltaPaise: 420000,
        customerId: Value(anilId),
        method: PaymentMethod.credit,
        note: 'Dairy & groceries',
        source: EntrySource.manual,
        occurredAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    );

    // Mehta General Store: ₹2,000 paid / cleared
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditGiven,
        amountPaise: 200000,
        cashDeltaPaise: 0,
        creditDeltaPaise: 200000,
        customerId: Value(mehtaId),
        method: PaymentMethod.credit,
        note: 'Goods invoice',
        source: EntrySource.manual,
        occurredAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    );
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditRepayment,
        amountPaise: 200000,
        cashDeltaPaise: 200000,
        creditDeltaPaise: -200000,
        customerId: Value(mehtaId),
        method: PaymentMethod.upi,
        note: 'Bill cleared in full',
        source: EntrySource.manual,
        occurredAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    );

    // 7. Today's Transactions matching Mockup 4
    // 2:14 PM: Sales ₹5,000 (Cash)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.sale,
        amountPaise: 500000,
        cashDeltaPaise: 500000,
        creditDeltaPaise: 0,
        method: PaymentMethod.cash,
        note: 'Counter sales',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 14, minutes: 14)),
        createdAt: today.add(const Duration(hours: 14, minutes: 14)),
      ),
    );

    // 11:30 AM: Expense (Shop Rent, Bank) ₹12,000
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.expense,
        amountPaise: 1200000,
        cashDeltaPaise: -1200000,
        creditDeltaPaise: 0,
        method: PaymentMethod.bank,
        note: 'Shop Rent',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 11, minutes: 30)),
        createdAt: today.add(const Duration(hours: 11, minutes: 30)),
      ),
    );

    // 10:20 AM: Udhaar Received - Ramesh (UPI) ₹2,000
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.creditRepayment,
        amountPaise: 200000,
        cashDeltaPaise: 200000,
        creditDeltaPaise: -200000,
        customerId: Value(rameshId),
        method: PaymentMethod.upi,
        note: 'Ramesh repayment',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 10, minutes: 20)),
        createdAt: today.add(const Duration(hours: 10, minutes: 20)),
      ),
    );

    // 9:15 AM: Purchase - Supplier (Credit) ₹8,400
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.expense,
        amountPaise: 840000,
        cashDeltaPaise: 0,
        creditDeltaPaise: 0,
        supplierId: Value(singhSupplierId),
        method: PaymentMethod.credit,
        note: 'Singh Distributors restock invoice',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 9, minutes: 15)),
        createdAt: today.add(const Duration(hours: 9, minutes: 15)),
      ),
    );

    // Morning counter sales to match total today's sales ₹56,320
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.sale,
        amountPaise: 5132000, // ₹51,320
        cashDeltaPaise: 5132000,
        creditDeltaPaise: 0,
        method: PaymentMethod.cash,
        note: 'Morning retail footfall sales',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 8, minutes: 30)),
        createdAt: today.add(const Duration(hours: 8, minutes: 30)),
      ),
    );

    // Electricity/miscellaneous expense ₹6,940 to match ₹18,940 total today expenses
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.expense,
        amountPaise: 694000, // ₹6,940
        cashDeltaPaise: -694000,
        creditDeltaPaise: 0,
        method: PaymentMethod.upi,
        note: 'Electricity & utility bill',
        source: EntrySource.manual,
        occurredAt: today.add(const Duration(hours: 9, minutes: 0)),
        createdAt: today.add(const Duration(hours: 9, minutes: 0)),
      ),
    );

    // 8. Yesterday's transactions
    // 2:15 PM: Sales ₹18,500 (Cash)
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        kind: TransactionKind.sale,
        amountPaise: 1850000,
        cashDeltaPaise: 1850000,
        creditDeltaPaise: 0,
        method: PaymentMethod.cash,
        note: 'Afternoon sales',
        source: EntrySource.manual,
        occurredAt: yesterday.add(const Duration(hours: 14, minutes: 15)),
        createdAt: yesterday.add(const Duration(hours: 14, minutes: 15)),
      ),
    );
  }
}
