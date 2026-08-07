import 'package:flutter/material.dart';
import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel? rive;
  final IconData? icon;

  Menu({required this.title, this.rive, this.icon});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Home",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Cadastrar Aluno",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    title: "Cadastrar Professor",
    icon: Icons.badge_outlined, // Ícone apropriado para funcionários
  ),
  Menu(
    title: "Cadastrar Cursos",
    icon: Icons.menu_book, // Ícone de livros
  ),
  Menu(
    title: "Leilões e Premiações",
    icon: Icons.card_giftcard, // Ícone de caixas de presente
  ),
];

List<Menu> userSidebarMenus = [
  Menu(
    title: "Home",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Meus Dados",
    icon: Icons.person_outline,
  ),
  Menu(
    title: "Histórico de Turmas",
    icon: Icons.history_edu_outlined,
  ),
  Menu(
    title: "Meus Pontos",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "Avanço com a Secretaria",
    icon: Icons.admin_panel_settings_outlined,
  ),
];

List<Menu> sidebarMenus2 = [
  Menu(
    title: "Modo Escuro",
    icon: Icons.light_mode_outlined, // Ícone de sol/lua
  ),
  Menu(
    title: "Configurações",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
  Menu(
    title: "Sair",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER", // Using TIMER as placeholder for Sair
        stateMachineName: "TIMER_Interactivity"),
  ),
];

List<Menu> adminBottomNavItems = [
  Menu(
    title: "Dashboard",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Alunos",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    title: "Professores",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    title: "Cursos",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  Menu(
    title: "Desafios",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
];

List<Menu> userBottomNavItems = [
  Menu(
    title: "Início",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Exercícios",
    icon: Icons.assignment_outlined,
  ),
  Menu(
    title: "Fórum",
    icon: Icons.forum_outlined,
  ),
];

