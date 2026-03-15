import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  AppTheme  –  single source of truth
// ─────────────────────────────────────────
class AppTheme {
  final bool isDark;
  const AppTheme._(this.isDark);

  static const dark  = AppTheme._(true);
  static const light = AppTheme._(false);

  // ── Backgrounds ──
  Color get bgBase      => isDark ? const Color(0xFF0A0A0F) : const Color(0xFFFFF0F5);
  Color get bgSurface   => isDark ? const Color(0xFF16101A) : const Color(0xFFFFFFFF);
  Color get bgCard      => isDark ? const Color(0xFF1E1220) : const Color(0xFFFFFFFF);

  // ── Brand ──
  Color get pink        => const Color(0xFFE91E8C);
  Color get pinkDark    => const Color(0xFFC2185B);
  Color get pinkLight   => const Color(0xFFFF6EB4);
  Color get pinkPale    => isDark ? const Color(0x33E91E8C) : const Color(0xFFFFD6EB);
  Color get gold        => const Color(0xFFD4AF37);
  Color get goldDark    => const Color(0xFFB8962E);

  // ── Text ──
  Color get textPrimary => isDark ? Colors.white           : const Color(0xFF2D1B2E);
  Color get textSecond  => isDark ? const Color(0xFFBB8FAE): const Color(0xFF8A5A78);
  Color get textDim     => isDark ? const Color(0xFF7A6A7E): const Color(0xFFBB8FAE);

  // ── Borders / dividers ──
  Color get border      => isDark
      ? Colors.white.withOpacity(0.10)
      : const Color(0xFFE91E8C).withOpacity(0.18);

  // ── Shadows ──
  List<BoxShadow> get cardShadow => isDark
      ? [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]
      : [BoxShadow(color: const Color(0xFFE91E8C).withOpacity(0.10), blurRadius: 18, offset: const Offset(0, 6))];

  // ── Orb / ambient colors ──
  Color get orbA => isDark
      ? const Color(0xFFE91E8C).withOpacity(0.13)
      : const Color(0xFFE91E8C).withOpacity(0.07);
  Color get orbB => isDark
      ? const Color(0xFFC2185B).withOpacity(0.10)
      : const Color(0xFFFF6EB4).withOpacity(0.10);

  // ── Shimmer ──
  Color get shimmerBase      => isDark ? const Color(0xFF1E1220) : const Color(0xFFFFE4F0);
  Color get shimmerHighlight => isDark ? const Color(0xFF2E1A2E) : const Color(0xFFFFF0F5);
}

// ─────────────────────────────────────────
//  ThemeProvider  –  InheritedWidget
// ─────────────────────────────────────────
class ThemeProvider extends InheritedWidget {
  final bool isDark;
  final VoidCallback toggle;

  const ThemeProvider({
    super.key,
    required this.isDark,
    required this.toggle,
    required super.child,
  });

  AppTheme get theme => isDark ? AppTheme.dark : AppTheme.light;

  static ThemeProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemeProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeProvider old) => isDark != old.isDark;
}

// ─────────────────────────────────────────
//  ThemeToggleButton  –  reusable widget
// ─────────────────────────────────────────
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = ThemeProvider.of(context);
    final t = provider.theme;

    return GestureDetector(
      onTap: provider.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: provider.isDark ? t.pinkPale : t.pink.withOpacity(0.15),
          border: Border.all(color: t.border, width: 1),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: provider.isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [t.pink, t.pinkDark]),
              boxShadow: [BoxShadow(color: t.pink.withOpacity(0.4), blurRadius: 6)],
            ),
            child: Icon(
              provider.isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              color: Colors.white,
              size: 10,
            ),
          ),
        ),
      ),
    );
  }
}
