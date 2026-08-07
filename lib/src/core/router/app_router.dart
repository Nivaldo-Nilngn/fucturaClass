import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../features/splash/views/splash_view.dart';
import '../../features/auth/views/unified_auth_view.dart';
import '../../features/auth/view_model/auth_view_model.dart';
import '../../core/models/user_model.dart';
import '../../features/home/views/home_view.dart';
import '../../features/profile/views/profile_completion_view.dart';
import '../../features/profile/views/my_data_view.dart';
import '../../features/home/views/kids_home_view.dart';
import '../../features/main_shell/views/main_shell_view.dart';
import '../../features/main_shell/views/kids_main_shell_view.dart';
import '../../features/code_exercises/views/code_editor_view.dart';
import '../../features/support/views/stuck_view.dart';
import '../../features/manager/views/manager_view.dart';
import '../../features/manager/views/desafios_view.dart';
import '../../features/manager/views/business_rules_view.dart';
import '../../features/learning/views/class_history_view.dart';
import '../../features/gamification/views/my_points_view.dart';
import '../../features/profile/views/secretary_progress_view.dart';
import '../../features/support/views/forum_view.dart';
import '../../features/code_exercises/views/exercises_list_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _kidsShellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.matchedLocation == '/' || state.matchedLocation == '/login';
      final user = authState.user;
      final isStaff = user?.role == UserRole.admin || user?.role == UserRole.secretary;

      if (!isLoggedIn && !isLoginRoute) {
        return '/'; // Go to Splash
      }

      if (isLoggedIn && isLoginRoute) {
        if (isStaff) return '/manager/dashboard';
        if (user?.academyId == 'biblia3d') return '/kids-home';
        return '/home';
      }

      if (user != null) {
        final isManagerRoute = state.matchedLocation.startsWith('/manager');
        if (isManagerRoute && !isStaff) {
          return '/home';
        }
        if (!isManagerRoute && isStaff && state.matchedLocation != '/') {
          return '/manager/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UnifiedAuthView(),
      ),
      GoRoute(
        path: '/profile-completion',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileCompletionView(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellView(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/practice',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const CodeEditorView(),
          ),
          GoRoute(
            path: '/stuck',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const StuckView(),
          ),
          GoRoute(
            path: '/class-history',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const ClassHistoryView(),
          ),
          GoRoute(
            path: '/my-points',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const MyPointsView(),
          ),
          GoRoute(
            path: '/secretary-progress',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const SecretaryProgressView(),
          ),
          GoRoute(
            path: '/my-data',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const MyDataView(),
          ),
          GoRoute(
            path: '/forum',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const ForumView(),
          ),
          GoRoute(
            path: '/exercises',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const ExercisesListView(),
          ),
          GoRoute(
            path: '/exercises/:id',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const CodeEditorView(),
          ),
          GoRoute(
            path: '/manager',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const ManagerView(),
            routes: [
              GoRoute(
                path: 'dashboard',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const ManagerView(),
              ),
              GoRoute(
                path: 'students',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const ManagerView(),
              ),
              GoRoute(
                path: 'professors',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const ManagerView(),
              ),
              GoRoute(
                path: 'courses',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const ManagerView(),
              ),
              GoRoute(
                path: 'desafios',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const DesafiosView(),
              ),
              GoRoute(
                path: 'business-rules',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) => const BusinessRulesView(),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _kidsShellNavigatorKey,
        builder: (context, state, child) {
          return KidsMainShellView(child: child);
        },
        routes: [
          GoRoute(
            path: '/kids-home',
            parentNavigatorKey: _kidsShellNavigatorKey,
            builder: (context, state) => const KidsHomeView(),
          ),
        ],
      ),
    ],
  );
});