import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';

final StreamProvider<List<AuditLog>> _auditLogsProvider =
    StreamProvider<List<AuditLog>>((ref) {
      final AppDatabase db = ref.watch(databaseProvider);
      return db.select(db.auditLogs).watch().map((List<AuditLog> rows) {
        final List<AuditLog> sorted = <AuditLog>[...rows];
        sorted.sort(
          (AuditLog a, AuditLog b) => b.createdAt.compareTo(a.createdAt),
        );
        return sorted;
      });
    });

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<AuditLog>> logs = ref.watch(_auditLogsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Audit log')),
      body: AsyncView<List<AuditLog>>(
        value: logs,
        builder: (List<AuditLog> rows) {
          if (rows.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'Nothing recorded yet',
              message:
                  'Every ledger, stock and payment change will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final AuditLog log = rows[index];
              return AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            log.action.replaceAll('_', ' '),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        StatusPill(label: log.entityType.toUpperCase()),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${fullDateTime.format(log.createdAt)}'
                      '${log.entityId == null ? '' : ' · #${log.entityId}'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (log.detailsJson != '{}' &&
                        log.detailsJson.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        log.detailsJson,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
