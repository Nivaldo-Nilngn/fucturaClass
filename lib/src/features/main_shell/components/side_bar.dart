import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/views/profile_completion_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../auth/view_model/auth_view_model.dart';

import 'menu.dart';
import 'rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  Menu? selectedSideMenu;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isAdmin = authState.user?.isAdmin ?? false;
    final currentMenus = isAdmin ? sidebarMenus : userSidebarMenus;
    
    // Initialize selected menu if null or not in current list
    if (selectedSideMenu == null || !currentMenus.contains(selectedSideMenu)) {
      selectedSideMenu = currentMenus.first;
    }

    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2E), // Atualizado para a cor dark mode do Fuctura
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: SvgPicture.asset(
                  'assets/logoFuctura.svg',
                  height: 32,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              const InfoCard(),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 24, bottom: 16),
                child: Text(
                  "NAVEGAÇÃO",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...currentMenus.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu!,
                    press: () {
                      if (menu.rive != null && menu.rive!.status != null) {
                        RiveUtils.chnageSMIBoolState(menu.rive!.status!);
                      }
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        // Admin routes
                        if (menu.title == "Home") {
                          context.go(isAdmin ? '/manager/dashboard' : '/');
                        } else if (menu.title == "Cadastrar Aluno") {
                          context.go('/manager/students');
                        } else if (menu.title == "Cadastrar Professor") {
                          context.go('/manager/professors');
                        } else if (menu.title == "Cadastrar Cursos") {
                          context.go('/manager/courses');
                        } else if (menu.title == "Leilões e Premiações") {
                          context.go('/manager/desafios');
                        } 
                        // User routes
                        else if (menu.title == "Meus Dados") {
                          context.go('/my-data');
                        } else if (menu.title == "Histórico de Turmas") {
                          context.go('/class-history');
                        } else if (menu.title == "Meus Pontos") {
                          context.go('/my-points');
                        } else if (menu.title == "Avanço com a Secretaria") {
                          context.go('/secretary-progress');
                        }
                      });
                    },
                    riveOnInit: (artboard) {
                      if (menu.rive != null) {
                        menu.rive!.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive!.stateMachineName);
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "CONTA",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu!,
                    press: () {
                      if (menu.rive != null && menu.rive!.status != null) {
                        RiveUtils.chnageSMIBoolState(menu.rive!.status!);
                      }
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () async {
                        if (menu.title == "Sair") {
                          await ref.read(authViewModelProvider.notifier).logout();
                          if (context.mounted) context.go('/');
                        } else if (menu.title == "Completar Perfil") {
                          showDialog(
                            context: context,
                            builder: (context) => const ProfileCompletionView(),
                          );
                        } else if (menu.title == "Painel do Professor") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('O Modo Escuro já está ativado no Fuctura!')),
                          );
                        }
                      });
                    },
                    riveOnInit: (artboard) {
                      if (menu.rive != null) {
                        menu.rive!.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive!.stateMachineName);
                      }
                    },
                  )),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
