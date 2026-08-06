import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../models/home_state.dart';

class DesktopHeaderWidget extends ConsumerWidget {
  final HomeState state;
  final String? title;

  const DesktopHeaderWidget({super.key, required this.state, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: bento.outlineVariant.withOpacity(0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: title != null
                  ? Text(
                      title!,
                      style: GoogleFonts.hankenGrotesk(
                        color: bento.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: bento.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppSpacing.md),
                          Icon(
                            Icons.search,
                            color: bento.onSurfaceVariant.withOpacity(0.6),
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Search courses, docs, community...',
                              style: GoogleFonts.inter(
                                color: bento.onSurfaceVariant.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.lg),
            _NotificationIcon(color: bento.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.emoji_events_outlined,
                color: bento.onSurfaceVariant,
                size: 22,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 1,
              height: 32,
              color: bento.outlineVariant.withOpacity(0.5),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state.fullName,
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  state.badge2,
                  style: GoogleFonts.jetBrainsMono(
                    color: bento.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: const Color(0xFF243447),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 48),
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authViewModelProvider.notifier).logout();
                    context.go('/');
                  } else if (value == 'config') {
                    context.go('/profile-completion');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'config',
                    child: Row(
                      children: [
                        const Icon(Icons.settings, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        const Text('Configurações'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        const Text('Sair', style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
                child: _UserAvatar(
                  initials: state.initials,
                  bento: bento,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final Color color;

  const _NotificationIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_outlined, color: color, size: 22),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String initials;
  final BentoColors bento;

  const _UserAvatar({
    required this.initials,
    required this.bento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: bento.primary,
          width: 2.5,
        ),
      ),
      padding: const EdgeInsets.all(2.5),
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            color: bento.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}