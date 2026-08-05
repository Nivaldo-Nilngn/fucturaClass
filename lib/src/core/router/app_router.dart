import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/view_model/auth_view_model.dart';
import '../../features/home/views/home_view.dart';
import '../../features/main_shell/views/main_shell_view.dart';
import '../../features/code_exercises/views/code_editor_view.dart';
import '../../features/support/views/stuck_view.dart';
import '../../features/manager/views/manager_view.dart';
import '../../features/manager/views/desafios_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.matchedLocation == '/';
      final user = authState.user;
      final isAdmin = user?.isAdmin == true;

      if (!isLoggedIn && !isLoginRoute) {
        return '/';
      }

      if (isLoggedIn && isLoginRoute) {
        return isAdmin ? '/manager/dashboard' : '/home';
      }

      if (user != null) {
        final isManagerRoute = state.matchedLocation.startsWith('/manager');
        if (isManagerRoute && !isAdmin) {
          return '/home';
        }
        if (!isManagerRoute && isAdmin && state.matchedLocation != '/') {
          return '/manager/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginView(),
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
            ],
          ),
        ],
      ),
    ],
  );
});