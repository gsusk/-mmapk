import 'package:flutter/material.dart';

import '../pages/cart_page.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';
import '../state/app_state.dart';

class StoreNavbar extends StatelessWidget {
  const StoreNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: primary, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text(
              'MMARK',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: SearchBox()),
          const SizedBox(width: 6),
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) => _NavbarIcon(
              icon: Icons.shopping_cart_outlined,
              label: 'Carrito',
              badge: '${appState.itemCount}',
              color: Theme.of(context).colorScheme.error,
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CartPage())),
            ),
          ),
          _NavbarIcon(
            icon: appState.isLoggedIn
                ? Icons.account_circle_outlined
                : Icons.login_outlined,
            label: appState.isLoggedIn ? 'Cuenta' : 'Ingresar',
            color: const Color(0xFF0F172A),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(
              builder: (_) => appState.isLoggedIn ? const ProfilePage() : const LoginPage(),
            )),
          ),
        ],
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SearchPage(initialQuery: query)));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: submit,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            tooltip: 'Buscar',
            onPressed: () => submit(controller.text),
            icon: const Icon(Icons.arrow_forward),
          ),
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarIcon extends StatelessWidget {
  const _NavbarIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
    );
    if (badge == null || badge == '0') return button;
    return Badge(label: Text(badge!), backgroundColor: color, child: button);
  }
}

class HeroCarousel extends StatelessWidget {
  const HeroCarousel({super.key});

  static const slides = [
    HeroSlideData(
      title: 'El Futuro Del Sonido',
      subtitle: 'RECIEN LLEGADO',
      description:
          'Cancelacion de sonido premium para audifonos para experiencia de audio definitiva',
      image: 'assets/images/headphones.jpg',
      background: Color(0xFFF8FAFC),
      buttonColor: Color(0xFF0284C7),
    ),
    HeroSlideData(
      title: 'Para Refrescar tu Cocina',
      subtitle: 'Hasta 30% de Descuento!',
      description:
          'Actualiza al ultimo Refrigerador LG Smart con tecnologia puerta a puerta.',
      image: 'assets/images/LG_REF_GR-H812HLHM_9.webp',
      background: Color(0xFFF0FDF4),
      buttonColor: Color(0xFF16A34A),
    ),
    HeroSlideData(
      title: 'Experiencia Gaming Sin Limites',
      subtitle: 'EDICION LIMITADA',
      description:
          'Pre-ordena las ultimas consolas y accesorios a precios exclusivos.',
      image:
          'assets/images/computador-pc-torre-gamer-power-l38-amd-ryzen-7-5700g-ssd-128-hdd-1tb-ram-16gb-led-22-pulgadas.webp',
      background: Color(0xFFFAF5FF),
      buttonColor: Color(0xFF7C3AED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 520,
        child: PageView.builder(
          itemCount: slides.length,
          itemBuilder: (context, index) => HeroSlide(slide: slides[index]),
        ),
      ),
    );
  }
}

class HeroSlideData {
  const HeroSlideData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.background,
    required this.buttonColor,
  });

  final String title;
  final String subtitle;
  final String description;
  final String image;
  final Color background;
  final Color buttonColor;
}

class HeroSlide extends StatelessWidget {
  const HeroSlide({super.key, required this.slide});

  final HeroSlideData slide;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: slide.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 860;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 24 : 64,
              vertical: compact ? 28 : 42,
            ),
            child: Flex(
              direction: compact ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: compact ? 0 : 1,
                  fit: compact ? FlexFit.loose : FlexFit.tight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: compact
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        slide.subtitle,
                        textAlign: compact ? TextAlign.center : TextAlign.left,
                        style: TextStyle(
                          color: slide.buttonColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        slide.title,
                        textAlign: compact ? TextAlign.center : TextAlign.left,
                        style: TextStyle(
                          fontSize: compact ? 34 : 48,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: Text(
                          slide.description,
                          textAlign: compact
                              ? TextAlign.center
                              : TextAlign.left,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                SearchPage(initialQuery: slide.title),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: slide.buttonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Compra Ahora',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 0 : 36, height: compact ? 24 : 0),
                Expanded(
                  child: Image.asset(
                    slide.image,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TrustBar extends StatelessWidget {
  const TrustBar({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      TrustItem(
        icon: Icons.local_shipping_outlined,
        title: 'Envio Gratis',
        description: 'En pedidos mayores a \$200k',
      ),
      TrustItem(
        icon: Icons.verified_user_outlined,
        title: 'Pago Seguro',
        description: '100% garantizado',
      ),
      TrustItem(
        icon: Icons.support_agent_outlined,
        title: 'Soporte 24/7',
        description: 'Estamos para ayudarte',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          return Flex(
            direction: compact ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: compact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              for (final item in items) ...[
                _TrustTile(item: item),
                if (compact && item != items.last) const SizedBox(height: 22),
              ],
            ],
          );
        },
      ),
    );
  }
}

class TrustItem {
  const TrustItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _TrustTile extends StatelessWidget {
  const _TrustTile({required this.item});

  final TrustItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 30),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w900, height: 1.2),
            ),
            const SizedBox(height: 3),
            Text(
              item.description,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
