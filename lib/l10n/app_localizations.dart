import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuctura Student Portal'**
  String get appTitle;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to continue your coding journey?'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuctura Student Portal'**
  String get loginPortalTitle;

  /// No description provided for @loginPortalDescription.
  ///
  /// In en, this message translates to:
  /// **'Accelerate your tech career with our immersive learning platform. Coding challenges, specialized tracks, and a vibrant community of developers.'**
  String get loginPortalDescription;

  /// No description provided for @loginFeatureChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get loginFeatureChallenges;

  /// No description provided for @loginFeatureRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get loginFeatureRewards;

  /// No description provided for @loginFeatureCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get loginFeatureCommunity;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Corporate or Personal Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'dev@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get loginPasswordLabel;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot my password'**
  String get loginForgotPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get loginPasswordHint;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me on this device'**
  String get loginRememberMe;

  /// No description provided for @loginSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Enter Portal'**
  String get loginSubmitButton;

  /// No description provided for @loginNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here? '**
  String get loginNewHere;

  /// No description provided for @loginRequestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Academy access'**
  String get loginRequestAccess;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get loginTerms;

  /// No description provided for @loginPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get loginPrivacy;

  /// No description provided for @loginSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get loginSupport;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessMessage;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get loginEmailRequired;

  /// No description provided for @loginOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get loginOrContinueWith;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeTitle(String name);

  /// No description provided for @homeModuleProgress.
  ///
  /// In en, this message translates to:
  /// **'Module Progress'**
  String get homeModuleProgress;

  /// No description provided for @homeModuleSkills.
  ///
  /// In en, this message translates to:
  /// **'Module Skills'**
  String get homeModuleSkills;

  /// No description provided for @homeNextClass.
  ///
  /// In en, this message translates to:
  /// **'Next Class'**
  String get homeNextClass;

  /// No description provided for @homePracticeNow.
  ///
  /// In en, this message translates to:
  /// **'Practice Now'**
  String get homePracticeNow;

  /// No description provided for @homePracticeDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick exercise'**
  String get homePracticeDesc;

  /// No description provided for @homeStuck.
  ///
  /// In en, this message translates to:
  /// **'I\'m stuck'**
  String get homeStuck;

  /// No description provided for @homeStuckDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask for help'**
  String get homeStuckDesc;

  /// No description provided for @homeAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get homeAttention;

  /// No description provided for @homeRecoverContent.
  ///
  /// In en, this message translates to:
  /// **'Recover content'**
  String get homeRecoverContent;

  /// No description provided for @homeCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get homeCompleted;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navStuck.
  ///
  /// In en, this message translates to:
  /// **'Stuck'**
  String get navStuck;

  /// No description provided for @navManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get navManager;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
