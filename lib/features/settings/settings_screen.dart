import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../domain/ai_config.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _shop = TextEditingController();
  final TextEditingController _owner = TextEditingController();
  final TextEditingController _endpoint = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _key = TextEditingController();
  String _businessType = 'Kirana store';
  String _language = 'en';
  bool _voice = true;
  bool _cloudConsent = false;
  bool _seeded = false;
  bool _busy = false;

  static const List<String> _businessTypes = <String>[
    'Kirana store',
    'Grocery retailer',
    'General store',
    'Distributor',
    'Wholesaler',
    'Other',
  ];

  @override
  void dispose() {
    _shop.dispose();
    _owner.dispose();
    _endpoint.dispose();
    _model.dispose();
    _key.dispose();
    super.dispose();
  }

  void _seed(MerchantProfile? profile, AiConfig? ai, bool voice, bool consent) {
    if (_seeded) return;
    _seeded = true;
    _shop.text = profile?.shopName ?? '';
    _owner.text = profile?.ownerName ?? '';
    _businessType = profile?.businessType ?? _businessType;
    _language = profile?.languageCode ?? _language;
    _endpoint.text = ai?.endpoint ?? '';
    _model.text = ai?.model ?? '';
    _voice = voice;
    _cloudConsent = consent;
  }

  Future<void> _save() async {
    if (_shop.text.trim().isEmpty) {
      showError(context, 'Shop name is required.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(merchantRepositoryProvider).saveMerchant(
            shopName: _shop.text,
            ownerName: _owner.text,
            businessType: _businessType,
            languageCode: _language,
          );
      await ref.read(settingsRepositoryProvider).saveAiConfig(
            endpoint: _endpoint.text,
            model: _model.text,
            apiKey: _key.text,
          );
      await ref.read(settingsRepositoryProvider).setVoiceResponsesEnabled(_voice);
      await ref
          .read(settingsRepositoryProvider)
          .setCloudConsentEnabled(_cloudConsent);
      ref.invalidate(aiConfigProvider);
      ref.invalidate(voiceRepliesProvider);
      ref.invalidate(cloudConsentProvider);
      if (mounted) showMessage(context, 'Settings saved.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _busy = true);
    try {
      final List<LedgerEntry> entries =
          await ref.read(ledgerRepositoryProvider).allEntries();
      final List<CustomerView> customers =
          await ref.read(customerRepositoryProvider).loadCustomers();
      final List<Product> products =
          await ref.read(inventoryRepositoryProvider).allProducts();
      final StringBuffer csv = StringBuffer()
        ..writeln('Transactions')
        ..writeln('id,date,kind,amountPaise,cashDeltaPaise,creditDeltaPaise,'
            'method,note');
      for (final LedgerEntry entry in entries) {
        csv.writeln(<String>[
          '${entry.id}',
          entry.occurredAt.toIso8601String(),
          entry.kind.name,
          '${entry.amountPaise}',
          '${entry.cashDeltaPaise}',
          '${entry.creditDeltaPaise}',
          entry.method.name,
          _csvCell(entry.note),
        ].join(','));
      }
      csv
        ..writeln()
        ..writeln('Customers')
        ..writeln('id,name,phone,outstandingPaise')
        ..writeln();
      for (final CustomerView customer in customers) {
        csv.writeln(<String>[
          '${customer.id}',
          _csvCell(customer.name),
          _csvCell(customer.phone),
          '${customer.outstandingPaise}',
        ].join(','));
      }
      csv
        ..writeln()
        ..writeln('Products')
        ..writeln('id,name,sku,stockQty,sellingPricePaise')
        ..writeln();
      for (final Product product in products) {
        csv.writeln(<String>[
          '${product.id}',
          _csvCell(product.name),
          _csvCell(product.sku),
          '${product.stockQty}',
          '${product.sellingPricePaise}',
        ].join(','));
      }
      await SharePlus.instance.share(
        ShareParams(
          text: csv.toString(),
          subject: 'KhataCopilot data export',
        ),
      );
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _csvCell(String value) =>
      '"${value.replaceAll('"', '""')}"';

  Future<void> _confirmClearData() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This deletes every customer, product, transaction and payment on '
          'this device. It cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(databaseProvider).clearAllData();
      ref.invalidate(aiConfigProvider);
      ref.invalidate(voiceRepliesProvider);
      ref.invalidate(cloudConsentProvider);
      if (mounted) showMessage(context, 'All local data cleared.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    final AsyncValue<MerchantProfile?> merchant = ref.watch(merchantProfileProvider);
    final AsyncValue<AiConfig?> ai = ref.watch(aiConfigProvider);
    final AsyncValue<bool> voice = ref.watch(voiceRepliesProvider);
    final AsyncValue<bool> consent = ref.watch(cloudConsentProvider);
    if (!_seeded &&
        merchant.hasValue &&
        ai.hasValue &&
        voice.hasValue &&
        consent.hasValue) {
      _seed(
        merchant.value,
        ai.value,
        voice.value ?? true,
        consent.value ?? false,
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const <Widget>[
          AnimatedThemeToggle(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: <Widget>[
          // Section: Appearance & Theme Switching (Requirement 4)
          const SectionHeader(title: 'Appearance & Theme'),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose App Theme',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _ThemeChoiceCard(
                        title: 'Light',
                        icon: Icons.light_mode_rounded,
                        isSelected: themeMode == ThemeMode.light,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ThemeChoiceCard(
                        title: 'Dark',
                        icon: Icons.dark_mode_rounded,
                        isSelected: themeMode == ThemeMode.dark,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ThemeChoiceCard(
                        title: 'System',
                        icon: Icons.brightness_auto_rounded,
                        isSelected: themeMode == ThemeMode.system,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Shop Profile
          const SectionHeader(title: 'Shop profile'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabeledField(
                  label: 'Shop name',
                  child: TextField(
                    controller: _shop,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Rahul Kirana Store',
                    ),
                  ),
                ),
                LabeledField(
                  label: 'Owner name',
                  child: TextField(
                    controller: _owner,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: 'Rahul'),
                  ),
                ),
                LabeledField(
                  label: 'Business type',
                  child: DropdownButtonFormField<String>(
                    initialValue: _businessTypes.contains(_businessType)
                        ? _businessType
                        : _businessTypes.first,
                    items: _businessTypes
                        .map(
                          (String type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value != null) setState(() => _businessType = value);
                    },
                  ),
                ),
                LabeledField(
                  label: 'Preferred voice language',
                  child: Wrap(
                    spacing: 8,
                    children: kSupportedLanguages.entries
                        .map(
                          (MapEntry<String, String> entry) => ChoiceChip(
                            label: Text(entry.value),
                            selected: _language == entry.key,
                            onSelected: (_) =>
                                setState(() => _language = entry.key),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Assistant audio replies
          const SectionHeader(title: 'Assistant preferences'),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SwitchListTile(
              value: _voice,
              activeThumbColor: colors.primary,
              onChanged: (bool value) => setState(() => _voice = value),
              title: const Text('Speak replies aloud'),
              subtitle: const Text('Read assistant answers using speech synthesis.'),
            ),
          ),
          const SizedBox(height: 20),

          // Cloud AI Settings
          SectionHeader(
            title: 'Cloud AI (optional)',
            trailing: StatusPill(
              label: ai.valueOrNull == null ? 'ON-DEVICE ONLY' : 'CONFIGURED',
              color: ai.valueOrNull == null ? colors.textSecondary : colors.success,
              background: ai.valueOrNull == null ? colors.chipBackground : colors.success.withValues(alpha: 0.12),
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'The on-device parser always runs first. A cloud model is '
                  'only asked to understand complex vernacular language; it never computes money.',
                  style: TextStyle(fontSize: 12.8, height: 1.45),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _cloudConsent,
                  activeThumbColor: colors.primary,
                  onChanged: (bool value) =>
                      setState(() => _cloudConsent = value),
                  title: const Text('Allow cloud AI'),
                  subtitle: const Text(
                    'Sends only the command text and aggregate totals over HTTPS. '
                    'No customer names, phone numbers or notes leave the device.',
                  ),
                ),
                const SizedBox(height: 8),
                LabeledField(
                  label: 'Endpoint',
                  child: TextField(
                    controller: _endpoint,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      hintText: 'https://api.groq.com/openai/v1',
                    ),
                  ),
                ),
                LabeledField(
                  label: 'Model',
                  child: TextField(
                    controller: _model,
                    decoration: const InputDecoration(
                        hintText: 'openai/gpt-oss-120b'),
                  ),
                ),
                LabeledField(
                  label: 'API key',
                  hint: 'Stored securely on-device with FlutterSecureStorage.',
                  child: TextField(
                    controller: _key,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Leave blank to keep current key',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: _busy ? null : _save,
            child: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Settings'),
          ),
          const SizedBox(height: 24),

          // Data & backup
          const SectionHeader(title: 'Data & backup'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Your ledger stays on this device. Export a CSV to share it '
                  'with your accountant, or clear it before handing the phone '
                  'to someone else.',
                  style: TextStyle(fontSize: 12.8, height: 1.45),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _exportCsv,
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: const Text('Export data as CSV'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _confirmClearData,
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 18, color: colors.error),
                  label: Text(
                    'Clear all local data',
                    style: TextStyle(color: colors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    side: BorderSide(color: colors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Information
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'KhataCopilot v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your Voice. Your Ledger. Your AI Payment Agent.',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChoiceCard extends StatelessWidget {
  const _ThemeChoiceCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.12) : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 22,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
