import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/my_data_header_widget.dart';
import '../widgets/course_progress_widget.dart';
import '../widgets/grades_chart_widget.dart';
import '../widgets/gamification_stats_widget.dart';
import '../widgets/presence_chart_widget.dart';
import '../widgets/class_history_widget.dart';

class MyDataView extends StatelessWidget {
  const MyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Maintain app background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MyDataHeaderWidget(),
            const SizedBox(height: AppSpacing.xxl),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 800) {
                  return _buildDesktopLayout(context);
                } else {
                  return _buildMobileLayout(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (7/12)
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              CourseProgressWidget(),
              SizedBox(height: AppSpacing.lg),
              GradesChartWidget(),
              SizedBox(height: AppSpacing.lg),
              ClassHistoryWidget(),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // Right Column (5/12)
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              GamificationStatsWidget(),
              SizedBox(height: AppSpacing.lg),
              PresenceChartWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        CourseProgressWidget(),
        SizedBox(height: AppSpacing.lg),
        GamificationStatsWidget(),
        SizedBox(height: AppSpacing.lg),
        PresenceChartWidget(),
        SizedBox(height: AppSpacing.lg),
        GradesChartWidget(),
        SizedBox(height: AppSpacing.lg),
        ClassHistoryWidget(),
      ],
    );
  }
}
