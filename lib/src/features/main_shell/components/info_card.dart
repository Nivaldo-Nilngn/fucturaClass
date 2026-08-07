import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/view_model/auth_view_model.dart';
import '../../../core/models/user_model.dart';

class InfoCard extends ConsumerWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final nameParts = user.name.split(' ');
    final initials = nameParts.length > 1
        ? '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase()
        : nameParts[0][0].toUpperCase();

    final roleText = user.isAdmin
        ? 'Administrador'
        : user.isProfessor
            ? 'Professor'
            : user.isSecretary
                ? 'Secretaria'
                : 'Aluno';

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF5D5FEF), // Fuctura Brand Purple/Blue
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user.email ?? roleText,
        style: const TextStyle(color: Colors.white70),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
