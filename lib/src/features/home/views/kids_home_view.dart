import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/core/models/learning_model.dart';
import 'package:fuctura_lms_app/src/core/models/gamification_model.dart';
import '../../learning/views/my_classes_view.dart';
import '../../learning/views/do_exercise_view.dart';
import '../../gamification/views/student_auction_view.dart';
import '../../gamification/views/leaderboard_view.dart';

class KidsHomeView extends StatelessWidget {
  const KidsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient Background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Color(0xFFFFDEA8),
                  Color(0x00FFDEA8),
                ],
                stops: [0.0, 0.7],
              ),
            ),
          ),
        ),
        
        Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeHeader(),
                    const SizedBox(height: AppSpacing.xxl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 800;
                        if (isDesktop) {
                          return _buildDesktopBentoGrid(context);
                        }
                        return _buildMobileBentoGrid(context);
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title (Visible on desktop)
          Row(
            children: [
              // Show logo on mobile where sidebar is hidden
              if (MediaQuery.of(context).size.width < 800)
                Image.asset('assets/biblia3d.png', height: 32, fit: BoxFit.contain),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Fuctura Kids',
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7C5800),
                ),
              ),
            ],
          ),
          
          // Right Controls
          Row(
            children: [
              // Search Bar (Desktop)
              if (MediaQuery.of(context).size.width > 800)
                Container(
                  width: 200,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD5C4AB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF514532), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search...',
                            hintStyle: GoogleFonts.nunitoSans(color: const Color(0xFF514532)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: AppSpacing.md),
              
              // Notifications
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.gavel_rounded, color: Color(0xFF7C5800)),
                    onPressed: () {
                      final mockAuction = Auction(
                        id: 'mock_auc', academyId: 'academy',
                        product: 'Teclado Gamer Razer', description: 'Teclado mecânico RGB.',
                        photoUrl: 'https://images.unsplash.com/photo-1595225476474-87563907a212?w=500',
                        startingBid: 250, startsAt: DateTime.now(), endsAt: DateTime.now().add(const Duration(days: 2)),
                      );
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => StudentAuctionView(auction: mockAuction, studentCoins: 1200),
                      ));
                    },
                    tooltip: 'Leilões Abertos',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.emoji_events_rounded, color: Color(0xFF7C5800)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const LeaderboardView(classId: 'mock_class_id'),
                      ));
                    },
                    tooltip: 'Ranking Fuctura',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Color(0xFF7C5800)),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCD2121),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Settings
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Color(0xFF7C5800)),
                onPressed: () {},
              ),
              const SizedBox(width: AppSpacing.sm),
              
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF7C5800), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDfiN1Ot17u7rGW3Ai32bfXpEa3cmGBBNJP32mK_Ymg2A-kLFXbEDwRwdB1B9q9EC1kShyqNy019UYDCNQYVmNmufISbNA2klxejs5oeiNkRwFYWStA8G9gLB7kd7sIwuOheH-Z50HRT07lMTTQIVXMokK0c6aouQ7E_2bW87apvf3SRKIsm4v3K8sssnko2RBIYn9d7CyQa47uaIpJ5DvQ1kUDSkXFaH08G1KmLLWdGnoRe0JyPuS1'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: AppSpacing.md,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Explorer!',
              style: GoogleFonts.nunitoSans(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1C1C),
              ),
            ),
            Text(
              'Ready for your next big adventure?',
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                color: const Color(0xFF514532),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatChip(Icons.star_rounded, '1,240 XP', const Color(0xFFFE6B00)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip(Icons.local_fire_department_rounded, '5 Day Streak', const Color(0xFFCD2121)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD5C4AB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF7C5800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopBentoGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 8, child: _buildHeroMissionCard(context)),
            const SizedBox(width: AppSpacing.xl),
            Expanded(flex: 4, child: _buildNextLessonCard(context)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: _buildAchievementsCard()),
            const SizedBox(width: AppSpacing.xl),
            Expanded(flex: 7, child: _buildFriendsCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileBentoGrid(BuildContext context) {
    return Column(
      children: [
        _buildHeroMissionCard(context),
        const SizedBox(height: AppSpacing.xl),
        _buildNextLessonCard(context),
        const SizedBox(height: AppSpacing.xl),
        _buildAchievementsCard(),
        const SizedBox(height: AppSpacing.xl),
        _buildFriendsCard(),
      ],
    );
  }

  Widget _buildHeroMissionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDBCC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFB693)),
                ),
                child: Text(
                  'Current Mission',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: const Color(0xFF351000),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'The Code\nCrystal Cave',
                style: GoogleFonts.nunitoSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: const Color(0xFF7C5800),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: 300,
                child: Text(
                  'Navigate through the logical loops to find the hidden crystal. Watch out for bugs!',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: const Color(0xFF514532),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Progress
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('65%', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 65,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFFE6B00), Color(0xFFFFD600)]),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const Expanded(flex: 35, child: SizedBox()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Button
              ElevatedButton.icon(
                onPressed: () {
                  // MOCK CHALLENGE para testes de UI
                  final mockChallenge = Challenge(
                    id: 'mock', code: 'mock', professorId: 'prof', classId: 'class', 
                    title: 'The Code Crystal Cave', description: 'Navigate through the logical loops.', 
                    points: 200, startsAt: DateTime.now(), endsAt: DateTime.now().add(const Duration(days: 7))
                  );
                  final mockQuestion = Question(
                    id: 'mockQ', category: 'Logic', type: QuestionType.multipleChoice, difficulty: QuestionDifficulty.medium,
                    text: 'Qual estrutura de repetição é garantida que rodará pelo menos 1 vez antes de testar a condição?',
                    options: ['for', 'while', 'do-while', 'foreach'],
                    correctAnswer: 'do-while', professorId: 'prof', createdAt: DateTime.now()
                  );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoExerciseView(challenge: mockChallenge, question: mockQuestion),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                icon: const Icon(Icons.play_arrow_rounded, color: Color(0xFF6B4C00)),
                label: Text(
                  'Continue Playing',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFF6B4C00),
                  ),
                ),
              ),
            ],
          ),
          
          // Image positioned on the right
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB8m51nlWVON3vGbGUMRble1a2JQn2WIUV_Df22VdNF63rbess6ZzWaQLlH-6LFtvHQe4N_n_DSw3Z_SBDCBWDh4TkVfoIy4CeXPA8JOKNYSQFuL5cNKpYsOjQmsqmMWCQukR8FFLveEYvF2ae-sFueg2r9kPoIcLh2Zr9Jwh2zZByrqKbUY3L3SdnPVewZN2s3NeEpJS6m_V593Vx08MuMPZeyyUiW3FA65c4ojJrRFjL5VHyeZqnlL9C7lTznrzNy0w',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.auto_awesome, size: 100, color: Colors.amber),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextLessonCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: const Icon(Icons.extension_rounded, size: 50, color: Color(0xFF4059AA)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Next Lesson',
            style: GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1C)),
          ),
          Text(
            'Variables',
            style: GoogleFonts.nunitoSans(fontSize: 32, fontWeight: FontWeight.w800, color: const Color(0xFF7C5800)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Learn how to store magic spells in memory boxes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(fontSize: 16, color: const Color(0xFF514532)),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Passamos um ID falso/fixo só para mostrar a tela
                    builder: (_) => const MyClassesView(classId: 'mock_class_id'),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFFB800), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Preview Lesson',
                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, color: const Color(0xFF7C5800)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFD5C4AB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Badges', style: GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.w700)),
              Text('View All', style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFFE6B00))),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge(Icons.speed_rounded, 'Fast Learner', const Color(0xFF7C5800), const Color(0xFFFFDEA8)),
              _buildBadge(Icons.bug_report_rounded, 'Bug Squasher', const Color(0xFFA04100), const Color(0xFFFFDBCC)),
              _buildBadge(Icons.psychology_rounded, 'Logic Master', const Color(0xFF4059AA), const Color(0xFFDCE1FF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color iconColor, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: iconColor.withOpacity(0.2)),
          ),
          child: Icon(icon, color: iconColor, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label.replaceFirst(' ', '\n'),
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(fontSize: 12, color: const Color(0xFF514532)),
        ),
      ],
    );
  }

  Widget _buildFriendsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFD5C4AB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Adventure Buddies', style: GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.w700)),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFriendItem(
            'Mia Codes',
            'Level 12',
            'Playing Now',
            const Color(0xFF4CAF50),
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBF5jQP2kxFUcBOTblucPU961OFU8DN2iwY-hOqgSToj5PH9W5llnFkJg_g97CPcjOEoP7gJjobcXFSu8J3WO0Y6tc3RoNZmRdxbum1ELSXAamU2ohBmjPxbAZEeuNeSZHLjnGTgo1o2mtJd5LamIogSR00WdOyP6gZdm5RjameRaTQjsk5vj3_nNXmXkFrzLz5SUQotaGLNTu9jSomgtDwsRv5ND91qus6EZA6nh9fRkbzj1c2WAzl',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFriendItem(
            'Leo_Bot',
            'Level 9',
            '2h ago',
            const Color(0xFF9E9E9E),
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAObkr12PRc-oa-1OeM6bGDU8MOAeVVAUBXI4sGGuVBVVlNrTO0_aZlI6QW3ZN8s4dCzNNK8za4zVnbuBmqZWOZDDLQNw1jjxyc19ijhVqrOIQuj7OfzLoARmGrHoLAWuqzXRObuRuzNg4TSr6IdtS64z6NuDWJkKFRzqbqKcYVa2IiEi8jojFS6ESVkWvuCzE4RNhF-h3Tl_mhQbW5eOsdAk8ztRp7MrH0kRv1wj2eMD8azolTtxuO',
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(String name, String level, String status, Color statusColor, String avatarUrl) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(name, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700)),
      subtitle: Text(level, style: GoogleFonts.nunitoSans(fontSize: 14)),
      trailing: Text(status, style: GoogleFonts.nunitoSans(color: status == 'Playing Now' ? const Color(0xFF7C5800) : Colors.grey, fontWeight: FontWeight.w700)),
    );
  }
}
