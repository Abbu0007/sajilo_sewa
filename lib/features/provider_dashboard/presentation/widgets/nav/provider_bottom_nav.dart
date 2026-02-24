import 'package:flutter/material.dart';

class ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const ProviderBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: Offset(0, -8),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              _NavItem(
                label: "Home",
                icon: Icons.home_rounded,
                active: currentIndex == 0,
                primary: primary,
                onTap: () => onChanged(0),
              ),
              _NavItem(
                label: "Bookings",
                icon: Icons.calendar_month_rounded,
                active: currentIndex == 1,
                primary: primary,
                onTap: () => onChanged(1),
              ),
              _NavItem(
                label: "Profile",
                icon: Icons.person_rounded,
                active: currentIndex == 2,
                primary: primary,
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color primary;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: active ? 44 : 38,
                decoration: BoxDecoration(
                  color: active ? primary.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                top: active ? -10 : 0,
                child: Container(
                  height: active ? 42 : 38,
                  width: active ? 42 : 38,
                  decoration: BoxDecoration(
                    color: active ? primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: active
                        ? const [
                            BoxShadow(
                              blurRadius: 16,
                              offset: Offset(0, 8),
                              color: Color(0x22000000),
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: active ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: active ? 1 : 0,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}