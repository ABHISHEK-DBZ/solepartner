import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _pulseController;
  final TextEditingController _text = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  AssistantAnswer? _answer;
  ParsedCommand? _command;
  int? _customerId;
  PaymentMethod _method = PaymentMethod.cash;
  bool _listening = false;
  bool _busy = false;

  String _currentTranscript =
      '"Aaj 5,000 ka sales add karo aur Ramesh ka 2,000 udhaar receive mark karo."';

  static const List<String> _suggestedChips = <String>[
    '+ Add Sale',
    'Record Expense',
    'Check Stock',
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _text.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _toggleListen() async {
    HapticFeedback.mediumImpact();
    if (_listening) {
      await ref.read(speechServiceProvider).stop();
      setState(() => _listening = false);
      return;
    }

    setState(() {
      _listening = true;
      _currentTranscript = 'Listening to your voice...';
    });

    try {
      final String transcript =
          await ref.read(speechServiceProvider).listenOnce(languageCode: 'hi');
      if (!mounted) return;
      if (transcript.trim().isNotEmpty) {
        setState(() {
          _currentTranscript = '"$transcript"';
          _text.text = transcript;
        });
        await _processText(transcript);
      } else {
        setState(() {
          _currentTranscript =
              '"Aaj 5,000 ka sales add karo aur Ramesh ka 2,000 udhaar receive mark karo."';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _currentTranscript =
              '"Aaj 5,000 ka sales add karo aur Ramesh ka 2,000 udhaar receive mark karo."';
        });
      }
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  Future<void> _processText(String prompt) async {
    setState(() {
      _busy = true;
      _answer = null;
      _command = null;
    });

    try {
      final AssistantAnswer answer =
          await ref.read(assistantServiceProvider).ask(prompt, languageCode: 'hi');
      if (!mounted) return;
      setState(() {
        _answer = answer;
        _command = answer.command;
        _customerId = answer.command?.customerId;
        _method = answer.command?.method ?? PaymentMethod.cash;
        if (answer.command?.amountPaise != null) {
          _amount.text = Money.rupeeFieldValue(answer.command!.amountPaise);
        }
      });
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveEntry() async {
    final ParsedCommand? cmd = _command;
    if (cmd == null) return;
    final int? paise = Money.parseRupeeField(_amount.text);
    if (paise == null) {
      showError(context, 'Enter a valid amount.');
      return;
    }

    setState(() => _busy = true);
    try {
      final result = await ref.read(commandExecutorProvider).execute(
            cmd.copyWith(
              amountPaise: paise,
              customerId: _customerId,
              method: _method,
            ),
            languageCode: 'hi',
          );
      if (!mounted) return;
      showMessage(context, result.message);
      setState(() {
        _command = null;
        _answer = AssistantAnswer(message: result.message);
      });
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Voice Copilot'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.graphic_eq_rounded, color: colors.primary, size: 24),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Title & Subtitle matching Mockup 3
              Text(
                'Talk to KhataCopilot',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your AI Business Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Waveform and Center Glowing Mic
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Animated audio waves behind button
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (BuildContext context, Widget? child) {
                        return CustomPaint(
                          size: const Size(double.infinity, 120),
                          painter: _AudioWavePainter(
                            animationValue: _waveController.value,
                            isListening: _listening,
                            waveColor: colors.accent.withValues(alpha: 0.35),
                          ),
                        );
                      },
                    ),

                    // Outer pulsing glow
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (BuildContext context, Widget? child) {
                        final double pulse = _pulseController.value;
                        return Container(
                          height: 110 + (pulse * 24),
                          width: 110 + (pulse * 24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.08 + (0.08 * pulse)),
                          ),
                        );
                      },
                    ),

                    // Central Glowing Microphone Button
                    GestureDetector(
                      onTap: _toggleListen,
                      child: Container(
                        height: 92,
                        width: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: <Color>[
                              _listening ? colors.error : colors.primary,
                              _listening ? const Color(0xFFF87171) : colors.accent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: (_listening ? colors.error : colors.primary)
                                  .withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _listening ? Icons.stop_rounded : Icons.mic_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                _listening ? 'Listening...' : (_busy ? 'Processing...' : 'Tap to speak'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _listening ? colors.error : colors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Live Transcription Box matching Mockup 3
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                color: colors.surface,
                borderRadius: 20,
                child: Text(
                  _currentTranscript,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Suggested Voice Command Chips matching Mockup 3
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _suggestedChips.map((String text) {
                  return ActionChip(
                    label: Text(text),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (text == '+ Add Sale') {
                        _text.text = 'Aaj 5000 ka cash sales add karo';
                        _currentTranscript = '"Aaj 5000 ka cash sales add karo"';
                        _processText(_text.text);
                      } else if (text == 'Record Expense') {
                        _text.text = 'Shop rent 12000 bank se pay kiya';
                        _currentTranscript = '"Shop rent 12000 bank se pay kiya"';
                        _processText(_text.text);
                      } else {
                        _text.text = 'Stock check karo Maggi aur Parle-G ka';
                        _currentTranscript = '"Stock check karo Maggi aur Parle-G ka"';
                        _processText(_text.text);
                      }
                    },
                    backgroundColor: colors.surface,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colors.border),
                    ),
                  );
                }).toList(),
              ),

              // Answer & Parsed Command Confirmation
              if (_answer != null) ...<Widget>[
                const SizedBox(height: 20),
                AppCard(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderColor: colors.primary.withValues(alpha: 0.2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.auto_awesome_rounded, color: colors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _answer!.message,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (_command != null) ...<Widget>[
                const SizedBox(height: 18),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Parsed Action: ${_command!.actionLabel}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AmountField(controller: _amount, label: 'Amount (₹)'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: _busy ? null : _saveEntry,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Confirm & Save to Ledger'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioWavePainter extends CustomPainter {
  _AudioWavePainter({
    required this.animationValue,
    required this.isListening,
    required this.waveColor,
  });

  final double animationValue;
  final bool isListening;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double midY = size.height / 2;
    final Path path1 = Path();
    final Path path2 = Path();

    path1.moveTo(0, midY);
    path2.moveTo(0, midY);

    final double freq = isListening ? 4.0 : 2.5;
    final double amp = isListening ? 26.0 : 12.0;

    for (double x = 0; x <= size.width; x += 4) {
      final double y1 = midY +
          math.sin((x / size.width * freq * math.pi) + (animationValue * 2 * math.pi)) *
              amp *
              math.sin(x / size.width * math.pi);
      final double y2 = midY +
          math.cos((x / size.width * freq * math.pi) + (animationValue * 2 * math.pi)) *
              (amp * 0.7) *
              math.sin(x / size.width * math.pi);
      path1.lineTo(x, y1);
      path2.lineTo(x, y2);
    }

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint..color = waveColor.withValues(alpha: 0.2));
  }

  @override
  bool shouldRepaint(covariant _AudioWavePainter oldDelegate) => true;
}
