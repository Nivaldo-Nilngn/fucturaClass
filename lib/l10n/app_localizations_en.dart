// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fuctura Student Portal';

  @override
  String get loginWelcomeTitle => 'Welcome back!';

  @override
  String get loginWelcomeSubtitle => 'Ready to continue your coding journey?';

  @override
  String get loginPortalTitle => 'Fuctura Student Portal';

  @override
  String get loginPortalDescription =>
      'Accelerate your tech career with our immersive learning platform. Coding challenges, specialized tracks, and a vibrant community of developers.';

  @override
  String get loginFeatureChallenges => 'Challenges';

  @override
  String get loginFeatureRewards => 'Rewards';

  @override
  String get loginFeatureCommunity => 'Community';

  @override
  String get loginEmailLabel => 'Corporate or Personal Email';

  @override
  String get loginEmailHint => 'dev@example.com';

  @override
  String get loginPasswordLabel => 'PASSWORD';

  @override
  String get loginForgotPassword => 'Forgot my password';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get loginRememberMe => 'Remember me on this device';

  @override
  String get loginSubmitButton => 'Enter Portal';

  @override
  String get loginNewHere => 'New here? ';

  @override
  String get loginRequestAccess => 'Request Academy access';

  @override
  String get loginTerms => 'Terms';

  @override
  String get loginPrivacy => 'Privacy';

  @override
  String get loginSupport => 'Support';

  @override
  String get loginSuccessMessage => 'Login successful!';

  @override
  String get loginEmailRequired => 'Email and password are required.';

  @override
  String get loginOrContinueWith => 'OR CONTINUE WITH';

  @override
  String homeTitle(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeModuleProgress => 'Module Progress';

  @override
  String get homeModuleSkills => 'Module Skills';

  @override
  String get homeNextClass => 'Next Class';

  @override
  String get homePracticeNow => 'Practice Now';

  @override
  String get homePracticeDesc => 'Quick exercise';

  @override
  String get homeStuck => 'I\'m stuck';

  @override
  String get homeStuckDesc => 'Ask for help';

  @override
  String get homeAttention => 'Attention';

  @override
  String get homeRecoverContent => 'Recover content';

  @override
  String get homeCompleted => 'completed';

  @override
  String get navHome => 'Home';

  @override
  String get navPractice => 'Practice';

  @override
  String get navStuck => 'Stuck';

  @override
  String get navManager => 'Manager';
}
