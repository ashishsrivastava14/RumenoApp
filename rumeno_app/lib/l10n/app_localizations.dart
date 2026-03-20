import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('hi'),
  ];

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Generic Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Generic Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Generic Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Generic Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Generic Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// Generic View button
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// Generic Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// Generic Search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// Confirmation button in info dialogs
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get commonGotIt;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// Default action text in SectionHeader widget
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// Free shipping / free price label
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get commonFree;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get commonTomorrow;

  /// No description provided for @commonMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get commonMale;

  /// No description provided for @commonFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get commonFemale;

  /// Filter chip – show all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// Default hint text for SearchBarWidget
  ///
  /// In en, this message translates to:
  /// **'Search here...'**
  String get commonSearchHint;

  /// No description provided for @commonChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get commonChooseFromGallery;

  /// No description provided for @commonChooseFromGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an existing photo'**
  String get commonChooseFromGallerySubtitle;

  /// No description provided for @commonTakeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get commonTakeAPhoto;

  /// No description provided for @commonTakeAPhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your camera'**
  String get commonTakeAPhotoSubtitle;

  /// Bottom sheet title when choosing camera vs gallery
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get commonSelectSource;

  /// Camera option in source picker
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get commonTakePhotoOption;

  /// No description provided for @commonTakePhotoOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture with camera'**
  String get commonTakePhotoOptionSubtitle;

  /// No description provided for @commonChooseFromGalleryOption.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get commonChooseFromGalleryOption;

  /// No description provided for @commonChooseFromGalleryOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an existing image'**
  String get commonChooseFromGalleryOptionSubtitle;

  /// Option to mark as given today (vaccination / deworming)
  ///
  /// In en, this message translates to:
  /// **'✅  Given Today'**
  String get commonGivenToday;

  /// Option to schedule for a later date
  ///
  /// In en, this message translates to:
  /// **'📅  Schedule Later'**
  String get commonScheduleLater;

  /// Hint text used in health/breeding forms
  ///
  /// In en, this message translates to:
  /// **'🐄  Animal ID (e.g. C-001)'**
  String get commonAnimalIdHint;

  /// No description provided for @commonVetNameOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'👨‍⚕️  Vet Name (optional)'**
  String get commonVetNameOptionalHint;

  /// Primary save button in health record forms
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get commonSaveRecord;

  /// No description provided for @commonDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get commonDateOfBirth;

  /// No description provided for @commonAnimalId.
  ///
  /// In en, this message translates to:
  /// **'Animal ID'**
  String get commonAnimalId;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonNotesOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'📝  Notes (optional)'**
  String get commonNotesOptionalHint;

  /// No description provided for @speciesCow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get speciesCow;

  /// No description provided for @speciesBuffalo.
  ///
  /// In en, this message translates to:
  /// **'Buffalo'**
  String get speciesBuffalo;

  /// No description provided for @speciesGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get speciesGoat;

  /// No description provided for @speciesSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get speciesSheep;

  /// No description provided for @speciesPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get speciesPig;

  /// No description provided for @speciesHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get speciesHorse;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @ageRangeUnder1Month.
  ///
  /// In en, this message translates to:
  /// **'Under 1 month'**
  String get ageRangeUnder1Month;

  /// No description provided for @ageRange1To3Months.
  ///
  /// In en, this message translates to:
  /// **'1 – 3 months'**
  String get ageRange1To3Months;

  /// No description provided for @ageRange3To6Months.
  ///
  /// In en, this message translates to:
  /// **'3 – 6 months'**
  String get ageRange3To6Months;

  /// No description provided for @ageRange6To9Months.
  ///
  /// In en, this message translates to:
  /// **'6 – 9 months'**
  String get ageRange6To9Months;

  /// No description provided for @ageRange9To12Months.
  ///
  /// In en, this message translates to:
  /// **'9 – 12 months'**
  String get ageRange9To12Months;

  /// No description provided for @ageRange12To18Months.
  ///
  /// In en, this message translates to:
  /// **'12 – 18 months'**
  String get ageRange12To18Months;

  /// No description provided for @ageRange18To24Months.
  ///
  /// In en, this message translates to:
  /// **'18 – 24 months'**
  String get ageRange18To24Months;

  /// No description provided for @ageRange24PlusMonths.
  ///
  /// In en, this message translates to:
  /// **'24+ months'**
  String get ageRange24PlusMonths;

  /// Heading on the role selection screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rumeno'**
  String get authWelcomeToRumeno;

  /// No description provided for @authSelectRolePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select your role to get started'**
  String get authSelectRolePrompt;

  /// No description provided for @authRoleFarmOwner.
  ///
  /// In en, this message translates to:
  /// **'Farm Owner / Staff'**
  String get authRoleFarmOwner;

  /// No description provided for @authRoleFarmOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your farm, animals, and operations'**
  String get authRoleFarmOwnerSubtitle;

  /// No description provided for @authRoleVet.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian / Partner'**
  String get authRoleVet;

  /// No description provided for @authRoleVetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage consultations and earn commissions'**
  String get authRoleVetSubtitle;

  /// No description provided for @authRoleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get authRoleSuperAdmin;

  /// No description provided for @authRoleSuperAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage platform, users, and configurations'**
  String get authRoleSuperAdminSubtitle;

  /// No description provided for @authRoleFarmProducts.
  ///
  /// In en, this message translates to:
  /// **'Farm Products'**
  String get authRoleFarmProducts;

  /// No description provided for @authRoleFarmProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse and purchase farm products'**
  String get authRoleFarmProductsSubtitle;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginEnterPhonePrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get loginEnterPhonePrompt;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhonePrefix.
  ///
  /// In en, this message translates to:
  /// **'+91 '**
  String get loginPhonePrefix;

  /// No description provided for @loginSendOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get loginSendOtpButton;

  /// No description provided for @loginEnterOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get loginEnterOtpButton;

  /// Dev mock snackbar – shows sent OTP
  ///
  /// In en, this message translates to:
  /// **'OTP sent: 1234 (mock)'**
  String get loginOtpSentSnackbar;

  /// No description provided for @loginOtpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to +91 {phone}'**
  String loginOtpPrompt(String phone);

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to your phone'**
  String get otpSubtitle;

  /// No description provided for @otpResendTimer.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {seconds}s'**
  String otpResendTimer(int seconds);

  /// No description provided for @otpResendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get otpResendButton;

  /// No description provided for @otpVerifyLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Verify & Login'**
  String get otpVerifyLoginButton;

  /// Dev-only label showing mock OTP
  ///
  /// In en, this message translates to:
  /// **'Mock OTP: 1234'**
  String get otpMockLabel;

  /// No description provided for @otpInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Use 1234'**
  String get otpInvalidError;

  /// No description provided for @otpResendSnackbar.
  ///
  /// In en, this message translates to:
  /// **'OTP resent: 1234 (mock)'**
  String get otpResendSnackbar;

  /// Tooltip for VeterinarianButton in app bar
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get headerBtnVetTooltip;

  /// No description provided for @headerBtnVetInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get headerBtnVetInfoTitle;

  /// No description provided for @headerBtnVetInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the icon to connect with licensed veterinarians to book appointments, request farm visits, and get expert advice on your animals\' health and treatments.'**
  String get headerBtnVetInfoBody;

  /// No description provided for @headerBtnMarketplaceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get headerBtnMarketplaceTooltip;

  /// No description provided for @headerBtnMarketplaceInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get headerBtnMarketplaceInfoTitle;

  /// No description provided for @headerBtnMarketplaceInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the icon to browse and purchase farm supplies, animal feed, medicines, and equipment. Sell your farm produce directly to buyers through the Rumeno marketplace.'**
  String get headerBtnMarketplaceInfoBody;

  /// No description provided for @headerBtnFarmTooltip.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get headerBtnFarmTooltip;

  /// No description provided for @headerBtnFarmInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Dashboard'**
  String get headerBtnFarmInfoTitle;

  /// No description provided for @headerBtnFarmInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the icon to access your Farm Management Dashboard — the central hub for all your farming activities. Manage your livestock, track individual animal health records, monitor daily milk production, schedule feeding routines, and get a complete overview of all your farm operations in one place.'**
  String get headerBtnFarmInfoBody;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get dashboardGreetingEvening;

  /// Placeholder text on farm logo circle
  ///
  /// In en, this message translates to:
  /// **'Add Farm Logo'**
  String get dashboardAddFarmLogo;

  /// Bottom sheet title for logo picker
  ///
  /// In en, this message translates to:
  /// **'Set Farm Logo'**
  String get dashboardSetFarmLogoTitle;

  /// No description provided for @dashboardActiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'Active Alerts'**
  String get dashboardActiveAlerts;

  /// No description provided for @dashboardUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get dashboardUpcomingEvents;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @morePlanPro.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get morePlanPro;

  /// No description provided for @moreMyFarm.
  ///
  /// In en, this message translates to:
  /// **'My Farm'**
  String get moreMyFarm;

  /// No description provided for @moreMyFarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Details'**
  String get moreMyFarmSubtitle;

  /// No description provided for @moreMyTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get moreMyTeam;

  /// No description provided for @moreMyTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get moreMyTeamSubtitle;

  /// No description provided for @moreMyPlan.
  ///
  /// In en, this message translates to:
  /// **'My Plan'**
  String get moreMyPlan;

  /// No description provided for @moreMyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get moreMyPlanSubtitle;

  /// No description provided for @moreAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get moreAlerts;

  /// No description provided for @moreAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get moreAlertsSubtitle;

  /// No description provided for @moreLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get moreLanguage;

  /// Subtitle always shown in Hindi to help users find the language switcher
  ///
  /// In en, this message translates to:
  /// **'भाषा बदलें'**
  String get moreLanguageSubtitle;

  /// No description provided for @moreExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get moreExport;

  /// No description provided for @moreExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save Data'**
  String get moreExportSubtitle;

  /// No description provided for @moreSanitization.
  ///
  /// In en, this message translates to:
  /// **'Sanitization'**
  String get moreSanitization;

  /// No description provided for @moreSanitizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Cleaning'**
  String get moreSanitizationSubtitle;

  /// No description provided for @moreHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get moreHelp;

  /// No description provided for @moreHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get moreHelpSubtitle;

  /// No description provided for @moreLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get moreLogout;

  /// No description provided for @moreLogoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get moreLogoutSubtitle;

  /// No description provided for @moreVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get moreVersion;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get logoutDialogMessage;

  /// No description provided for @logoutDialogStay.
  ///
  /// In en, this message translates to:
  /// **'No, Stay'**
  String get logoutDialogStay;

  /// No description provided for @logoutDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Logout'**
  String get logoutDialogConfirm;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Hindi language option – keep as-is
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportTitle;

  /// No description provided for @exportBannerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Save Your Farm Data'**
  String get exportBannerHeadline;

  /// No description provided for @exportBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select what you want to download'**
  String get exportBannerSubtitle;

  /// No description provided for @exportTabFarmData.
  ///
  /// In en, this message translates to:
  /// **'Farm Data'**
  String get exportTabFarmData;

  /// No description provided for @exportTabSellAnimal.
  ///
  /// In en, this message translates to:
  /// **'Sell Animal'**
  String get exportTabSellAnimal;

  /// No description provided for @exportCategoryAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get exportCategoryAnimals;

  /// No description provided for @exportCategoryAnimalsDesc.
  ///
  /// In en, this message translates to:
  /// **'All animal records'**
  String get exportCategoryAnimalsDesc;

  /// No description provided for @exportCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get exportCategoryHealth;

  /// No description provided for @exportCategoryHealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Vaccination, Treatment\nDeworming & Lab Reports'**
  String get exportCategoryHealthDesc;

  /// No description provided for @exportCategoryBreeding.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get exportCategoryBreeding;

  /// No description provided for @exportCategoryBreedingDesc.
  ///
  /// In en, this message translates to:
  /// **'Breeding records'**
  String get exportCategoryBreedingDesc;

  /// No description provided for @exportCategoryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get exportCategoryFinance;

  /// No description provided for @exportCategoryFinanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Income & expenses'**
  String get exportCategoryFinanceDesc;

  /// No description provided for @exportCategoryMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk Records'**
  String get exportCategoryMilk;

  /// No description provided for @exportCategoryMilkDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily milk data'**
  String get exportCategoryMilkDesc;

  /// No description provided for @exportCategoryTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get exportCategoryTeam;

  /// No description provided for @exportCategoryTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Team members list'**
  String get exportCategoryTeamDesc;

  /// No description provided for @exportRecordTypeCastration.
  ///
  /// In en, this message translates to:
  /// **'Castration'**
  String get exportRecordTypeCastration;

  /// No description provided for @exportRecordTypeMortality.
  ///
  /// In en, this message translates to:
  /// **'Mortality'**
  String get exportRecordTypeMortality;

  /// No description provided for @exportRecordTypeSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get exportRecordTypeSell;

  /// No description provided for @exportSectionDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get exportSectionDateRange;

  /// No description provided for @exportSectionFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get exportSectionFilters;

  /// No description provided for @exportFiltersHint.
  ///
  /// In en, this message translates to:
  /// **'👆 Tap to select filters. Leave empty = export all'**
  String get exportFiltersHint;

  /// No description provided for @exportDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Date Selected'**
  String get exportDateSelected;

  /// No description provided for @exportSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get exportSelectDateRange;

  /// Button disabled state - no data category chosen
  ///
  /// In en, this message translates to:
  /// **'Select Data First'**
  String get exportSelectDataFirst;

  /// No description provided for @exportDownloadButton.
  ///
  /// In en, this message translates to:
  /// **'Download {count} item(s)'**
  String exportDownloadButton(int count);

  /// No description provided for @animalListTitle.
  ///
  /// In en, this message translates to:
  /// **'My Animals'**
  String get animalListTitle;

  /// No description provided for @animalListSortByTag.
  ///
  /// In en, this message translates to:
  /// **'Sort by Tag'**
  String get animalListSortByTag;

  /// No description provided for @animalListSortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get animalListSortByName;

  /// No description provided for @animalListSortByAge.
  ///
  /// In en, this message translates to:
  /// **'Sort by Age'**
  String get animalListSortByAge;

  /// No description provided for @animalListSortByStatus.
  ///
  /// In en, this message translates to:
  /// **'Sort by Status'**
  String get animalListSortByStatus;

  /// No description provided for @animalListSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by tag or breed...'**
  String get animalListSearchHint;

  /// Clear all active species/age filters
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get animalListClearAll;

  /// No description provided for @animalListKidBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Kid Management'**
  String get animalListKidBannerTitle;

  /// No description provided for @animalListKidBannerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} kid(s) registered'**
  String animalListKidBannerCount(int count);

  /// No description provided for @animalListKidBannerNeedMedicine.
  ///
  /// In en, this message translates to:
  /// **'⚠️ {count} need medicine'**
  String animalListKidBannerNeedMedicine(int count);

  /// No description provided for @animalListKidBannerViewButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get animalListKidBannerViewButton;

  /// No description provided for @animalListCount.
  ///
  /// In en, this message translates to:
  /// **'{count} animals'**
  String animalListCount(int count);

  /// No description provided for @animalListAddFab.
  ///
  /// In en, this message translates to:
  /// **'Add Animal'**
  String get animalListAddFab;

  /// No description provided for @addAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Animal'**
  String get addAnimalTitle;

  /// No description provided for @addAnimalStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Which Animal?'**
  String get addAnimalStep1Title;

  /// No description provided for @addAnimalStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Type & basic info'**
  String get addAnimalStep1Subtitle;

  /// No description provided for @addAnimalStep2Title.
  ///
  /// In en, this message translates to:
  /// **'How it looks?'**
  String get addAnimalStep2Title;

  /// No description provided for @addAnimalStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Size & color'**
  String get addAnimalStep2Subtitle;

  /// No description provided for @addAnimalStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get addAnimalStep3Title;

  /// No description provided for @addAnimalStep3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Parents (optional)'**
  String get addAnimalStep3Subtitle;

  /// No description provided for @addAnimalStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Where it lives?'**
  String get addAnimalStep4Title;

  /// No description provided for @addAnimalStep4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Shed & purpose'**
  String get addAnimalStep4Subtitle;

  /// No description provided for @addAnimalStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get addAnimalStep5Title;

  /// No description provided for @addAnimalStep5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get addAnimalStep5Subtitle;

  /// No description provided for @addAnimalTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'🐄  Type of Animal'**
  String get addAnimalTypeLabel;

  /// No description provided for @addAnimalGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'⚥  Gender'**
  String get addAnimalGenderLabel;

  /// No description provided for @addAnimalBreedLabel.
  ///
  /// In en, this message translates to:
  /// **'🌱  Breed'**
  String get addAnimalBreedLabel;

  /// No description provided for @addAnimalDobLabel.
  ///
  /// In en, this message translates to:
  /// **'🎂  Date of Birth'**
  String get addAnimalDobLabel;

  /// No description provided for @addAnimalTagLabel.
  ///
  /// In en, this message translates to:
  /// **'🏷️  Tag ID'**
  String get addAnimalTagLabel;

  /// No description provided for @addAnimalBreedHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Holstein, Gir, Murrah…'**
  String get addAnimalBreedHint;

  /// No description provided for @addAnimalAutoGenerateTag.
  ///
  /// In en, this message translates to:
  /// **'Auto-generate Tag ID'**
  String get addAnimalAutoGenerateTag;

  /// No description provided for @addAnimalAutoGenerateTagSubtitle.
  ///
  /// In en, this message translates to:
  /// **'System assigns a unique number'**
  String get addAnimalAutoGenerateTagSubtitle;

  /// No description provided for @addAnimalCustomTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Tag ID'**
  String get addAnimalCustomTagLabel;

  /// No description provided for @addAnimalCustomTagHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. C-010'**
  String get addAnimalCustomTagHint;

  /// No description provided for @addAnimalStep2Header.
  ///
  /// In en, this message translates to:
  /// **'How does it look?'**
  String get addAnimalStep2Header;

  /// No description provided for @addAnimalStep2HeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Size, weight and appearance'**
  String get addAnimalStep2HeaderSubtitle;

  /// No description provided for @addAnimalWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'⚖️  Weight'**
  String get addAnimalWeightLabel;

  /// No description provided for @addAnimalHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'📏  Height'**
  String get addAnimalHeightLabel;

  /// No description provided for @addAnimalColorLabel.
  ///
  /// In en, this message translates to:
  /// **'🎨  Color / Markings'**
  String get addAnimalColorLabel;

  /// No description provided for @addAnimalPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'📸  Animal Photo'**
  String get addAnimalPhotoLabel;

  /// No description provided for @addAnimalWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get addAnimalWeightUnit;

  /// No description provided for @addAnimalHeightUnit.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get addAnimalHeightUnit;

  /// No description provided for @addAnimalMeasureRange.
  ///
  /// In en, this message translates to:
  /// **'Min: {min} – Max: {max} {unit}'**
  String addAnimalMeasureRange(int min, int max, String unit);

  /// No description provided for @animalDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Animal Not Found'**
  String get animalDetailNotFound;

  /// No description provided for @animalDetailTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get animalDetailTabOverview;

  /// No description provided for @animalDetailTabHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get animalDetailTabHealth;

  /// No description provided for @animalDetailTabVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get animalDetailTabVaccination;

  /// No description provided for @animalDetailTabBreeding.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get animalDetailTabBreeding;

  /// No description provided for @animalDetailTabReproduction.
  ///
  /// In en, this message translates to:
  /// **'Reproduction'**
  String get animalDetailTabReproduction;

  /// No description provided for @animalDetailTabProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get animalDetailTabProduction;

  /// No description provided for @animalDetailTabFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get animalDetailTabFinance;

  /// No description provided for @animalDetailTabFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get animalDetailTabFamily;

  /// No description provided for @animalDetailRecordDeathTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Death'**
  String get animalDetailRecordDeathTitle;

  /// No description provided for @animalDetailDeathDateLabel.
  ///
  /// In en, this message translates to:
  /// **'📅  When did it die?'**
  String get animalDetailDeathDateLabel;

  /// No description provided for @animalDetailDeathReasonHeader.
  ///
  /// In en, this message translates to:
  /// **'😞  Why did it die?'**
  String get animalDetailDeathReasonHeader;

  /// No description provided for @animalDetailDeathReasonDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get animalDetailDeathReasonDisease;

  /// No description provided for @animalDetailDeathReasonPneumonia.
  ///
  /// In en, this message translates to:
  /// **'Pneumonia'**
  String get animalDetailDeathReasonPneumonia;

  /// No description provided for @animalDetailDeathReasonDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get animalDetailDeathReasonDiarrhea;

  /// No description provided for @animalDetailDeathReasonSnakeBite.
  ///
  /// In en, this message translates to:
  /// **'Snake Bite'**
  String get animalDetailDeathReasonSnakeBite;

  /// No description provided for @animalDetailDeathReasonPredator.
  ///
  /// In en, this message translates to:
  /// **'Predator'**
  String get animalDetailDeathReasonPredator;

  /// No description provided for @animalDetailDeathReasonCold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get animalDetailDeathReasonCold;

  /// No description provided for @animalDetailDeathReasonNotEating.
  ///
  /// In en, this message translates to:
  /// **'Not Eating'**
  String get animalDetailDeathReasonNotEating;

  /// No description provided for @animalDetailDeathReasonBirthComplication.
  ///
  /// In en, this message translates to:
  /// **'Birth Complication'**
  String get animalDetailDeathReasonBirthComplication;

  /// No description provided for @animalDetailDeathReasonSuddenDeath.
  ///
  /// In en, this message translates to:
  /// **'Sudden Death'**
  String get animalDetailDeathReasonSuddenDeath;

  /// No description provided for @animalDetailDeathReasonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get animalDetailDeathReasonUnknown;

  /// No description provided for @animalDetailDeathReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get animalDetailDeathReasonRequired;

  /// No description provided for @animalDetailConfirmDeathButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Death'**
  String get animalDetailConfirmDeathButton;

  /// No description provided for @animalDetailRecordCastrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Castration'**
  String get animalDetailRecordCastrationTitle;

  /// No description provided for @animalDetailCastrationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'✂️  Castration Date'**
  String get animalDetailCastrationDateLabel;

  /// Suffix: '{animalName} marked as deceased'
  ///
  /// In en, this message translates to:
  /// **'marked as deceased'**
  String get animalDetailMarkedDeceasedSnackbar;

  /// No description provided for @kidManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Kid Management'**
  String get kidManagementTitle;

  /// No description provided for @kidFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get kidFilterAll;

  /// No description provided for @kidFilterMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get kidFilterMilk;

  /// No description provided for @kidFilterWeaned.
  ///
  /// In en, this message translates to:
  /// **'Weaned'**
  String get kidFilterWeaned;

  /// No description provided for @kidFilterMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get kidFilterMedicine;

  /// No description provided for @kidAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Kid added!'**
  String get kidAddedSnackbar;

  /// No description provided for @kidUpdatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Updated!'**
  String get kidUpdatedSnackbar;

  /// No description provided for @kidDeleteDialog.
  ///
  /// In en, this message translates to:
  /// **'Delete {kidId} ?'**
  String kidDeleteDialog(String kidId);

  /// No description provided for @kidDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'✖  No'**
  String get kidDeleteCancel;

  /// No description provided for @kidDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'🗑️  Yes'**
  String get kidDeleteConfirm;

  /// No description provided for @kidDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'🗑️ {kidId} deleted'**
  String kidDeletedSnackbar(String kidId);

  /// No description provided for @healthDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Center'**
  String get healthDashboardTitle;

  /// No description provided for @healthStatusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthStatusHealthy;

  /// No description provided for @healthStatusSick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get healthStatusSick;

  /// No description provided for @healthStatusFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get healthStatusFollowUp;

  /// No description provided for @healthDashboardNeedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get healthDashboardNeedSectionTitle;

  /// No description provided for @healthDashboardAlertsSection.
  ///
  /// In en, this message translates to:
  /// **'🔔  Alerts'**
  String get healthDashboardAlertsSection;

  /// No description provided for @healthCardVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get healthCardVaccinations;

  /// No description provided for @healthCardVaccinationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule & records'**
  String get healthCardVaccinationsSubtitle;

  /// No description provided for @healthCardTreatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get healthCardTreatments;

  /// No description provided for @healthCardTreatmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines & diagnosis'**
  String get healthCardTreatmentsSubtitle;

  /// No description provided for @healthCardDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get healthCardDeworming;

  /// No description provided for @healthCardDewormingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Antiparasitic schedule'**
  String get healthCardDewormingSubtitle;

  /// No description provided for @healthCardLabReports.
  ///
  /// In en, this message translates to:
  /// **'Lab Reports'**
  String get healthCardLabReports;

  /// No description provided for @healthCardLabReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test results & history'**
  String get healthCardLabReportsSubtitle;

  /// No description provided for @healthCardHoofCutting.
  ///
  /// In en, this message translates to:
  /// **'Hoof Cutting'**
  String get healthCardHoofCutting;

  /// No description provided for @healthCardHoofCuttingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trim & schedule'**
  String get healthCardHoofCuttingSubtitle;

  /// No description provided for @healthDashboardUpcomingVaccinations.
  ///
  /// In en, this message translates to:
  /// **'💉  Upcoming Vaccinations'**
  String get healthDashboardUpcomingVaccinations;

  /// No description provided for @healthDashboardActiveTreatments.
  ///
  /// In en, this message translates to:
  /// **'🩺  Active Treatments'**
  String get healthDashboardActiveTreatments;

  /// No description provided for @healthDashboardVaccinationsOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count} Vaccination(s) Overdue!'**
  String healthDashboardVaccinationsOverdue(int count);

  /// No description provided for @healthDashboardTapToAction.
  ///
  /// In en, this message translates to:
  /// **'Tap to take action now'**
  String get healthDashboardTapToAction;

  /// No description provided for @healthDashboardComingSoon.
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get healthDashboardComingSoon;

  /// No description provided for @hoofCuttingSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Hoof Cutting'**
  String get hoofCuttingSheetTitle;

  /// No description provided for @hoofCuttingSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record hoof trimming details'**
  String get hoofCuttingSheetSubtitle;

  /// No description provided for @hoofCuttingWhichAnimal.
  ///
  /// In en, this message translates to:
  /// **'🐾  Which animal?'**
  String get hoofCuttingWhichAnimal;

  /// No description provided for @vaccinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinationTitle;

  /// No description provided for @vaccinationTabSchedule.
  ///
  /// In en, this message translates to:
  /// **'📅 Schedule ({count})'**
  String vaccinationTabSchedule(int count);

  /// No description provided for @vaccinationTabHistory.
  ///
  /// In en, this message translates to:
  /// **'✅ History ({count})'**
  String vaccinationTabHistory(int count);

  /// No description provided for @vaccinationTabAlerts.
  ///
  /// In en, this message translates to:
  /// **'🔔 Alerts ({count})'**
  String vaccinationTabAlerts(int count);

  /// No description provided for @vaccinationAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination Record'**
  String get vaccinationAddSheetTitle;

  /// No description provided for @vaccinationSelectVaccineLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Vaccine'**
  String get vaccinationSelectVaccineLabel;

  /// No description provided for @vaccineFmd.
  ///
  /// In en, this message translates to:
  /// **'FMD'**
  String get vaccineFmd;

  /// No description provided for @vaccineFmdDesc.
  ///
  /// In en, this message translates to:
  /// **'Foot & Mouth'**
  String get vaccineFmdDesc;

  /// No description provided for @vaccineBq.
  ///
  /// In en, this message translates to:
  /// **'BQ'**
  String get vaccineBq;

  /// No description provided for @vaccineBqDesc.
  ///
  /// In en, this message translates to:
  /// **'Black Quarter'**
  String get vaccineBqDesc;

  /// No description provided for @vaccineHs.
  ///
  /// In en, this message translates to:
  /// **'HS'**
  String get vaccineHs;

  /// No description provided for @vaccineHsDesc.
  ///
  /// In en, this message translates to:
  /// **'Hemorrhagic Sep.'**
  String get vaccineHsDesc;

  /// No description provided for @vaccinePpr.
  ///
  /// In en, this message translates to:
  /// **'PPR'**
  String get vaccinePpr;

  /// No description provided for @vaccinePprDesc.
  ///
  /// In en, this message translates to:
  /// **'Sheep / Goat'**
  String get vaccinePprDesc;

  /// No description provided for @vaccineBrucella.
  ///
  /// In en, this message translates to:
  /// **'Brucella'**
  String get vaccineBrucella;

  /// No description provided for @vaccineBrucellaDesc.
  ///
  /// In en, this message translates to:
  /// **'Brucellosis'**
  String get vaccineBrucellaDesc;

  /// No description provided for @vaccineDewormingName.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get vaccineDewormingName;

  /// No description provided for @vaccineDewormingDesc.
  ///
  /// In en, this message translates to:
  /// **'Parasites'**
  String get vaccineDewormingDesc;

  /// No description provided for @vaccinationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Date'**
  String get vaccinationDateLabel;

  /// No description provided for @vaccinationAnimalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID'**
  String get vaccinationAnimalIdRequired;

  /// No description provided for @vaccinationAddFab.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get vaccinationAddFab;

  /// No description provided for @vaccinationAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{vaccine} vaccination added! 💉'**
  String vaccinationAddedSnackbar(String vaccine);

  /// No description provided for @vaccinationNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'💉 No upcoming vaccinations'**
  String get vaccinationNoUpcoming;

  /// No description provided for @vaccinationNoUpcomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to schedule one'**
  String get vaccinationNoUpcomingSubtitle;

  /// No description provided for @vaccinationNoHistory.
  ///
  /// In en, this message translates to:
  /// **'✅ No vaccination history yet'**
  String get vaccinationNoHistory;

  /// No description provided for @vaccinationNoHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Records appear here after administration'**
  String get vaccinationNoHistorySubtitle;

  /// No description provided for @treatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease & Treatment'**
  String get treatmentTitle;

  /// No description provided for @treatmentFilterAll.
  ///
  /// In en, this message translates to:
  /// **'🗂️ All ({count})'**
  String treatmentFilterAll(int count);

  /// No description provided for @treatmentFilterActive.
  ///
  /// In en, this message translates to:
  /// **'🤒 Active ({count})'**
  String treatmentFilterActive(int count);

  /// No description provided for @treatmentFilterFollowUp.
  ///
  /// In en, this message translates to:
  /// **'🔄 Follow-up ({count})'**
  String treatmentFilterFollowUp(int count);

  /// No description provided for @treatmentFilterRecovered.
  ///
  /// In en, this message translates to:
  /// **'✅ Recovered ({count})'**
  String treatmentFilterRecovered(int count);

  /// No description provided for @treatmentReportSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Sick Animal'**
  String get treatmentReportSheetTitle;

  /// No description provided for @treatmentReportFab.
  ///
  /// In en, this message translates to:
  /// **'Report Sick Animal'**
  String get treatmentReportFab;

  /// No description provided for @treatmentSymptomsHeader.
  ///
  /// In en, this message translates to:
  /// **'What symptoms do you see?'**
  String get treatmentSymptomsHeader;

  /// No description provided for @symptomFever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get symptomFever;

  /// No description provided for @symptomDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get symptomDiarrhea;

  /// No description provided for @symptomLimping.
  ///
  /// In en, this message translates to:
  /// **'Limping'**
  String get symptomLimping;

  /// No description provided for @symptomNoAppetite.
  ///
  /// In en, this message translates to:
  /// **'No appetite'**
  String get symptomNoAppetite;

  /// No description provided for @symptomCoughing.
  ///
  /// In en, this message translates to:
  /// **'Coughing'**
  String get symptomCoughing;

  /// No description provided for @symptomBloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get symptomBloating;

  /// No description provided for @symptomEyeDischarge.
  ///
  /// In en, this message translates to:
  /// **'Eye discharge'**
  String get symptomEyeDischarge;

  /// No description provided for @symptomNasalDischarge.
  ///
  /// In en, this message translates to:
  /// **'Nasal discharge'**
  String get symptomNasalDischarge;

  /// No description provided for @symptomSkinLesions.
  ///
  /// In en, this message translates to:
  /// **'Skin lesions'**
  String get symptomSkinLesions;

  /// No description provided for @symptomLessMilk.
  ///
  /// In en, this message translates to:
  /// **'Less milk'**
  String get symptomLessMilk;

  /// No description provided for @treatmentOtherSymptomsHint.
  ///
  /// In en, this message translates to:
  /// **'✏️  Other symptoms (e.g. Swollen leg, Trembling)'**
  String get treatmentOtherSymptomsHint;

  /// No description provided for @treatmentDiagnosisHint.
  ///
  /// In en, this message translates to:
  /// **'🔍  Diagnosis (e.g. Fever & infection)'**
  String get treatmentDiagnosisHint;

  /// No description provided for @treatmentMedicineHint.
  ///
  /// In en, this message translates to:
  /// **'💊  Medicine / Treatment'**
  String get treatmentMedicineHint;

  /// No description provided for @treatmentVetNameHint.
  ///
  /// In en, this message translates to:
  /// **'👨‍⚕️  Vet Name'**
  String get treatmentVetNameHint;

  /// No description provided for @treatmentWithdrawalHint.
  ///
  /// In en, this message translates to:
  /// **'⏳  Withdrawal period in days (optional)'**
  String get treatmentWithdrawalHint;

  /// No description provided for @treatmentAttachLabReport.
  ///
  /// In en, this message translates to:
  /// **'Attach Lab Report (optional)'**
  String get treatmentAttachLabReport;

  /// No description provided for @treatmentLabReportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Lab report upload coming soon!'**
  String get treatmentLabReportComingSoon;

  /// No description provided for @treatmentAnimalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID'**
  String get treatmentAnimalIdRequired;

  /// No description provided for @treatmentDiagnosisRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a diagnosis'**
  String get treatmentDiagnosisRequired;

  /// No description provided for @treatmentSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Treatment'**
  String get treatmentSaveButton;

  /// No description provided for @treatmentAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Treatment record added!'**
  String get treatmentAddedSnackbar;

  /// No description provided for @dewormingStep1Label.
  ///
  /// In en, this message translates to:
  /// **'Animal ID / Tag Number'**
  String get dewormingStep1Label;

  /// No description provided for @dewormingStep2Label.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine Name'**
  String get dewormingStep2Label;

  /// No description provided for @dewormingStep3Label.
  ///
  /// In en, this message translates to:
  /// **'Dose and Body Weight'**
  String get dewormingStep3Label;

  /// No description provided for @dewormingStep4Label.
  ///
  /// In en, this message translates to:
  /// **'Deworming Date'**
  String get dewormingStep4Label;

  /// No description provided for @dewormingAnimalIdHint.
  ///
  /// In en, this message translates to:
  /// **'🐄  Example: 1 or C-001'**
  String get dewormingAnimalIdHint;

  /// No description provided for @dewormingBrandNameHint.
  ///
  /// In en, this message translates to:
  /// **'🏷️  Medicine brand name'**
  String get dewormingBrandNameHint;

  /// No description provided for @dewormingSaltNameHint.
  ///
  /// In en, this message translates to:
  /// **'🧪  Medicine salt name'**
  String get dewormingSaltNameHint;

  /// No description provided for @dewormingDoseHint.
  ///
  /// In en, this message translates to:
  /// **'💧  Dose (Example: 10ml)'**
  String get dewormingDoseHint;

  /// No description provided for @dewormingWeightHint.
  ///
  /// In en, this message translates to:
  /// **'⚖️  Body weight in KG (Example: 245)'**
  String get dewormingWeightHint;

  /// No description provided for @dewormingVetNameHint.
  ///
  /// In en, this message translates to:
  /// **'👨‍⚕️ Vet Name (optional)'**
  String get dewormingVetNameHint;

  /// No description provided for @dewormingWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose when medicine is given'**
  String get dewormingWhenLabel;

  /// No description provided for @dewormingAddMedicineButton.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get dewormingAddMedicineButton;

  /// No description provided for @dewormingMedicineNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter brand or salt name to add medicine'**
  String get dewormingMedicineNameRequired;

  /// No description provided for @dewormingAnimalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID'**
  String get dewormingAnimalIdRequired;

  /// No description provided for @dewormingAtLeastOneMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add at least one medicine'**
  String get dewormingAtLeastOneMedicine;

  /// No description provided for @dewormingValidWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid body weight in KG'**
  String get dewormingValidWeightRequired;

  /// No description provided for @dewormingAnimalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Animal not found. Enter valid ID or tag'**
  String get dewormingAnimalNotFound;

  /// No description provided for @dewormingSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Deworming saved. Weight updated to {weight} kg'**
  String dewormingSavedSnackbar(double weight);

  /// No description provided for @labReportAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Lab Report'**
  String get labReportAddSheetTitle;

  /// No description provided for @labReportSelectTest.
  ///
  /// In en, this message translates to:
  /// **'Select Test'**
  String get labReportSelectTest;

  /// No description provided for @labTestCbc.
  ///
  /// In en, this message translates to:
  /// **'Complete Blood Count'**
  String get labTestCbc;

  /// No description provided for @labTestCbcAbbr.
  ///
  /// In en, this message translates to:
  /// **'CBC'**
  String get labTestCbcAbbr;

  /// No description provided for @labTestBrucella.
  ///
  /// In en, this message translates to:
  /// **'Brucella Test'**
  String get labTestBrucella;

  /// No description provided for @labTestBrucellaAbbr.
  ///
  /// In en, this message translates to:
  /// **'Brucellosis'**
  String get labTestBrucellaAbbr;

  /// No description provided for @labTestMilkCulture.
  ///
  /// In en, this message translates to:
  /// **'Milk Culture & Sensitivity'**
  String get labTestMilkCulture;

  /// No description provided for @labTestMilkCultureAbbr.
  ///
  /// In en, this message translates to:
  /// **'Mastitis'**
  String get labTestMilkCultureAbbr;

  /// No description provided for @labTestFecalEgg.
  ///
  /// In en, this message translates to:
  /// **'Fecal Egg Count'**
  String get labTestFecalEgg;

  /// No description provided for @labTestFecalEggAbbr.
  ///
  /// In en, this message translates to:
  /// **'Parasites'**
  String get labTestFecalEggAbbr;

  /// No description provided for @labTestLiver.
  ///
  /// In en, this message translates to:
  /// **'Liver Function Test'**
  String get labTestLiver;

  /// No description provided for @labTestLiverAbbr.
  ///
  /// In en, this message translates to:
  /// **'LFT'**
  String get labTestLiverAbbr;

  /// No description provided for @labTestTuberculin.
  ///
  /// In en, this message translates to:
  /// **'Tuberculin Test'**
  String get labTestTuberculin;

  /// No description provided for @labTestTuberculinAbbr.
  ///
  /// In en, this message translates to:
  /// **'TB test'**
  String get labTestTuberculinAbbr;

  /// No description provided for @labTestPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Confirmation'**
  String get labTestPregnancy;

  /// No description provided for @labTestPregnancyAbbr.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get labTestPregnancyAbbr;

  /// No description provided for @labTestBloodSmear.
  ///
  /// In en, this message translates to:
  /// **'Blood Smear'**
  String get labTestBloodSmear;

  /// No description provided for @labTestBloodSmearAbbr.
  ///
  /// In en, this message translates to:
  /// **'Blood parasites'**
  String get labTestBloodSmearAbbr;

  /// No description provided for @labTestUrineAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Urine Analysis'**
  String get labTestUrineAnalysis;

  /// No description provided for @labTestUrineAnalysisAbbr.
  ///
  /// In en, this message translates to:
  /// **'Urinalysis'**
  String get labTestUrineAnalysisAbbr;

  /// No description provided for @labTestOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get labTestOther;

  /// No description provided for @labTestCustomHint.
  ///
  /// In en, this message translates to:
  /// **'✏️  Enter test name'**
  String get labTestCustomHint;

  /// No description provided for @labReportLabNameHint.
  ///
  /// In en, this message translates to:
  /// **'🏥  Lab Name (optional)'**
  String get labReportLabNameHint;

  /// No description provided for @labReportUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Report (optional)'**
  String get labReportUploadButton;

  /// No description provided for @labReportUploadPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload report image'**
  String get labReportUploadPlaceholder;

  /// No description provided for @labReportUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Uploaded ✅'**
  String get labReportUploadedLabel;

  /// No description provided for @labReportAnimalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID'**
  String get labReportAnimalIdRequired;

  /// No description provided for @labReportTestNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a test name'**
  String get labReportTestNameRequired;

  /// No description provided for @labReportSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Report'**
  String get labReportSaveButton;

  /// No description provided for @labReportAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Lab report added! 🔬'**
  String get labReportAddedSnackbar;

  /// No description provided for @financeDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'💰 Finance'**
  String get financeDashboardTitle;

  /// No description provided for @financeMoneySpent.
  ///
  /// In en, this message translates to:
  /// **'Money Spent'**
  String get financeMoneySpent;

  /// No description provided for @financeMoneyEarned.
  ///
  /// In en, this message translates to:
  /// **'Money Earned'**
  String get financeMoneyEarned;

  /// No description provided for @financeProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get financeProfit;

  /// No description provided for @financeLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get financeLoss;

  /// No description provided for @financeQuickAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Quick Add Expense'**
  String get financeQuickAddExpense;

  /// No description provided for @financeQuickFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get financeQuickFeed;

  /// No description provided for @financeQuickMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get financeQuickMedicine;

  /// No description provided for @financeQuickDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get financeQuickDoctor;

  /// No description provided for @financeQuickLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get financeQuickLabour;

  /// No description provided for @financeQuickEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get financeQuickEquipment;

  /// No description provided for @financeQuickTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get financeQuickTransport;

  /// No description provided for @financeQuickOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get financeQuickOther;

  /// No description provided for @financeQuickAllExpenses.
  ///
  /// In en, this message translates to:
  /// **'All\nExpenses'**
  String get financeQuickAllExpenses;

  /// No description provided for @financeQuickFeedMix.
  ///
  /// In en, this message translates to:
  /// **'Feed\nMix'**
  String get financeQuickFeedMix;

  /// No description provided for @financeWhereMoneygoes.
  ///
  /// In en, this message translates to:
  /// **'Where Money Goes'**
  String get financeWhereMoneygoes;

  /// No description provided for @financePieFeed.
  ///
  /// In en, this message translates to:
  /// **'🌾 Feed'**
  String get financePieFeed;

  /// No description provided for @financePieLabour.
  ///
  /// In en, this message translates to:
  /// **'👷 Labour'**
  String get financePieLabour;

  /// No description provided for @financePieMedicine.
  ///
  /// In en, this message translates to:
  /// **'💊 Medicine'**
  String get financePieMedicine;

  /// No description provided for @financePieDoctor.
  ///
  /// In en, this message translates to:
  /// **'🏥 Doctor'**
  String get financePieDoctor;

  /// No description provided for @financePieEquipment.
  ///
  /// In en, this message translates to:
  /// **'🔧 Equipment'**
  String get financePieEquipment;

  /// No description provided for @financePieOther.
  ///
  /// In en, this message translates to:
  /// **'📦 Other'**
  String get financePieOther;

  /// No description provided for @financeMonthlySpending.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spending'**
  String get financeMonthlySpending;

  /// No description provided for @financeRecentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent Expenses'**
  String get financeRecentExpenses;

  /// No description provided for @financeAddExpenseFab.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get financeAddExpenseFab;

  /// No description provided for @expenseListTitle.
  ///
  /// In en, this message translates to:
  /// **'📋 All Expenses'**
  String get expenseListTitle;

  /// No description provided for @expenseListSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search expenses...'**
  String get expenseListSearchHint;

  /// No description provided for @expenseListTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get expenseListTotalSpent;

  /// No description provided for @expenseListItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String expenseListItemCount(int count);

  /// No description provided for @expenseListFilterAll.
  ///
  /// In en, this message translates to:
  /// **'🔍 All'**
  String get expenseListFilterAll;

  /// No description provided for @expenseListFilterFeed.
  ///
  /// In en, this message translates to:
  /// **'🌾 Feed'**
  String get expenseListFilterFeed;

  /// No description provided for @expenseListFilterMedicine.
  ///
  /// In en, this message translates to:
  /// **'💊 Medicine'**
  String get expenseListFilterMedicine;

  /// No description provided for @expenseListFilterDoctor.
  ///
  /// In en, this message translates to:
  /// **'🏥 Doctor'**
  String get expenseListFilterDoctor;

  /// No description provided for @expenseListFilterLabour.
  ///
  /// In en, this message translates to:
  /// **'👷 Labour'**
  String get expenseListFilterLabour;

  /// No description provided for @expenseListFilterEquip.
  ///
  /// In en, this message translates to:
  /// **'🔧 Equip'**
  String get expenseListFilterEquip;

  /// No description provided for @expenseListFilterTravel.
  ///
  /// In en, this message translates to:
  /// **'🚛 Travel'**
  String get expenseListFilterTravel;

  /// No description provided for @expenseListFilterOther.
  ///
  /// In en, this message translates to:
  /// **'📦 Other'**
  String get expenseListFilterOther;

  /// No description provided for @expenseListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get expenseListEmpty;

  /// No description provided for @financeReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Reports'**
  String get financeReportsTitle;

  /// No description provided for @financeReportsTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get financeReportsTotalSpent;

  /// No description provided for @financeReportsTotalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total Earned'**
  String get financeReportsTotalEarned;

  /// No description provided for @financeReportsProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get financeReportsProfit;

  /// No description provided for @financeReportsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get financeReportsPerMonth;

  /// No description provided for @financeReportsWhereMoney.
  ///
  /// In en, this message translates to:
  /// **'🌾 Where Money Goes'**
  String get financeReportsWhereMoney;

  /// No description provided for @financeBarFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get financeBarFeed;

  /// No description provided for @financeBarLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get financeBarLabour;

  /// No description provided for @financeBarMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get financeBarMedicine;

  /// No description provided for @financeBarVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get financeBarVet;

  /// No description provided for @financeBarEquip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get financeBarEquip;

  /// No description provided for @financeBarTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get financeBarTransport;

  /// No description provided for @financeBarOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get financeBarOther;

  /// No description provided for @financeReportsHowYouPay.
  ///
  /// In en, this message translates to:
  /// **'💳 How You Pay'**
  String get financeReportsHowYouPay;

  /// No description provided for @financePayCash.
  ///
  /// In en, this message translates to:
  /// **'💵 Cash'**
  String get financePayCash;

  /// No description provided for @financePayUpi.
  ///
  /// In en, this message translates to:
  /// **'📱 UPI'**
  String get financePayUpi;

  /// No description provided for @financePayBank.
  ///
  /// In en, this message translates to:
  /// **'🏦 Bank'**
  String get financePayBank;

  /// No description provided for @financePayCredit.
  ///
  /// In en, this message translates to:
  /// **'💳 Credit'**
  String get financePayCredit;

  /// No description provided for @financeDownloadSheet.
  ///
  /// In en, this message translates to:
  /// **'Download\nSheet'**
  String get financeDownloadSheet;

  /// No description provided for @financeDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download\nPDF'**
  String get financeDownloadPdf;

  /// No description provided for @financeCsvDownloadedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'CSV file downloaded! ✅'**
  String get financeCsvDownloadedSnackbar;

  /// No description provided for @financePdfDownloadedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'PDF file downloaded! ✅'**
  String get financePdfDownloadedSnackbar;

  /// No description provided for @feedAnimalDairyCow.
  ///
  /// In en, this message translates to:
  /// **'Dairy Cow'**
  String get feedAnimalDairyCow;

  /// No description provided for @feedAnimalDairyCowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Milking Cow'**
  String get feedAnimalDairyCowSubtitle;

  /// No description provided for @feedAnimalBuffalo.
  ///
  /// In en, this message translates to:
  /// **'Buffalo'**
  String get feedAnimalBuffalo;

  /// No description provided for @feedAnimalBuffaloSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Water Buffalo'**
  String get feedAnimalBuffaloSubtitle;

  /// No description provided for @feedAnimalGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get feedAnimalGoat;

  /// No description provided for @feedAnimalGoatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Goat'**
  String get feedAnimalGoatSubtitle;

  /// No description provided for @feedAnimalSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get feedAnimalSheep;

  /// No description provided for @feedAnimalSheepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Sheep'**
  String get feedAnimalSheepSubtitle;

  /// No description provided for @feedAnimalHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get feedAnimalHorse;

  /// No description provided for @feedAnimalHorseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Riding Horse'**
  String get feedAnimalHorseSubtitle;

  /// No description provided for @feedAnimalPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get feedAnimalPig;

  /// No description provided for @feedAnimalPigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Pig'**
  String get feedAnimalPigSubtitle;

  /// No description provided for @feedItemMaize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get feedItemMaize;

  /// No description provided for @feedItemSoybeanMeal.
  ///
  /// In en, this message translates to:
  /// **'Soybean Meal'**
  String get feedItemSoybeanMeal;

  /// No description provided for @feedItemWheatBran.
  ///
  /// In en, this message translates to:
  /// **'Wheat Bran'**
  String get feedItemWheatBran;

  /// No description provided for @feedItemCottonseedCake.
  ///
  /// In en, this message translates to:
  /// **'Cottonseed Cake'**
  String get feedItemCottonseedCake;

  /// No description provided for @feedItemGreenFodder.
  ///
  /// In en, this message translates to:
  /// **'Green Fodder'**
  String get feedItemGreenFodder;

  /// No description provided for @feedItemDryHay.
  ///
  /// In en, this message translates to:
  /// **'Dry Hay'**
  String get feedItemDryHay;

  /// No description provided for @feedItemMustardCake.
  ///
  /// In en, this message translates to:
  /// **'Mustard Cake'**
  String get feedItemMustardCake;

  /// No description provided for @feedItemMineralMix.
  ///
  /// In en, this message translates to:
  /// **'Mineral Mix'**
  String get feedItemMineralMix;

  /// No description provided for @feedAlreadyAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Already added! Change quantity below.'**
  String get feedAlreadyAddedSnackbar;

  /// No description provided for @feedipediaOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open Feedipedia right now.'**
  String get feedipediaOpenError;

  /// No description provided for @milkLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Milk'**
  String get milkLogTitle;

  /// No description provided for @milkLogTodayChip.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get milkLogTodayChip;

  /// No description provided for @milkLogSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get milkLogSummaryTotal;

  /// No description provided for @milkLogSummaryEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get milkLogSummaryEntries;

  /// No description provided for @milkLogSummaryAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get milkLogSummaryAnimals;

  /// No description provided for @milkLogStepTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get milkLogStepTime;

  /// No description provided for @milkLogStepAnimal.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get milkLogStepAnimal;

  /// No description provided for @milkLogStepLitres.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get milkLogStepLitres;

  /// No description provided for @milkLogStepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get milkLogStepDone;

  /// No description provided for @milkLogSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get milkLogSavedTitle;

  /// No description provided for @milkLogGoHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get milkLogGoHomeButton;

  /// No description provided for @milkLogAddMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get milkLogAddMoreButton;

  /// No description provided for @milkLogWhenDidYouMilk.
  ///
  /// In en, this message translates to:
  /// **'When did you milk?'**
  String get milkLogWhenDidYouMilk;

  /// No description provided for @milkLogSelectSessionHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select morning or evening'**
  String get milkLogSelectSessionHint;

  /// No description provided for @milkSessionMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get milkSessionMorning;

  /// No description provided for @milkSessionMorningRange.
  ///
  /// In en, this message translates to:
  /// **'5 AM – 12 PM'**
  String get milkSessionMorningRange;

  /// No description provided for @milkSessionEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get milkSessionEvening;

  /// No description provided for @milkSessionEveningRange.
  ///
  /// In en, this message translates to:
  /// **'3 PM – 9 PM'**
  String get milkSessionEveningRange;

  /// No description provided for @milkLogTodayEntriesPreview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Entries ({count})'**
  String milkLogTodayEntriesPreview(int count);

  /// No description provided for @milkLogWhichAnimal.
  ///
  /// In en, this message translates to:
  /// **'Which animal?'**
  String get milkLogWhichAnimal;

  /// No description provided for @milkLogTapAnimalHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on the animal you milked'**
  String get milkLogTapAnimalHint;

  /// No description provided for @breedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get breedingTitle;

  /// No description provided for @breedingTabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get breedingTabDashboard;

  /// No description provided for @breedingTabHeatTracking.
  ///
  /// In en, this message translates to:
  /// **'Heat Tracking'**
  String get breedingTabHeatTracking;

  /// No description provided for @breedingTabPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get breedingTabPregnancy;

  /// No description provided for @breedingAddRecordSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Breeding Record'**
  String get breedingAddRecordSheetTitle;

  /// No description provided for @breedingMenuRecordHeat.
  ///
  /// In en, this message translates to:
  /// **'Record Heat'**
  String get breedingMenuRecordHeat;

  /// No description provided for @breedingMenuRecordHeatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Observe heat in an animal'**
  String get breedingMenuRecordHeatSubtitle;

  /// No description provided for @breedingMenuAi.
  ///
  /// In en, this message translates to:
  /// **'Artificial Insemination'**
  String get breedingMenuAi;

  /// No description provided for @breedingMenuAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record AI procedure'**
  String get breedingMenuAiSubtitle;

  /// No description provided for @breedingMenuPregnancyCheck.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Check'**
  String get breedingMenuPregnancyCheck;

  /// No description provided for @breedingMenuPregnancyCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update pregnancy status'**
  String get breedingMenuPregnancyCheckSubtitle;

  /// No description provided for @breedingHeatDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Heat'**
  String get breedingHeatDialogTitle;

  /// No description provided for @breedingHeatAnimalIdHint.
  ///
  /// In en, this message translates to:
  /// **'🐄 Animal ID (e.g. 1)'**
  String get breedingHeatAnimalIdHint;

  /// No description provided for @breedingHeatDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Heat Date'**
  String get breedingHeatDateLabel;

  /// No description provided for @breedingHeatIntensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get breedingHeatIntensityLabel;

  /// No description provided for @breedingHeatIntensityStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get breedingHeatIntensityStrong;

  /// No description provided for @breedingHeatIntensityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get breedingHeatIntensityModerate;

  /// No description provided for @breedingHeatIntensityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get breedingHeatIntensityMild;

  /// No description provided for @breedingHeatSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Heat Record'**
  String get breedingHeatSaveButton;

  /// No description provided for @breedingHeatAnimalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID'**
  String get breedingHeatAnimalIdRequired;

  /// No description provided for @breedingHeatAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Heat record added!'**
  String get breedingHeatAddedSnackbar;

  /// No description provided for @breedingAiDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add AI Record'**
  String get breedingAiDialogTitle;

  /// No description provided for @breedingAiDateLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Date'**
  String get breedingAiDateLabel;

  /// No description provided for @breedingAiBullSemenIdHint.
  ///
  /// In en, this message translates to:
  /// **'🐂 Bull / Semen ID'**
  String get breedingAiBullSemenIdHint;

  /// No description provided for @breedingAiTechnicianHint.
  ///
  /// In en, this message translates to:
  /// **'👨‍⚕️ Technician Name'**
  String get breedingAiTechnicianHint;

  /// No description provided for @breedingAiHeatIntensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Heat Intensity'**
  String get breedingAiHeatIntensityLabel;

  /// No description provided for @breedingAiValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter Animal ID and Bull/Semen ID'**
  String get breedingAiValidationError;

  /// No description provided for @breedingAiSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save AI Record'**
  String get breedingAiSaveButton;

  /// No description provided for @breedingAiAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'AI record added!'**
  String get breedingAiAddedSnackbar;

  /// No description provided for @breedingPregnancyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Check'**
  String get breedingPregnancyDialogTitle;

  /// No description provided for @breedingPregnancyMatingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Mating Date'**
  String get breedingPregnancyMatingDateLabel;

  /// No description provided for @breedingPregnancyExpectedDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Delivery'**
  String get breedingPregnancyExpectedDeliveryLabel;

  /// No description provided for @breedingPregnancySaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Pregnancy Record'**
  String get breedingPregnancySaveButton;

  /// No description provided for @breedingPregnancyAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy record added!'**
  String get breedingPregnancyAddedSnackbar;

  /// No description provided for @breedingAddRecordFab.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get breedingAddRecordFab;

  /// No description provided for @farmProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Farm'**
  String get farmProfileTitle;

  /// No description provided for @farmProfileAddPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap to add farm photo'**
  String get farmProfileAddPhotoLabel;

  /// No description provided for @farmProfileCameraOpeningSnackbar.
  ///
  /// In en, this message translates to:
  /// **'📸 Camera opening...'**
  String get farmProfileCameraOpeningSnackbar;

  /// No description provided for @farmProfileFieldFarmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmProfileFieldFarmName;

  /// No description provided for @farmProfileFieldFarmNameHint.
  ///
  /// In en, this message translates to:
  /// **'Type your farm name'**
  String get farmProfileFieldFarmNameHint;

  /// No description provided for @farmProfileFieldOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get farmProfileFieldOwnerName;

  /// No description provided for @farmProfileFieldOwnerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get farmProfileFieldOwnerNameHint;

  /// No description provided for @farmProfileFieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get farmProfileFieldAddress;

  /// No description provided for @farmProfileFieldAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Village, Taluka, District'**
  String get farmProfileFieldAddressHint;

  /// No description provided for @farmProfileFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Geographical Location'**
  String get farmProfileFieldLocation;

  /// No description provided for @farmProfileFieldLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to get location'**
  String get farmProfileFieldLocationHint;

  /// No description provided for @farmProfileLocationCapturedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'📍 Location captured!'**
  String get farmProfileLocationCapturedSnackbar;

  /// No description provided for @farmProfileFieldManager.
  ///
  /// In en, this message translates to:
  /// **'Manager Name'**
  String get farmProfileFieldManager;

  /// No description provided for @farmProfileFieldManagerHint.
  ///
  /// In en, this message translates to:
  /// **'Farm manager name'**
  String get farmProfileFieldManagerHint;

  /// No description provided for @farmProfileFieldVet.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get farmProfileFieldVet;

  /// No description provided for @farmProfileFieldVetHint.
  ///
  /// In en, this message translates to:
  /// **'Doctor name & phone'**
  String get farmProfileFieldVetHint;

  /// No description provided for @farmProfileFieldYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube Channel'**
  String get farmProfileFieldYoutube;

  /// No description provided for @farmProfileFieldYoutubeHint.
  ///
  /// In en, this message translates to:
  /// **'Your channel URL (optional)'**
  String get farmProfileFieldYoutubeHint;

  /// No description provided for @farmProfileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get farmProfileSaveButton;

  /// No description provided for @farmProfileSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Profile saved successfully!'**
  String get farmProfileSavedSnackbar;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpTitle;

  /// No description provided for @helpHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get helpHeaderTitle;

  /// No description provided for @helpHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an option below'**
  String get helpHeaderSubtitle;

  /// No description provided for @helpCallUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get helpCallUs;

  /// No description provided for @helpCallUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to our team'**
  String get helpCallUsSubtitle;

  /// No description provided for @helpWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get helpWhatsApp;

  /// No description provided for @helpWhatsAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get helpWhatsAppSubtitle;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get helpEmail;

  /// No description provided for @helpEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get helpEmailSubtitle;

  /// No description provided for @helpFaqSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Questions'**
  String get helpFaqSectionTitle;

  /// No description provided for @helpFaq1Question.
  ///
  /// In en, this message translates to:
  /// **'How to add an animal?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Animals tab → Tap the + button → Follow the 4 steps to add your animal.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In en, this message translates to:
  /// **'How to track vaccination?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Health tab → Tap Vaccination → Add new vaccination record for your animal.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In en, this message translates to:
  /// **'How to add expenses?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Finance tab → Tap + button → Select category → Enter amount → Save.'**
  String get helpFaq3Answer;

  /// No description provided for @helpFaq4Question.
  ///
  /// In en, this message translates to:
  /// **'How to add team members?'**
  String get helpFaq4Question;

  /// No description provided for @helpFaq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to More → My Team → Tap Add Worker → Fill name, phone, and role.'**
  String get helpFaq4Answer;

  /// No description provided for @helpFaq5Question.
  ///
  /// In en, this message translates to:
  /// **'How to see reports?'**
  String get helpFaq5Question;

  /// No description provided for @helpFaq5Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Finance tab → Tap Reports → Select date range to see your farm reports.'**
  String get helpFaq5Answer;

  /// No description provided for @helpFaq6Question.
  ///
  /// In en, this message translates to:
  /// **'How to change language?'**
  String get helpFaq6Question;

  /// No description provided for @helpFaq6Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to More → Language → Select your preferred language.'**
  String get helpFaq6Answer;

  /// No description provided for @helpVideosSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get helpVideosSectionTitle;

  /// No description provided for @helpVideo1Title.
  ///
  /// In en, this message translates to:
  /// **'Getting started with Rumeno'**
  String get helpVideo1Title;

  /// No description provided for @helpVideo1Duration.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get helpVideo1Duration;

  /// No description provided for @helpVideo2Title.
  ///
  /// In en, this message translates to:
  /// **'Managing your animals'**
  String get helpVideo2Title;

  /// No description provided for @helpVideo2Duration.
  ///
  /// In en, this message translates to:
  /// **'3 min'**
  String get helpVideo2Duration;

  /// No description provided for @helpVideo3Title.
  ///
  /// In en, this message translates to:
  /// **'Track health & vaccination'**
  String get helpVideo3Title;

  /// No description provided for @helpVideo3Duration.
  ///
  /// In en, this message translates to:
  /// **'4 min'**
  String get helpVideo3Duration;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettingsHeaderTitle;

  /// No description provided for @notificationSettingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what alerts you want'**
  String get notificationSettingsHeaderSubtitle;

  /// No description provided for @notificationSectionAnimalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Animal Alerts'**
  String get notificationSectionAnimalAlerts;

  /// No description provided for @notificationToggleVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Due'**
  String get notificationToggleVaccination;

  /// No description provided for @notificationToggleVaccinationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When vaccination is due'**
  String get notificationToggleVaccinationSubtitle;

  /// No description provided for @notificationToggleHealth.
  ///
  /// In en, this message translates to:
  /// **'Health Alerts'**
  String get notificationToggleHealth;

  /// No description provided for @notificationToggleHealthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When animal is sick'**
  String get notificationToggleHealthSubtitle;

  /// No description provided for @notificationToggleBreeding.
  ///
  /// In en, this message translates to:
  /// **'Breeding Alerts'**
  String get notificationToggleBreeding;

  /// No description provided for @notificationToggleBreedingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Heat & pregnancy updates'**
  String get notificationToggleBreedingSubtitle;

  /// No description provided for @notificationToggleMoney.
  ///
  /// In en, this message translates to:
  /// **'Money Alerts'**
  String get notificationToggleMoney;

  /// No description provided for @notificationToggleMoneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment & expense reminders'**
  String get notificationToggleMoneySubtitle;

  /// No description provided for @notificationSectionDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get notificationSectionDailyReminders;

  /// No description provided for @notificationToggleMilking.
  ///
  /// In en, this message translates to:
  /// **'Milking Time'**
  String get notificationToggleMilking;

  /// No description provided for @notificationToggleMilkingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Morning & evening reminder'**
  String get notificationToggleMilkingSubtitle;

  /// No description provided for @notificationToggleFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding Time'**
  String get notificationToggleFeeding;

  /// No description provided for @notificationToggleFeedingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feed your animals'**
  String get notificationToggleFeedingSubtitle;

  /// No description provided for @notificationSectionHowToAlert.
  ///
  /// In en, this message translates to:
  /// **'How to Alert'**
  String get notificationSectionHowToAlert;

  /// No description provided for @notificationToggleSms.
  ///
  /// In en, this message translates to:
  /// **'SMS Messages'**
  String get notificationToggleSms;

  /// No description provided for @notificationToggleSmsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get alerts via SMS'**
  String get notificationToggleSmsSubtitle;

  /// No description provided for @notificationToggleSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get notificationToggleSound;

  /// No description provided for @notificationToggleSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play alert sound'**
  String get notificationToggleSoundSubtitle;

  /// No description provided for @notificationSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get notificationSaveButton;

  /// No description provided for @notificationSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Notification settings saved!'**
  String get notificationSavedSnackbar;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Plan'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionCurrentPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Current Plan'**
  String get subscriptionCurrentPlanLabel;

  /// No description provided for @subscriptionAllPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'All Plans'**
  String get subscriptionAllPlansTitle;

  /// No description provided for @subscriptionPlanFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionPlanFree;

  /// No description provided for @subscriptionPlanFreePrice.
  ///
  /// In en, this message translates to:
  /// **'₹0'**
  String get subscriptionPlanFreePrice;

  /// No description provided for @subscriptionPlanFreePeriod.
  ///
  /// In en, this message translates to:
  /// **'Forever'**
  String get subscriptionPlanFreePeriod;

  /// No description provided for @subscriptionPlanStarter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get subscriptionPlanStarter;

  /// No description provided for @subscriptionPlanStarterPrice.
  ///
  /// In en, this message translates to:
  /// **'₹499'**
  String get subscriptionPlanStarterPrice;

  /// No description provided for @subscriptionPlanPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get subscriptionPlanPro;

  /// No description provided for @subscriptionPlanProPrice.
  ///
  /// In en, this message translates to:
  /// **'₹999'**
  String get subscriptionPlanProPrice;

  /// No description provided for @subscriptionPlanBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get subscriptionPlanBusiness;

  /// No description provided for @subscriptionPlanBusinessPrice.
  ///
  /// In en, this message translates to:
  /// **'₹2499'**
  String get subscriptionPlanBusinessPrice;

  /// No description provided for @subscriptionPlanPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get subscriptionPlanPeriodMonth;

  /// No description provided for @subscriptionCurrentPlanButton.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlanButton;

  /// No description provided for @subscriptionUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get subscriptionUpgradeButton;

  /// No description provided for @subscriptionSelectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get subscriptionSelectButton;

  /// No description provided for @subscriptionSwitchedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Switched to {planName} plan!'**
  String subscriptionSwitchedSnackbar(String planName);

  /// No description provided for @subscriptionFeature5Animals.
  ///
  /// In en, this message translates to:
  /// **'5 animals'**
  String get subscriptionFeature5Animals;

  /// No description provided for @subscriptionFeatureBasicRecords.
  ///
  /// In en, this message translates to:
  /// **'Basic records'**
  String get subscriptionFeatureBasicRecords;

  /// No description provided for @subscriptionFeatureCommunityHelp.
  ///
  /// In en, this message translates to:
  /// **'Community help'**
  String get subscriptionFeatureCommunityHelp;

  /// No description provided for @subscriptionFeature25Animals.
  ///
  /// In en, this message translates to:
  /// **'25 animals'**
  String get subscriptionFeature25Animals;

  /// No description provided for @subscriptionFeatureHealthMoney.
  ///
  /// In en, this message translates to:
  /// **'Health + Money tracking'**
  String get subscriptionFeatureHealthMoney;

  /// No description provided for @subscriptionFeatureSmsReminders.
  ///
  /// In en, this message translates to:
  /// **'SMS reminders'**
  String get subscriptionFeatureSmsReminders;

  /// No description provided for @subscriptionFeatureVetCalls3.
  ///
  /// In en, this message translates to:
  /// **'3 Vet calls/month'**
  String get subscriptionFeatureVetCalls3;

  /// No description provided for @subscriptionFeature100Animals.
  ///
  /// In en, this message translates to:
  /// **'100 animals'**
  String get subscriptionFeature100Animals;

  /// No description provided for @subscriptionFeatureAdvancedReports.
  ///
  /// In en, this message translates to:
  /// **'Advanced reports'**
  String get subscriptionFeatureAdvancedReports;

  /// No description provided for @subscriptionFeatureBreedingRecords.
  ///
  /// In en, this message translates to:
  /// **'Breeding records'**
  String get subscriptionFeatureBreedingRecords;

  /// No description provided for @subscriptionFeatureUnlimitedVetCalls.
  ///
  /// In en, this message translates to:
  /// **'Unlimited vet calls'**
  String get subscriptionFeatureUnlimitedVetCalls;

  /// No description provided for @subscriptionFeatureExportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get subscriptionFeatureExportData;

  /// No description provided for @subscriptionFeatureUnlimitedAnimals.
  ///
  /// In en, this message translates to:
  /// **'Unlimited animals'**
  String get subscriptionFeatureUnlimitedAnimals;

  /// No description provided for @subscriptionFeatureMultiFarm.
  ///
  /// In en, this message translates to:
  /// **'Multi-farm'**
  String get subscriptionFeatureMultiFarm;

  /// No description provided for @subscriptionFeatureTeamManagement.
  ///
  /// In en, this message translates to:
  /// **'Team management'**
  String get subscriptionFeatureTeamManagement;

  /// No description provided for @subscriptionFeaturePrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get subscriptionFeaturePrioritySupport;

  /// No description provided for @subscriptionFeatureCustomReports.
  ///
  /// In en, this message translates to:
  /// **'Custom reports'**
  String get subscriptionFeatureCustomReports;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get teamTitle;

  /// No description provided for @teamMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Team Members'**
  String teamMemberCount(int count);

  /// No description provided for @teamManageFarmWorkers.
  ///
  /// In en, this message translates to:
  /// **'Manage your farm workers'**
  String get teamManageFarmWorkers;

  /// No description provided for @teamRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get teamRoleOwner;

  /// No description provided for @teamRoleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get teamRoleManager;

  /// No description provided for @teamRoleStaffEdit.
  ///
  /// In en, this message translates to:
  /// **'Staff (Edit)'**
  String get teamRoleStaffEdit;

  /// No description provided for @teamRoleStaffView.
  ///
  /// In en, this message translates to:
  /// **'Staff (View)'**
  String get teamRoleStaffView;

  /// No description provided for @teamAddWorkerFab.
  ///
  /// In en, this message translates to:
  /// **'Add Worker'**
  String get teamAddWorkerFab;

  /// No description provided for @teamAddWorkerSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Worker'**
  String get teamAddWorkerSheetTitle;

  /// No description provided for @teamWorkerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get teamWorkerNameLabel;

  /// No description provided for @teamWorkerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Worker name'**
  String get teamWorkerNameHint;

  /// No description provided for @teamWorkerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get teamWorkerPhoneLabel;

  /// No description provided for @teamWorkerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'9876543210'**
  String get teamWorkerPhoneHint;

  /// No description provided for @teamWorkerRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get teamWorkerRoleLabel;

  /// No description provided for @teamWorkerAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Worker'**
  String get teamWorkerAddButton;

  /// No description provided for @teamWorkerValidationError.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please fill name and phone'**
  String get teamWorkerValidationError;

  /// No description provided for @teamWorkerAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Worker added!'**
  String get teamWorkerAddedSnackbar;

  /// No description provided for @sanitizationAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Sanitization'**
  String get sanitizationAddSheetTitle;

  /// No description provided for @sanitizationStep1Label.
  ///
  /// In en, this message translates to:
  /// **'Sanitization Date'**
  String get sanitizationStep1Label;

  /// No description provided for @sanitizationStep2Label.
  ///
  /// In en, this message translates to:
  /// **'Sanitizer Used'**
  String get sanitizationStep2Label;

  /// No description provided for @sanitizationMultiSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select — select multiple'**
  String get sanitizationMultiSelectHint;

  /// No description provided for @sanitizerBleach.
  ///
  /// In en, this message translates to:
  /// **'Bleach (Sodium Hypochlorite)'**
  String get sanitizerBleach;

  /// No description provided for @sanitizerPhenyl.
  ///
  /// In en, this message translates to:
  /// **'Phenyl'**
  String get sanitizerPhenyl;

  /// No description provided for @sanitizerDettol.
  ///
  /// In en, this message translates to:
  /// **'Dettol Antiseptic'**
  String get sanitizerDettol;

  /// No description provided for @sanitizerIodine.
  ///
  /// In en, this message translates to:
  /// **'Iodine Solution'**
  String get sanitizerIodine;

  /// No description provided for @sanitizerLime.
  ///
  /// In en, this message translates to:
  /// **'Quicklime (Chuna)'**
  String get sanitizerLime;

  /// No description provided for @sanitizerFormalin.
  ///
  /// In en, this message translates to:
  /// **'Formalin'**
  String get sanitizerFormalin;

  /// No description provided for @sanitizerPotassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium Permanganate'**
  String get sanitizerPotassium;

  /// No description provided for @sanitizerHydrogenPeroxide.
  ///
  /// In en, this message translates to:
  /// **'Hydrogen Peroxide'**
  String get sanitizerHydrogenPeroxide;

  /// No description provided for @sanitizerVirkonS.
  ///
  /// In en, this message translates to:
  /// **'Virkon-S'**
  String get sanitizerVirkonS;

  /// No description provided for @sanitizationAreaFullFarm.
  ///
  /// In en, this message translates to:
  /// **'Full Farm'**
  String get sanitizationAreaFullFarm;

  /// No description provided for @sanitizationAreaCowShed.
  ///
  /// In en, this message translates to:
  /// **'Cow Shed'**
  String get sanitizationAreaCowShed;

  /// No description provided for @sanitizationAreaGoatPen.
  ///
  /// In en, this message translates to:
  /// **'Goat Pen'**
  String get sanitizationAreaGoatPen;

  /// No description provided for @sanitizationAreaPigPen.
  ///
  /// In en, this message translates to:
  /// **'Pig Pen'**
  String get sanitizationAreaPigPen;

  /// No description provided for @sanitizationAreaPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry Area'**
  String get sanitizationAreaPoultry;

  /// No description provided for @sanitizationAreaWaterTrough.
  ///
  /// In en, this message translates to:
  /// **'Water Trough'**
  String get sanitizationAreaWaterTrough;

  /// No description provided for @sanitizationAreaFeedStorage.
  ///
  /// In en, this message translates to:
  /// **'Feed Storage'**
  String get sanitizationAreaFeedStorage;

  /// No description provided for @sanitizationAreaEntryGate.
  ///
  /// In en, this message translates to:
  /// **'Entry Gate'**
  String get sanitizationAreaEntryGate;

  /// No description provided for @vetDashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get vetDashboardGreeting;

  /// Default specialization label if vet has none set
  ///
  /// In en, this message translates to:
  /// **'Veterinary Specialist'**
  String get vetDashboardSpecialization;

  /// No description provided for @vetDashboardStatReferredFarms.
  ///
  /// In en, this message translates to:
  /// **'Referred Farms'**
  String get vetDashboardStatReferredFarms;

  /// No description provided for @vetDashboardStatTotalAnimals.
  ///
  /// In en, this message translates to:
  /// **'Total Animals'**
  String get vetDashboardStatTotalAnimals;

  /// No description provided for @vetDashboardStatActiveCases.
  ///
  /// In en, this message translates to:
  /// **'Active Cases'**
  String get vetDashboardStatActiveCases;

  /// No description provided for @vetDashboardStatMonthlyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get vetDashboardStatMonthlyEarnings;

  /// No description provided for @vetDashboardQuickActionNewVisit.
  ///
  /// In en, this message translates to:
  /// **'New Visit'**
  String get vetDashboardQuickActionNewVisit;

  /// No description provided for @vetDashboardQuickActionRecordHealth.
  ///
  /// In en, this message translates to:
  /// **'Record Health'**
  String get vetDashboardQuickActionRecordHealth;

  /// No description provided for @vetDashboardQuickActionMyFarms.
  ///
  /// In en, this message translates to:
  /// **'My Farms'**
  String get vetDashboardQuickActionMyFarms;

  /// No description provided for @vetDashboardQuickActionEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get vetDashboardQuickActionEarnings;

  /// No description provided for @vetDashboardMotivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Great work this week!'**
  String get vetDashboardMotivationTitle;

  /// No description provided for @vetDashboardMotivationBody.
  ///
  /// In en, this message translates to:
  /// **'You completed 14 consultations — 40% more than last week.'**
  String get vetDashboardMotivationBody;

  /// No description provided for @vetDashboardRecentConsultations.
  ///
  /// In en, this message translates to:
  /// **'Recent Consultations'**
  String get vetDashboardRecentConsultations;

  /// No description provided for @vetDashboardUpcomingVisits.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Visits'**
  String get vetDashboardUpcomingVisits;

  /// No description provided for @vetConsultationsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Consultations'**
  String get vetConsultationsTitle;

  /// No description provided for @vetConsultationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search diagnosis or treatment...'**
  String get vetConsultationsSearchHint;

  /// No description provided for @vetConsultationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get vetConsultationsFilterAll;

  /// No description provided for @vetConsultationsFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vetConsultationsFilterActive;

  /// No description provided for @vetConsultationsFilterFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get vetConsultationsFilterFollowUp;

  /// No description provided for @vetConsultationsFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get vetConsultationsFilterCompleted;

  /// e.g. '3 records' or '1 record'
  ///
  /// In en, this message translates to:
  /// **'{count} record{suffix}'**
  String vetConsultationsRecordCount(int count, String suffix);

  /// No description provided for @vetConsultationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No consultations match your filter.'**
  String get vetConsultationsEmpty;

  /// No description provided for @vetConsultationStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vetConsultationStatusActive;

  /// No description provided for @vetConsultationStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get vetConsultationStatusCompleted;

  /// No description provided for @vetConsultationStatusFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get vetConsultationStatusFollowUp;

  /// No description provided for @vetConsultationFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow-up: {date}'**
  String vetConsultationFollowUpLabel(String date);

  /// No description provided for @vetConsultationWithdrawalLabel.
  ///
  /// In en, this message translates to:
  /// **'WD: {days}d'**
  String vetConsultationWithdrawalLabel(int days);

  /// No description provided for @vetFarmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Referred Farms'**
  String get vetFarmsTitle;

  /// No description provided for @vetFarmsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search farms...'**
  String get vetFarmsSearchHint;

  /// No description provided for @vetFarmsAnimalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} animals'**
  String vetFarmsAnimalCount(int count);

  /// No description provided for @vetFarmsViewAnimalsButton.
  ///
  /// In en, this message translates to:
  /// **'View Animals'**
  String get vetFarmsViewAnimalsButton;

  /// No description provided for @vetScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Schedule'**
  String get vetScheduleTitle;

  /// No description provided for @vetScheduleSectionVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits & Events'**
  String get vetScheduleSectionVisits;

  /// No description provided for @vetScheduleSectionVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Pending Vaccinations'**
  String get vetScheduleSectionVaccinations;

  /// No description provided for @vetEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get vetEarningsTitle;

  /// No description provided for @vetEarningsStatThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get vetEarningsStatThisMonth;

  /// No description provided for @vetEarningsStatTotalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total Earned'**
  String get vetEarningsStatTotalEarned;

  /// No description provided for @vetEarningsStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get vetEarningsStatPending;

  /// No description provided for @vetEarningsStatCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission %'**
  String get vetEarningsStatCommission;

  /// No description provided for @vetEarningsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get vetEarningsChartTitle;

  /// No description provided for @vetEarningsCommissionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Commission Breakdown'**
  String get vetEarningsCommissionBreakdown;

  /// No description provided for @vetEarningsBarConsults.
  ///
  /// In en, this message translates to:
  /// **'Consults'**
  String get vetEarningsBarConsults;

  /// No description provided for @vetEarningsBarReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get vetEarningsBarReferrals;

  /// No description provided for @vetEarningsBarVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vetEarningsBarVaccinations;

  /// No description provided for @vetEarningsBarTreatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get vetEarningsBarTreatments;

  /// No description provided for @vetEarningsBarProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get vetEarningsBarProducts;

  /// No description provided for @vetEarningsPayoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Payout History'**
  String get vetEarningsPayoutHistory;

  /// No description provided for @vetEarningsPayoutStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get vetEarningsPayoutStatusPaid;

  /// No description provided for @vetEarningsPayoutPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on {date}'**
  String vetEarningsPayoutPaidOn(String date);

  /// No description provided for @vetAnimalHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal Health'**
  String get vetAnimalHealthTitle;

  /// No description provided for @vetAnimalHealthTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get vetAnimalHealthTabOverview;

  /// No description provided for @vetAnimalHealthTabRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get vetAnimalHealthTabRecords;

  /// No description provided for @vetAnimalHealthTabVaccines.
  ///
  /// In en, this message translates to:
  /// **'Vaccines'**
  String get vetAnimalHealthTabVaccines;

  /// No description provided for @vetAnimalHealthTabConsult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get vetAnimalHealthTabConsult;

  /// No description provided for @vetAnimalHealthSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Summary'**
  String get vetAnimalHealthSummaryTitle;

  /// No description provided for @vetAnimalHealthStatTotalAnimals.
  ///
  /// In en, this message translates to:
  /// **'Total Animals'**
  String get vetAnimalHealthStatTotalAnimals;

  /// No description provided for @vetAnimalHealthStatSickTreating.
  ///
  /// In en, this message translates to:
  /// **'Sick / Treating'**
  String get vetAnimalHealthStatSickTreating;

  /// No description provided for @vetAnimalHealthStatVaccinesOverdue.
  ///
  /// In en, this message translates to:
  /// **'Vaccines Overdue'**
  String get vetAnimalHealthStatVaccinesOverdue;

  /// No description provided for @vetAnimalHealthStatUrgentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Urgent Alerts'**
  String get vetAnimalHealthStatUrgentAlerts;

  /// No description provided for @vetAnimalHealthStatAllClear.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get vetAnimalHealthStatAllClear;

  /// No description provided for @vetAnimalHealthQuickActionNewConsult.
  ///
  /// In en, this message translates to:
  /// **'New Consult'**
  String get vetAnimalHealthQuickActionNewConsult;

  /// No description provided for @vetAnimalHealthQuickActionLogVaccine.
  ///
  /// In en, this message translates to:
  /// **'Log Vaccine'**
  String get vetAnimalHealthQuickActionLogVaccine;

  /// No description provided for @vetAnimalHealthQuickActionLabReport.
  ///
  /// In en, this message translates to:
  /// **'Lab Report'**
  String get vetAnimalHealthQuickActionLabReport;

  /// No description provided for @vetFarmDetailTabAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get vetFarmDetailTabAnimals;

  /// No description provided for @vetFarmDetailTabTreatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get vetFarmDetailTabTreatments;

  /// No description provided for @vetFarmDetailTabVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vetFarmDetailTabVaccinations;

  /// Small label below animal count in farm detail header
  ///
  /// In en, this message translates to:
  /// **'animals'**
  String get vetFarmDetailAnimalsLabel;

  /// No description provided for @vetFarmDetailNoAnimals.
  ///
  /// In en, this message translates to:
  /// **'No animals recorded for this farm.'**
  String get vetFarmDetailNoAnimals;

  /// No description provided for @vetFarmDetailNoTreatments.
  ///
  /// In en, this message translates to:
  /// **'No treatment records for this farm.'**
  String get vetFarmDetailNoTreatments;

  /// No description provided for @shopHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Rumeno Shop'**
  String get shopHomeTitle;

  /// No description provided for @shopSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get shopSearchHint;

  /// No description provided for @shopCategoriesSection.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get shopCategoriesSection;

  /// No description provided for @shopCategoryFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get shopCategoryFeed;

  /// No description provided for @shopCategoryTonic.
  ///
  /// In en, this message translates to:
  /// **'Tonic'**
  String get shopCategoryTonic;

  /// No description provided for @shopCategoryMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get shopCategoryMedicine;

  /// No description provided for @shopCategoryTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get shopCategoryTools;

  /// No description provided for @shopCategorySupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get shopCategorySupplements;

  /// No description provided for @shopCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shopCategoryAll;

  /// Display name for ProductCategory.animalFeed in category screen
  ///
  /// In en, this message translates to:
  /// **'Animal Feed'**
  String get shopCategoryAnimalFeed;

  /// No description provided for @shopBannerFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'FREE Delivery'**
  String get shopBannerFreeDelivery;

  /// No description provided for @shopBannerFreeDeliveryCondition.
  ///
  /// In en, this message translates to:
  /// **'On orders above ₹999'**
  String get shopBannerFreeDeliveryCondition;

  /// No description provided for @shopBannerCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Code: WELCOME20'**
  String get shopBannerCouponCode;

  /// No description provided for @shopCouponCopiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Coupon code WELCOME20 copied!'**
  String get shopCouponCopiedSnackbar;

  /// No description provided for @shopBestProductsSection.
  ///
  /// In en, this message translates to:
  /// **'Best Products'**
  String get shopBestProductsSection;

  /// No description provided for @shopAllProductsSection.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get shopAllProductsSection;

  /// No description provided for @shopSearchAnimalFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Animals'**
  String get shopSearchAnimalFilterAll;

  /// No description provided for @shopSearchAnimalFilterCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get shopSearchAnimalFilterCattle;

  /// No description provided for @shopSearchAnimalFilterGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get shopSearchAnimalFilterGoat;

  /// No description provided for @shopSearchAnimalFilterSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get shopSearchAnimalFilterSheep;

  /// No description provided for @shopSearchAnimalFilterPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get shopSearchAnimalFilterPoultry;

  /// No description provided for @shopSearchAnimalFilterPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get shopSearchAnimalFilterPig;

  /// No description provided for @shopSearchAnimalFilterHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get shopSearchAnimalFilterHorse;

  /// No description provided for @shopSearchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products found'**
  String shopSearchResultCount(int count);

  /// No description provided for @shopSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get shopSearchNoResults;

  /// No description provided for @shopCategoryNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get shopCategoryNoProducts;

  /// No description provided for @shopOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get shopOutOfStock;

  /// No description provided for @shopInStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get shopInStock;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @productAddedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to wishlist!'**
  String get productAddedToWishlist;

  /// No description provided for @productRemovedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get productRemovedFromWishlist;

  /// No description provided for @productShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Share link copied to clipboard!'**
  String get productShareCopied;

  /// No description provided for @productRumenoBadge.
  ///
  /// In en, this message translates to:
  /// **'Rumeno Product'**
  String get productRumenoBadge;

  /// No description provided for @productOffBadge.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String productOffBadge(int percent);

  /// No description provided for @productMrpLabel.
  ///
  /// In en, this message translates to:
  /// **'MRP ₹{price}'**
  String productMrpLabel(String price);

  /// No description provided for @productSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save ₹{amount}'**
  String productSaveLabel(String amount);

  /// No description provided for @productTaxIncluded.
  ///
  /// In en, this message translates to:
  /// **'(Inclusive of all taxes)'**
  String get productTaxIncluded;

  /// No description provided for @productUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit: {unit}'**
  String productUnitLabel(String unit);

  /// No description provided for @productTrustFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery\n₹999+'**
  String get productTrustFreeDelivery;

  /// No description provided for @productTrustGenuine.
  ///
  /// In en, this message translates to:
  /// **'100% Genuine\nOriginal Product'**
  String get productTrustGenuine;

  /// No description provided for @productTrustEasyReturn.
  ///
  /// In en, this message translates to:
  /// **'Easy Return\n7 Day Policy'**
  String get productTrustEasyReturn;

  /// No description provided for @productDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescriptionLabel;

  /// No description provided for @productWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get productWatchVideo;

  /// No description provided for @productVideoOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open video'**
  String get productVideoOpenError;

  /// No description provided for @productReviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews ({count})'**
  String productReviewsLabel(int count);

  /// No description provided for @productNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get productNoReviews;

  /// No description provided for @productAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get productAddToCart;

  /// No description provided for @productInCart.
  ///
  /// In en, this message translates to:
  /// **'In Cart ✓'**
  String get productInCart;

  /// No description provided for @productBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get productBuyNow;

  /// No description provided for @productAddedToCartSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart!'**
  String productAddedToCartSnackbar(String productName);

  /// No description provided for @cartViewCartSnackbarAction.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get cartViewCartSnackbarAction;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart ({count})'**
  String cartTitle(int count);

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add products to get started'**
  String get cartEmptySubtitle;

  /// No description provided for @cartStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get cartStartShopping;

  /// No description provided for @cartItemRemovedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{productName} removed'**
  String cartItemRemovedSnackbar(String productName);

  /// No description provided for @cartSavingsLabel.
  ///
  /// In en, this message translates to:
  /// **'You save ₹{amount}'**
  String cartSavingsLabel(String amount);

  /// No description provided for @cartRemoveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemoveCoupon;

  /// No description provided for @cartApplyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get cartApplyCoupon;

  /// No description provided for @cartCouponDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get cartCouponDialogTitle;

  /// No description provided for @cartCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Coupon code here...'**
  String get cartCouponHint;

  /// No description provided for @cartCouponApplyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartCouponApplyButton;

  /// No description provided for @cartAvailableCoupons.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartAvailableCoupons;

  /// No description provided for @cartAvailableCouponsHeader.
  ///
  /// In en, this message translates to:
  /// **'Available Coupons:'**
  String get cartAvailableCouponsHeader;

  /// No description provided for @cartCouponWelcome20Desc.
  ///
  /// In en, this message translates to:
  /// **'20% off (max ₹200)'**
  String get cartCouponWelcome20Desc;

  /// No description provided for @cartCouponWelcome20Condition.
  ///
  /// In en, this message translates to:
  /// **'Min order: ₹500'**
  String get cartCouponWelcome20Condition;

  /// No description provided for @cartCouponFlat100Desc.
  ///
  /// In en, this message translates to:
  /// **'₹100 off'**
  String get cartCouponFlat100Desc;

  /// No description provided for @cartCouponFlat100Condition.
  ///
  /// In en, this message translates to:
  /// **'Min order: ₹999'**
  String get cartCouponFlat100Condition;

  /// No description provided for @cartCouponFeed15Desc.
  ///
  /// In en, this message translates to:
  /// **'15% off on feed (max ₹500)'**
  String get cartCouponFeed15Desc;

  /// No description provided for @cartCouponFeed15Condition.
  ///
  /// In en, this message translates to:
  /// **'Min order: ₹1500'**
  String get cartCouponFeed15Condition;

  /// No description provided for @cartCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied!'**
  String get cartCouponApplied;

  /// No description provided for @cartSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotalLabel;

  /// No description provided for @cartDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscountLabel;

  /// No description provided for @cartDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get cartDeliveryLabel;

  /// No description provided for @cartTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotalLabel;

  /// No description provided for @cartCheckoutButton.
  ///
  /// In en, this message translates to:
  /// **'Checkout ₹{amount}'**
  String cartCheckoutButton(String amount);

  /// No description provided for @cartLoginToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Login to Checkout'**
  String get cartLoginToCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get checkoutCartEmpty;

  /// No description provided for @checkoutStepAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkoutStepAddress;

  /// No description provided for @checkoutStepPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutStepPayment;

  /// No description provided for @checkoutStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get checkoutStepConfirm;

  /// No description provided for @checkoutDeliveryAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get checkoutDeliveryAddressTitle;

  /// No description provided for @checkoutAddDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Add delivery address'**
  String get checkoutAddDeliveryAddress;

  /// No description provided for @checkoutAddNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get checkoutAddNewAddress;

  /// No description provided for @checkoutOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkoutOrderSummary;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutPaymentUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get checkoutPaymentUpi;

  /// No description provided for @checkoutPaymentUpiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Google Pay, PhonePe, Paytm'**
  String get checkoutPaymentUpiSubtitle;

  /// No description provided for @checkoutPaymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get checkoutPaymentCard;

  /// No description provided for @checkoutPaymentCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get checkoutPaymentCardSubtitle;

  /// No description provided for @checkoutPaymentNetBanking.
  ///
  /// In en, this message translates to:
  /// **'Net Banking'**
  String get checkoutPaymentNetBanking;

  /// No description provided for @checkoutPaymentNetBankingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All major banks'**
  String get checkoutPaymentNetBankingSubtitle;

  /// No description provided for @checkoutPaymentCod.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get checkoutPaymentCod;

  /// No description provided for @checkoutPaymentCodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay when delivered'**
  String get checkoutPaymentCodSubtitle;

  /// No description provided for @checkoutAddAddressFirst.
  ///
  /// In en, this message translates to:
  /// **'Add Address First'**
  String get checkoutAddAddressFirst;

  /// No description provided for @checkoutPayButton.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{amount}'**
  String checkoutPayButton(String amount);

  /// No description provided for @checkoutAddAddressDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get checkoutAddAddressDialogTitle;

  /// No description provided for @checkoutAddressFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get checkoutAddressFullName;

  /// No description provided for @checkoutAddressPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get checkoutAddressPhone;

  /// No description provided for @checkoutAddressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkoutAddressLine1;

  /// No description provided for @checkoutAddressLandmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get checkoutAddressLandmark;

  /// No description provided for @checkoutAddressCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutAddressCity;

  /// No description provided for @checkoutAddressState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get checkoutAddressState;

  /// No description provided for @checkoutAddressPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get checkoutAddressPincode;

  /// No description provided for @checkoutAddressFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get checkoutAddressFillAllFields;

  /// No description provided for @checkoutSaveAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get checkoutSaveAddressButton;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get ordersEmpty;

  /// No description provided for @ordersStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get ordersStartShopping;

  /// No description provided for @orderProgressPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderProgressPlaced;

  /// No description provided for @orderProgressPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderProgressPacked;

  /// No description provided for @orderProgressShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderProgressShipped;

  /// No description provided for @orderProgressDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderProgressDelivered;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusPacked.
  ///
  /// In en, this message translates to:
  /// **'PACKED'**
  String get orderStatusPacked;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'SHIPPED'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'DELIVERED'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusReturned.
  ///
  /// In en, this message translates to:
  /// **'RETURNED'**
  String get orderStatusReturned;

  /// No description provided for @orderMoreItems.
  ///
  /// In en, this message translates to:
  /// **'+{count} more items'**
  String orderMoreItems(int count);

  /// No description provided for @orderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get orderTotalLabel;

  /// No description provided for @orderViewDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get orderViewDetailsButton;

  /// No description provided for @orderInvoiceButton.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get orderInvoiceButton;

  /// No description provided for @orderTrackingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Tracking will be updated soon'**
  String get orderTrackingComingSoon;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderId}'**
  String orderDetailTitle(String orderId);

  /// No description provided for @orderDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderDetailNotFound;

  /// No description provided for @orderDetailViewInvoiceTooltip.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get orderDetailViewInvoiceTooltip;

  /// No description provided for @orderDetailStatusCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderDetailStatusCardTitle;

  /// No description provided for @orderDetailTimelinePlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderDetailTimelinePlaced;

  /// No description provided for @orderDetailTimelineConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderDetailTimelineConfirmed;

  /// No description provided for @orderDetailTimelineConfirmedDesc.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get orderDetailTimelineConfirmedDesc;

  /// No description provided for @orderDetailTimelinePacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderDetailTimelinePacked;

  /// No description provided for @orderDetailTimelineShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderDetailTimelineShipped;

  /// No description provided for @orderDetailTimelineShippedTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking: {trackingId}'**
  String orderDetailTimelineShippedTracking(String trackingId);

  /// No description provided for @orderDetailTimelineDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderDetailTimelineDelivered;

  /// No description provided for @orderDetailTimelinePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderDetailTimelinePending;

  /// No description provided for @orderDetailItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String orderDetailItemsLabel(int count);

  /// No description provided for @orderDetailEachLabel.
  ///
  /// In en, this message translates to:
  /// **'₹{price} each'**
  String orderDetailEachLabel(String price);

  /// No description provided for @orderDetailDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get orderDetailDeliveryAddress;

  /// No description provided for @orderDetailPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get orderDetailPaymentTitle;

  /// No description provided for @orderDetailPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get orderDetailPaymentMethod;

  /// No description provided for @orderDetailPaymentId.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get orderDetailPaymentId;

  /// No description provided for @orderDetailSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get orderDetailSubtotal;

  /// No description provided for @orderDetailDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get orderDetailDiscount;

  /// No description provided for @orderDetailDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get orderDetailDelivery;

  /// No description provided for @orderDetailTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get orderDetailTotalPaid;

  /// No description provided for @orderDetailReorderButton.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get orderDetailReorderButton;

  /// No description provided for @orderDetailItemsAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Items added to cart'**
  String get orderDetailItemsAddedToCart;

  /// No description provided for @shopAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get shopAccountTitle;

  /// No description provided for @shopAccountMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get shopAccountMyOrders;

  /// No description provided for @shopAccountSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get shopAccountSavedAddresses;

  /// No description provided for @shopAccountWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get shopAccountWishlist;

  /// No description provided for @shopAccountFarmManagement.
  ///
  /// In en, this message translates to:
  /// **'Livestock Farm Management'**
  String get shopAccountFarmManagement;

  /// No description provided for @shopAccountSwitchToVet.
  ///
  /// In en, this message translates to:
  /// **'Switch to Vet'**
  String get shopAccountSwitchToVet;

  /// No description provided for @shopAccountBecomeVendor.
  ///
  /// In en, this message translates to:
  /// **'Become a Vendor'**
  String get shopAccountBecomeVendor;

  /// No description provided for @shopAccountHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get shopAccountHelpSupport;

  /// No description provided for @shopAccountAbout.
  ///
  /// In en, this message translates to:
  /// **'About Rumeno'**
  String get shopAccountAbout;

  /// No description provided for @shopAccountLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get shopAccountLogout;

  /// No description provided for @shopAccountLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get shopAccountLogoutDialogTitle;

  /// No description provided for @shopAccountLogoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get shopAccountLogoutDialogMessage;

  /// No description provided for @shopAccountSavedAddressesSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get shopAccountSavedAddressesSheetTitle;

  /// No description provided for @shopAccountNoAddresses.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get shopAccountNoAddresses;

  /// No description provided for @shopAccountDefaultAddressBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get shopAccountDefaultAddressBadge;

  /// No description provided for @shopAccountWishlistSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get shopAccountWishlistSheetTitle;

  /// No description provided for @shopAccountNoWishlistItems.
  ///
  /// In en, this message translates to:
  /// **'No wishlist items'**
  String get shopAccountNoWishlistItems;

  /// No description provided for @shopAccountAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get shopAccountAddedToCart;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID: {orderId}'**
  String orderSuccessOrderId(String orderId);

  /// No description provided for @orderSuccessConfirmationPrompt.
  ///
  /// In en, this message translates to:
  /// **'You will receive confirmation shortly'**
  String get orderSuccessConfirmationPrompt;

  /// No description provided for @orderSuccessDeliveryUpdates.
  ///
  /// In en, this message translates to:
  /// **'Delivery updates will be sent'**
  String get orderSuccessDeliveryUpdates;

  /// No description provided for @orderSuccessTrackButton.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get orderSuccessTrackButton;

  /// No description provided for @orderSuccessContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get orderSuccessContinueButton;

  /// No description provided for @vendorRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor Registration'**
  String get vendorRegisterTitle;

  /// No description provided for @vendorRegisterStep1.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get vendorRegisterStep1;

  /// No description provided for @vendorRegisterStep2.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get vendorRegisterStep2;

  /// No description provided for @vendorRegisterStep3.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get vendorRegisterStep3;

  /// No description provided for @vendorRegisterStep4.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get vendorRegisterStep4;

  /// No description provided for @vendorRegisterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name *'**
  String get vendorRegisterBusinessName;

  /// No description provided for @vendorRegisterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name *'**
  String get vendorRegisterOwnerName;

  /// No description provided for @vendorRegisterPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get vendorRegisterPhone;

  /// No description provided for @vendorRegisterEmail.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get vendorRegisterEmail;

  /// No description provided for @vendorRegisterGst.
  ///
  /// In en, this message translates to:
  /// **'GST Number *'**
  String get vendorRegisterGst;

  /// No description provided for @vendorRegisterPan.
  ///
  /// In en, this message translates to:
  /// **'PAN Number *'**
  String get vendorRegisterPan;

  /// No description provided for @vendorRegisterUploadIdProof.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Proof'**
  String get vendorRegisterUploadIdProof;

  /// No description provided for @vendorRegisterBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name *'**
  String get vendorRegisterBankName;

  /// No description provided for @vendorRegisterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number *'**
  String get vendorRegisterAccountNumber;

  /// No description provided for @vendorRegisterIfsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code *'**
  String get vendorRegisterIfsc;

  /// No description provided for @vendorRegisterBusinessAddress.
  ///
  /// In en, this message translates to:
  /// **'Business Address *'**
  String get vendorRegisterBusinessAddress;

  /// No description provided for @vendorRegisterCity.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get vendorRegisterCity;

  /// No description provided for @vendorRegisterState.
  ///
  /// In en, this message translates to:
  /// **'State *'**
  String get vendorRegisterState;

  /// No description provided for @vendorRegisterPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode *'**
  String get vendorRegisterPincode;

  /// No description provided for @vendorRegisterContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get vendorRegisterContinueButton;

  /// No description provided for @vendorRegisterSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get vendorRegisterSubmitButton;

  /// No description provided for @vendorRegisterSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted'**
  String get vendorRegisterSuccessTitle;

  /// No description provided for @vendorRegisterSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your vendor registration has been submitted for review. Our team will verify your documents and approve your account within 2-3 business days. You will be notified via email.'**
  String get vendorRegisterSuccessMessage;

  /// Farmer bottom nav – Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get navAnimals;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// Vet bottom nav – Dashboard tab
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navVetDashboard;

  /// No description provided for @navVetFarms.
  ///
  /// In en, this message translates to:
  /// **'Farms'**
  String get navVetFarms;

  /// No description provided for @navVetHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navVetHealth;

  /// No description provided for @navVetEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navVetEarnings;

  /// Shop bottom nav – Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navShopHome;

  /// No description provided for @navShopSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navShopSearch;

  /// No description provided for @navShopCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navShopCart;

  /// No description provided for @navShopOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navShopOrders;

  /// No description provided for @navShopAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navShopAccount;

  /// No description provided for @commonOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get commonOverdue;

  /// No description provided for @commonDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get commonDue;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get commonDueSoon;

  /// No description provided for @commonOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get commonOngoing;

  /// No description provided for @commonResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get commonResolved;

  /// No description provided for @commonPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get commonPriority;

  /// No description provided for @commonNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get commonNotifications;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get commonCompleted;

  /// No description provided for @commonFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get commonFollowUp;

  /// No description provided for @commonQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get commonQuickActions;

  /// No description provided for @vetDashboardScheduleVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule New Visit'**
  String get vetDashboardScheduleVisitTitle;

  /// No description provided for @vetDashboardScheduleVisitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the 4 simple steps below'**
  String get vetDashboardScheduleVisitSubtitle;

  /// No description provided for @vetDashboardScheduleFarm.
  ///
  /// In en, this message translates to:
  /// **'Choose Farm'**
  String get vetDashboardScheduleFarm;

  /// No description provided for @vetDashboardScheduleWhenToVisit.
  ///
  /// In en, this message translates to:
  /// **'When to Visit?'**
  String get vetDashboardScheduleWhenToVisit;

  /// No description provided for @vetDashboardScheduleReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for Visit'**
  String get vetDashboardScheduleReason;

  /// No description provided for @vetDashboardScheduleNotes.
  ///
  /// In en, this message translates to:
  /// **'Extra Notes (Optional)'**
  String get vetDashboardScheduleNotes;

  /// No description provided for @vetDashboardScheduleNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or observations…'**
  String get vetDashboardScheduleNotesHint;

  /// No description provided for @vetDashboardScheduleButton.
  ///
  /// In en, this message translates to:
  /// **'Schedule Visit'**
  String get vetDashboardScheduleButton;

  /// No description provided for @vetDashboardScheduleSelectFarmError.
  ///
  /// In en, this message translates to:
  /// **'Please select a farm'**
  String get vetDashboardScheduleSelectFarmError;

  /// No description provided for @vetDashboardScheduleSelectReasonError.
  ///
  /// In en, this message translates to:
  /// **'Please select the reason for visit'**
  String get vetDashboardScheduleSelectReasonError;

  /// No description provided for @vetDashboardScheduleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Visit scheduled successfully!'**
  String get vetDashboardScheduleSuccess;

  /// No description provided for @vetDashboardTapToChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Tap to change date'**
  String get vetDashboardTapToChangeDate;

  /// No description provided for @vetDashboardVisitPurposeCheckup.
  ///
  /// In en, this message translates to:
  /// **'Checkup'**
  String get vetDashboardVisitPurposeCheckup;

  /// No description provided for @vetDashboardVisitPurposeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vetDashboardVisitPurposeVaccination;

  /// No description provided for @vetDashboardVisitPurposeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get vetDashboardVisitPurposeTreatment;

  /// No description provided for @vetDashboardVisitPurposeEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get vetDashboardVisitPurposeEmergency;

  /// No description provided for @vetDashboardVisitPurposePregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get vetDashboardVisitPurposePregnancy;

  /// No description provided for @vetDashboardVisitPurposeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vetDashboardVisitPurposeOther;

  /// No description provided for @vetAnimalHealthNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No records for this filter'**
  String get vetAnimalHealthNoRecords;

  /// No description provided for @vetAnimalHealthHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get vetAnimalHealthHideDetails;

  /// No description provided for @vetAnimalHealthViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get vetAnimalHealthViewDetails;

  /// No description provided for @vetAnimalHealthDetailTreatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get vetAnimalHealthDetailTreatmentLabel;

  /// No description provided for @vetAnimalHealthDetailVetLabel.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get vetAnimalHealthDetailVetLabel;

  /// No description provided for @vetAnimalHealthDetailWithdrawalLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get vetAnimalHealthDetailWithdrawalLabel;

  /// No description provided for @vetAnimalHealthDetailEndedLabel.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get vetAnimalHealthDetailEndedLabel;

  /// No description provided for @vetAnimalHealthWithdrawalDays.
  ///
  /// In en, this message translates to:
  /// **' days (no milk/meat)'**
  String get vetAnimalHealthWithdrawalDays;

  /// No description provided for @vetAnimalHealthConsultTitle.
  ///
  /// In en, this message translates to:
  /// **'New Consultation'**
  String get vetAnimalHealthConsultTitle;

  /// No description provided for @vetAnimalHealthConsultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the animal health details below'**
  String get vetAnimalHealthConsultSubtitle;

  /// No description provided for @vetAnimalHealthConsultStepSelectAnimal.
  ///
  /// In en, this message translates to:
  /// **'Select Animal'**
  String get vetAnimalHealthConsultStepSelectAnimal;

  /// No description provided for @vetAnimalHealthConsultStepSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms  (tap to select)'**
  String get vetAnimalHealthConsultStepSymptoms;

  /// No description provided for @vetAnimalHealthConsultStepDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis & Treatment'**
  String get vetAnimalHealthConsultStepDiagnosis;

  /// No description provided for @vetAnimalHealthConsultDiagnosisLabel.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis *'**
  String get vetAnimalHealthConsultDiagnosisLabel;

  /// No description provided for @vetAnimalHealthConsultDiagnosisHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Foot Rot, Mastitis'**
  String get vetAnimalHealthConsultDiagnosisHint;

  /// No description provided for @vetAnimalHealthConsultTreatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment Prescribed'**
  String get vetAnimalHealthConsultTreatmentLabel;

  /// No description provided for @vetAnimalHealthConsultTreatmentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Oxytetracycline 5mg/kg IM'**
  String get vetAnimalHealthConsultTreatmentHint;

  /// No description provided for @vetAnimalHealthConsultMedicinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicines / Injections'**
  String get vetAnimalHealthConsultMedicinesLabel;

  /// No description provided for @vetAnimalHealthConsultMedicinesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Penicilin, Ivermectin'**
  String get vetAnimalHealthConsultMedicinesHint;

  /// No description provided for @vetAnimalHealthConsultNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional observations...'**
  String get vetAnimalHealthConsultNotesHint;

  /// No description provided for @vetAnimalHealthConsultStepFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Schedule'**
  String get vetAnimalHealthConsultStepFollowUp;

  /// No description provided for @vetAnimalHealthConsultFollowUpNone.
  ///
  /// In en, this message translates to:
  /// **'No follow-up'**
  String get vetAnimalHealthConsultFollowUpNone;

  /// No description provided for @vetAnimalHealthConsultFollowUp3Days.
  ///
  /// In en, this message translates to:
  /// **'After 3 days'**
  String get vetAnimalHealthConsultFollowUp3Days;

  /// No description provided for @vetAnimalHealthConsultFollowUp1Week.
  ///
  /// In en, this message translates to:
  /// **'After 1 week'**
  String get vetAnimalHealthConsultFollowUp1Week;

  /// No description provided for @vetAnimalHealthConsultFollowUp2Weeks.
  ///
  /// In en, this message translates to:
  /// **'After 2 weeks'**
  String get vetAnimalHealthConsultFollowUp2Weeks;

  /// No description provided for @vetAnimalHealthConsultFollowUp1Month.
  ///
  /// In en, this message translates to:
  /// **'After 1 month'**
  String get vetAnimalHealthConsultFollowUp1Month;

  /// No description provided for @vetAnimalHealthConsultSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Consultation'**
  String get vetAnimalHealthConsultSaveButton;

  /// No description provided for @vetAnimalHealthConsultErrorDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Please enter a diagnosis'**
  String get vetAnimalHealthConsultErrorDiagnosis;

  /// No description provided for @vetAnimalHealthConsultSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Consultation saved successfully!'**
  String get vetAnimalHealthConsultSaveSuccess;

  /// No description provided for @vetAnimalHealthNoVaccinations.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations here'**
  String get vetAnimalHealthNoVaccinations;

  /// No description provided for @vetAnimalHealthSymptomFever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get vetAnimalHealthSymptomFever;

  /// No description provided for @vetAnimalHealthSymptomLossOfAppetite.
  ///
  /// In en, this message translates to:
  /// **'Loss of appetite'**
  String get vetAnimalHealthSymptomLossOfAppetite;

  /// No description provided for @vetAnimalHealthSymptomLethargy.
  ///
  /// In en, this message translates to:
  /// **'Lethargy'**
  String get vetAnimalHealthSymptomLethargy;

  /// No description provided for @vetAnimalHealthSymptomLameness.
  ///
  /// In en, this message translates to:
  /// **'Lameness'**
  String get vetAnimalHealthSymptomLameness;

  /// No description provided for @vetAnimalHealthSymptomSwelling.
  ///
  /// In en, this message translates to:
  /// **'Swelling'**
  String get vetAnimalHealthSymptomSwelling;

  /// No description provided for @vetAnimalHealthSymptomDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get vetAnimalHealthSymptomDiarrhea;

  /// No description provided for @vetAnimalHealthSymptomCough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get vetAnimalHealthSymptomCough;

  /// No description provided for @vetAnimalHealthSymptomNasalDischarge.
  ///
  /// In en, this message translates to:
  /// **'Nasal discharge'**
  String get vetAnimalHealthSymptomNasalDischarge;

  /// No description provided for @vetAnimalHealthSymptomReducedMilk.
  ///
  /// In en, this message translates to:
  /// **'Reduced milk'**
  String get vetAnimalHealthSymptomReducedMilk;

  /// No description provided for @vetFarmDetailNoVaccinations.
  ///
  /// In en, this message translates to:
  /// **'No vaccination records for this farm.'**
  String get vetFarmDetailNoVaccinations;

  /// No description provided for @vetFarmDetailShed.
  ///
  /// In en, this message translates to:
  /// **'Shed'**
  String get vetFarmDetailShed;

  /// No description provided for @vetFarmDetailFollowUpDate.
  ///
  /// In en, this message translates to:
  /// **'Follow-up: {date}'**
  String vetFarmDetailFollowUpDate(String date);

  /// No description provided for @vetFarmDetailGivenDate.
  ///
  /// In en, this message translates to:
  /// **'Given: {date}'**
  String vetFarmDetailGivenDate(String date);

  /// No description provided for @vetFarmDetailDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String vetFarmDetailDueDate(String date);

  /// No description provided for @vetFarmDetailNextDate.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String vetFarmDetailNextDate(String date);

  /// No description provided for @vetAnimalHealthAlertsSection.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get vetAnimalHealthAlertsSection;

  /// No description provided for @vetAnimalHealthUpcomingEventsSection.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get vetAnimalHealthUpcomingEventsSection;

  /// No description provided for @vetAnimalHealthTreatmentStarted.
  ///
  /// In en, this message translates to:
  /// **'Started: {date}'**
  String vetAnimalHealthTreatmentStarted(String date);

  /// No description provided for @vetAnimalHealthWithdrawalValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days (no milk/meat)'**
  String vetAnimalHealthWithdrawalValue(Object days);
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
