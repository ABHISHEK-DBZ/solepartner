import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0; // 0 = Intro Tour, 1 = Setup Form
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final TextEditingController _shop =
      TextEditingController(text: 'Rahul Kirana Store');
  final TextEditingController _owner = TextEditingController(text: 'Rahul');
  String _businessType = 'Kirana store';
  String _language = 'en';
  bool _saving = false;

  static const List<String> _businessTypes = <String>[
    'Kirana store',
    'Grocery retailer',
    'General store',
    'Distributor',
    'Wholesaler',
    'Other',
  ];

  static const List<_IntroSlide> _slides = <_IntroSlide>[
    _IntroSlide(
      titlePrefix: 'Your Smart\n',
      titleHighlight: 'Business Partner',
      subtitle:
          'Manage your store with voice, keep a smart ledger, control inventory and make secure AI payments.',
    ),
    _IntroSlide(
      titlePrefix: 'Voice-First\n',
      titleHighlight: 'Kirana Copilot',
      subtitle:
          'Speak naturally in Hindi, Hinglish or English to add sales, record expenses and track udhaar hands-free.',
    ),
    _IntroSlide(
      titlePrefix: 'Deterministic\n',
      titleHighlight: 'AI Payment Agent',
      subtitle:
          'Prepare, review and approve payments safely with zero-trust spending policies and instant Solana settlement.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _shop.dispose();
    _owner.dispose();
    super.dispose();
  }

  Future<void> _skipToHome() async {
    HapticFeedback.lightImpact();
    setState(() => _saving = true);
    try {
      await ref.read(merchantRepositoryProvider).saveMerchant(
            shopName: _shop.text.trim(),
            ownerName: _owner.text.trim(),
            businessType: _businessType,
            languageCode: _language,
          );
      if (!mounted) return;
      context.go('/');
    } catch (_) {
      if (mounted) context.go('/');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveMerchant() async {
    if (_shop.text.trim().isEmpty) {
      showError(context, 'Enter your shop name to continue.');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(merchantRepositoryProvider).saveMerchant(
            shopName: _shop.text.trim(),
            ownerName: _owner.text.trim(),
            businessType: _businessType,
            languageCode: _language,
          );
      if (!mounted) return;
      context.go('/');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062217),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: _step == 0 ? _buildIntroTour() : _buildSetupForm(),
        ),
      ),
    );
  }

  /// Exact replica of the Intro screen shown in media_1794143593341_06051e48.jpg
  Widget _buildIntroTour() {
    final AppThemeColors colors = context.appColors;
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        // Top 3D Artwork (Robot + Shop + Holographic Displays)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenSize.height * 0.48,
          child: Container(
            color: const Color(0xFF062217),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/images/intro_artwork.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/intro_screen.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Bottom Content Card with white surface and rounded corners
        Positioned(
          top: screenSize.height * 0.44,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Title and Subtitle with PageView
                    Expanded(
                      flex: 4,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (int index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final _IntroSlide slide = _slides[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.6,
                                    height: 1.2,
                                    fontFamily: 'Inter',
                                    color: colors.textPrimary,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: slide.titlePrefix),
                                    TextSpan(
                                      text: slide.titleHighlight,
                                      style: TextStyle(
                                        color: colors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  slide.subtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // 4 Feature Quick Cards matching the Mockup
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _featureCard(
                            icon: Icons.mic_rounded,
                            label: 'Voice\nBookkeeping',
                            colors: colors,
                            onTap: () {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          _featureCard(
                            icon: Icons.bar_chart_rounded,
                            label: 'Smart\nLedger',
                            colors: colors,
                            onTap: () {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          _featureCard(
                            icon: Icons.inventory_2_rounded,
                            label: 'Inventory\nControl',
                            colors: colors,
                            onTap: () {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          _featureCard(
                            icon: Icons.bolt_rounded,
                            label: 'AI\nPayments',
                            colors: colors,
                            onTap: () {
                              _pageController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Carousel Dots (3 dots)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_slides.length, (int index) {
                        final bool isActive = _currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 7,
                          width: isActive ? 22 : 7,
                          decoration: BoxDecoration(
                            color: isActive
                                ? colors.primary
                                : colors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),

                    // "Get Started ->" Button
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[colors.primary, colors.accent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(26),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _step = 1);
                          },
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // "Skip" Button
                    TextButton(
                      onPressed: _skipToHome,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String label,
    required AppThemeColors colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                icon,
                color: const Color(0xFF087F5B),
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupForm() {
    final AppThemeColors colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => _step = 0),
        ),
        title: const Text('Setup Your Shop'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SolePartner brand badge
            Center(
              child: Image.asset(
                'assets/images/app_logo.png',
                height: 70,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to SolePartner! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configure your store profile to initialize your voice agent & local ledger.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LabeledField(
                    label: 'Shop Name',
                    child: TextField(
                      controller: _shop,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Rahul Kirana Store',
                      ),
                    ),
                  ),
                  LabeledField(
                    label: 'Owner Name',
                    child: TextField(
                      controller: _owner,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Rahul'),
                    ),
                  ),
                  LabeledField(
                    label: 'Business Type',
                    child: DropdownButtonFormField<String>(
                      initialValue: _businessType,
                      items: _businessTypes
                          .map((String type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        if (value != null) setState(() => _businessType = value);
                      },
                    ),
                  ),
                  LabeledField(
                    label: 'Preferred Voice Language',
                    child: Wrap(
                      spacing: 8,
                      children: kSupportedLanguages.entries
                          .map((MapEntry<String, String> entry) => ChoiceChip(
                                label: Text(entry.value),
                                selected: _language == entry.key,
                                onSelected: (_) =>
                                    setState(() => _language = entry.key),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _saveMerchant,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Start Using SolePartner'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroSlide {
  const _IntroSlide({
    required this.titlePrefix,
    required this.titleHighlight,
    required this.subtitle,
  });

  final String titlePrefix;
  final String titleHighlight;
  final String subtitle;
}
