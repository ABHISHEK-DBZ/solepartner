import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  bool _busy = false;

  Future<void> _connect() async {
    setState(() => _busy = true);
    try {
      await ref.read(walletProvider.notifier).connect();
      if (mounted) showMessage(context, 'Wallet connected on Devnet.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disconnect() async {
    setState(() => _busy = true);
    try {
      await ref.read(walletProvider.notifier).disconnect();
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final WalletSnapshot wallet = ref.watch(walletProvider);
    final AsyncValue<List<PaymentProposal>> paymentsAsync =
        ref.watch(allPaymentsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Solana Wallet'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Spending Policy & Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/policy'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: colors.primary,
          onRefresh: () async {
            await ref.read(walletProvider.notifier).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: <Widget>[
              _SolanaBalanceCard(
                wallet: wallet,
                busy: _busy,
                onConnect: _connect,
                onDisconnect: _disconnect,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _WalletActionButton(
                    icon: Icons.arrow_upward_rounded,
                    label: 'Send',
                    onTap: () => context.push('/pay/new'),
                  ),
                  _WalletActionButton(
                    icon: Icons.qr_code_rounded,
                    label: 'Receive',
                    onTap: () => _showReceiveModal(context, wallet),
                  ),
                  _WalletActionButton(
                    icon: Icons.add_card_rounded,
                    label: 'Buy SOL',
                    onTap: () => _showAirdropModal(context, wallet),
                  ),
                  _WalletActionButton(
                    icon: Icons.history_rounded,
                    label: 'History',
                    onTap: () => context.push('/payments'),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Recent Payments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/payments'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              paymentsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (Object error, StackTrace _) => Text(
                  'Could not load payments: $error',
                  style: TextStyle(fontSize: 12.5, color: colors.error),
                ),
                data: (List<PaymentProposal> payments) {
                  if (payments.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No payments yet. Send your first Devnet payment.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: payments
                        .take(5)
                        .map((PaymentProposal payment) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _WalletTransactionRow(
                                payment: payment,
                                onTap: () => context
                                    .push('/payments/${payment.id}'),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),

              AppCard(
                color: colors.surface,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.shield_outlined, color: colors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Solana Devnet • Zero-Trust Security',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Keys never leave your external wallet. The AI only '
                            'proposes transactions; you sign each one.',
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReceiveModal(BuildContext context, WalletSnapshot wallet) {
    final String? address = wallet.address;
    if (address == null) {
      showMessage(context, 'Connect a wallet before receiving SOL.');
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final AppThemeColors colors = context.appColors;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Receive SOL (Devnet)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: const Icon(Icons.qr_code_2_rounded,
                    size: 100, color: Colors.black87),
              ),
              const SizedBox(height: 14),
              SelectableText(
                address,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  Navigator.pop(context);
                  showMessage(context, 'Wallet address copied to clipboard');
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy Address'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAirdropModal(BuildContext context, WalletSnapshot wallet) {
    final String? address = wallet.address;
    if (address == null) {
      showMessage(context, 'Connect a wallet before requesting an airdrop.');
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Solana Devnet Faucet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Request test SOL directly on Solana Devnet for testing payments.',
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  showMessage(context, 'Requesting 1 SOL Devnet airdrop...');
                  try {
                    await ref
                        .read(solanaServiceProvider)
                        .requestAirdrop(address);
                    await ref.read(walletProvider.notifier).refresh();
                    if (context.mounted) {
                      showMessage(context, 'Airdrop confirmed!');
                    }
                  } catch (error) {
                    if (context.mounted) showError(context, error);
                  }
                },
                child: const Text('Request 1 SOL Airdrop'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SolanaBalanceCard extends StatelessWidget {
  const _SolanaBalanceCard({
    required this.wallet,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
  });

  final WalletSnapshot wallet;
  final bool busy;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final int? lamports = wallet.balanceLamports;
    final String balance =
        lamports == null ? '—' : Money.formatSol(lamports, maxDecimals: 9);
    final String address = wallet.address ?? '';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF0F1A28),
            Color(0xFF1B2838),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Wallet Balance',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF9945FF), Color(0xFF14F195)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DEVNET TESTNET',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            wallet.connected ? '$balance SOL' : 'Not connected',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            wallet.connected
                ? 'Devnet • ${address.length > 12 ? '${address.substring(0, 4)}…${address.substring(address.length - 4)}' : address}'
                : (wallet.isMwaSupported
                    ? 'Connect Phantom or Solflare set to Devnet.'
                    : 'Solana Mobile Wallet Adapter required (Phantom/Solflare).'),
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (wallet.lastActivity != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              'Last activity: ${fullDateTime.format(wallet.lastActivity!)}',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
              ),
            ),
          ],
          if (wallet.balanceError != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              wallet.balanceError!,
              style: const TextStyle(color: Color(0xFFF87171), fontSize: 11.5),
            ),
          ],
          const SizedBox(height: 16),
          if (!wallet.connected)
            FilledButton.icon(
              onPressed: busy ? null : onConnect,
              icon: busy
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.link_rounded, size: 18),
              label: const Text('Connect Wallet'),
            )
          else
            OutlinedButton.icon(
              onPressed: busy ? null : onDisconnect,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0x55FFFFFF)),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Disconnect'),
            ),
        ],
      ),
    );
  }
}

class _WalletActionButton extends StatelessWidget {
  const _WalletActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.border.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: colors.textPrimary, size: 22),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _WalletTransactionRow extends StatelessWidget {
  const _WalletTransactionRow({
    required this.payment,
    required this.onTap,
  });

  final PaymentProposal payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final bool confirmed = payment.status == PaymentStatus.confirmed;
    final Color badgeColor = confirmed ? colors.success : colors.error;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              confirmed
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              size: 18,
              color: badgeColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  payment.recipientName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${friendlyDay(payment.createdAt)} • ${payment.status.label}',
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '-${Money.formatSol(payment.amountLamports)} SOL',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
