// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Portal do Aluno Fuctura';

  @override
  String get loginWelcomeTitle => 'Bem-vindo de volta!';

  @override
  String get loginWelcomeSubtitle =>
      'Pronto para continuar sua jornada de código?';

  @override
  String get loginPortalTitle => 'Fuctura Student Portal';

  @override
  String get loginPortalDescription =>
      'Acelere sua carreira na tecnologia com nossa plataforma imersiva de aprendizado. Desafios de código, trilhas especializadas e uma comunidade vibrante de desenvolvedores.';

  @override
  String get loginFeatureChallenges => 'Desafios';

  @override
  String get loginFeatureRewards => 'Recompensas';

  @override
  String get loginFeatureCommunity => 'Comunidade';

  @override
  String get loginEmailLabel => 'Email Corporativo ou Pessoal';

  @override
  String get loginEmailHint => 'dev@exemplo.com';

  @override
  String get loginPasswordLabel => 'SENHA';

  @override
  String get loginForgotPassword => 'Esqueci minha senha';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get loginRememberMe => 'Lembrar de mim neste dispositivo';

  @override
  String get loginSubmitButton => 'Entrar no Portal';

  @override
  String get loginNewHere => 'Novo por aqui? ';

  @override
  String get loginRequestAccess => 'Solicite acesso à Academia';

  @override
  String get loginTerms => 'Termos';

  @override
  String get loginPrivacy => 'Privacidade';

  @override
  String get loginSupport => 'Suporte';

  @override
  String get loginSuccessMessage => 'Login realizado com sucesso!';

  @override
  String get loginEmailRequired => 'E-mail e senha são obrigatórios.';

  @override
  String get loginOrContinueWith => 'OU CONTINUE COM';

  @override
  String homeTitle(String name) {
    return 'Olá, $name!';
  }

  @override
  String get homeModuleProgress => 'Progresso do Módulo';

  @override
  String get homeModuleSkills => 'Competências do módulo';

  @override
  String get homeNextClass => 'Próxima aula';

  @override
  String get homePracticeNow => 'Praticar agora';

  @override
  String get homePracticeDesc => 'Exercício rápido';

  @override
  String get homeStuck => 'Estou travado';

  @override
  String get homeStuckDesc => 'Peça ajuda';

  @override
  String get homeAttention => 'Atenção';

  @override
  String get homeRecoverContent => 'Recuperar conteúdo';

  @override
  String get homeCompleted => 'concluído';

  @override
  String get navHome => 'Início';

  @override
  String get navPractice => 'Praticar';

  @override
  String get navStuck => 'Travei';

  @override
  String get navManager => 'Gestor';
}
