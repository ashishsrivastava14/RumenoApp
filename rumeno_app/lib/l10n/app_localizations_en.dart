// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonView => 'View';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonGotIt => 'Got it';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSeeAll => 'See All';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonFree => 'FREE';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get commonMale => 'Male';

  @override
  String get commonFemale => 'Female';

  @override
  String get commonAll => 'All';

  @override
  String get commonSearchHint => 'Search here...';

  @override
  String get commonChooseFromGallery => 'Choose from Gallery';

  @override
  String get commonChooseFromGallerySubtitle => 'Select an existing photo';

  @override
  String get commonTakeAPhoto => 'Take a Photo';

  @override
  String get commonTakeAPhotoSubtitle => 'Use your camera';

  @override
  String get commonSelectSource => 'Select Source';

  @override
  String get commonTakePhotoOption => 'Take Photo';

  @override
  String get commonTakePhotoOptionSubtitle => 'Capture with camera';

  @override
  String get commonChooseFromGalleryOption => 'Choose from Gallery';

  @override
  String get commonChooseFromGalleryOptionSubtitle =>
      'Select an existing image';

  @override
  String get commonGivenToday => '✅  Given Today';

  @override
  String get commonScheduleLater => '📅  Schedule Later';

  @override
  String get commonAnimalIdHint => '🐄  Animal ID (e.g. C-001)';

  @override
  String get commonVetNameOptionalHint => '👨‍⚕️  Vet Name (optional)';

  @override
  String get commonSaveRecord => 'Save Record';

  @override
  String get commonDateOfBirth => 'Date of Birth';

  @override
  String get commonAnimalId => 'Animal ID';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonNotesOptionalHint => '📝  Notes (optional)';

  @override
  String get speciesCow => 'Cow';

  @override
  String get speciesBuffalo => 'Buffalo';

  @override
  String get speciesGoat => 'Goat';

  @override
  String get speciesSheep => 'Sheep';

  @override
  String get speciesPig => 'Pig';

  @override
  String get speciesHorse => 'Horse';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get ageRangeUnder1Month => 'Under 1 month';

  @override
  String get ageRange1To3Months => '1 – 3 months';

  @override
  String get ageRange3To6Months => '3 – 6 months';

  @override
  String get ageRange6To9Months => '6 – 9 months';

  @override
  String get ageRange9To12Months => '9 – 12 months';

  @override
  String get ageRange12To18Months => '12 – 18 months';

  @override
  String get ageRange18To24Months => '18 – 24 months';

  @override
  String get ageRange24PlusMonths => '24+ months';

  @override
  String get authWelcomeToRumeno => 'Welcome to Rumeno';

  @override
  String get authSelectRolePrompt => 'Select your role to get started';

  @override
  String get authRoleFarmOwner => 'Farm Owner / Staff';

  @override
  String get authRoleFarmOwnerSubtitle =>
      'Manage your farm, animals, and operations';

  @override
  String get authRoleVet => 'Veterinarian / Partner';

  @override
  String get authRoleVetSubtitle => 'Manage consultations and earn commissions';

  @override
  String get authRoleSuperAdmin => 'Super Admin';

  @override
  String get authRoleSuperAdminSubtitle =>
      'Manage platform, users, and configurations';

  @override
  String get authRoleFarmProducts => 'Farm Products';

  @override
  String get authRoleFarmProductsSubtitle =>
      'Browse and purchase farm products';

  @override
  String get loginWelcomeBack => 'Welcome Back!';

  @override
  String get loginEnterPhonePrompt => 'Enter your phone number to continue';

  @override
  String get loginPhoneLabel => 'Phone Number';

  @override
  String get loginPhonePrefix => '+91 ';

  @override
  String get loginSendOtpButton => 'Send OTP';

  @override
  String get loginEnterOtpButton => 'Enter OTP';

  @override
  String get loginOtpSentSnackbar => 'OTP sent: 1234 (mock)';

  @override
  String loginOtpPrompt(String phone) {
    return 'Enter the OTP sent to +91 $phone';
  }

  @override
  String get otpTitle => 'Verify OTP';

  @override
  String get otpSubtitle => 'Enter the 4-digit code sent to your phone';

  @override
  String otpResendTimer(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get otpResendButton => 'Resend OTP';

  @override
  String get otpVerifyLoginButton => 'Verify & Login';

  @override
  String get otpMockLabel => 'Mock OTP: 1234';

  @override
  String get otpInvalidError => 'Invalid OTP. Use 1234';

  @override
  String get otpResendSnackbar => 'OTP resent: 1234 (mock)';

  @override
  String get headerBtnVetTooltip => 'Veterinarian';

  @override
  String get headerBtnVetInfoTitle => 'Veterinarian';

  @override
  String get headerBtnVetInfoBody =>
      'Tap the icon to connect with licensed veterinarians to book appointments, request farm visits, and get expert advice on your animals\' health and treatments.';

  @override
  String get headerBtnMarketplaceTooltip => 'Marketplace';

  @override
  String get headerBtnMarketplaceInfoTitle => 'Marketplace';

  @override
  String get headerBtnMarketplaceInfoBody =>
      'Tap the icon to browse and purchase farm supplies, animal feed, medicines, and equipment. Sell your farm produce directly to buyers through the Rumeno marketplace.';

  @override
  String get headerBtnFarmTooltip => 'Farm';

  @override
  String get headerBtnFarmInfoTitle => 'Farm Dashboard';

  @override
  String get headerBtnFarmInfoBody =>
      'Tap the icon to access your Farm Management Dashboard — the central hub for all your farming activities. Manage your livestock, track individual animal health records, monitor daily milk production, schedule feeding routines, and get a complete overview of all your farm operations in one place.';

  @override
  String get dashboardGreetingMorning => 'Good Morning';

  @override
  String get dashboardGreetingAfternoon => 'Good Afternoon';

  @override
  String get dashboardGreetingEvening => 'Good Evening';

  @override
  String get dashboardAddFarmLogo => 'Add Farm Logo';

  @override
  String get dashboardSetFarmLogoTitle => 'Set Farm Logo';

  @override
  String get dashboardActiveAlerts => 'Active Alerts';

  @override
  String get dashboardUpcomingEvents => 'Upcoming Events';

  @override
  String get moreTitle => 'More';

  @override
  String get morePlanPro => 'Pro Plan';

  @override
  String get moreMyFarm => 'My Farm';

  @override
  String get moreMyFarmSubtitle => 'Farm Details';

  @override
  String get moreMyTeam => 'My Team';

  @override
  String get moreMyTeamSubtitle => 'Workers';

  @override
  String get moreMyPlan => 'My Plan';

  @override
  String get moreMyPlanSubtitle => 'Subscription';

  @override
  String get moreAlerts => 'Alerts';

  @override
  String get moreAlertsSubtitle => 'Notifications';

  @override
  String get moreLanguage => 'Language';

  @override
  String get moreLanguageSubtitle => 'भाषा बदलें';

  @override
  String get moreExport => 'Export';

  @override
  String get moreExportSubtitle => 'Save Data';

  @override
  String get moreSanitization => 'Sanitization';

  @override
  String get moreSanitizationSubtitle => 'Farm Cleaning';

  @override
  String get moreHelp => 'Help';

  @override
  String get moreHelpSubtitle => 'Support';

  @override
  String get moreLogout => 'Logout';

  @override
  String get moreLogoutSubtitle => 'Sign Out';

  @override
  String get moreVersion => 'Version 1.0.0';

  @override
  String get logoutDialogTitle => 'Logout?';

  @override
  String get logoutDialogMessage => 'Are you sure you want to sign out?';

  @override
  String get logoutDialogStay => 'No, Stay';

  @override
  String get logoutDialogConfirm => 'Yes, Logout';

  @override
  String get selectLanguageTitle => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get exportTitle => 'Export Data';

  @override
  String get exportBannerHeadline => 'Save Your Farm Data';

  @override
  String get exportBannerSubtitle => 'Select what you want to download';

  @override
  String get exportTabFarmData => 'Farm Data';

  @override
  String get exportTabSellAnimal => 'Sell Animal';

  @override
  String get exportCategoryAnimals => 'Animals';

  @override
  String get exportCategoryAnimalsDesc => 'All animal records';

  @override
  String get exportCategoryHealth => 'Health';

  @override
  String get exportCategoryHealthDesc =>
      'Vaccination, Treatment\nDeworming & Lab Reports';

  @override
  String get exportCategoryBreeding => 'Breeding';

  @override
  String get exportCategoryBreedingDesc => 'Breeding records';

  @override
  String get exportCategoryFinance => 'Finance';

  @override
  String get exportCategoryFinanceDesc => 'Income & expenses';

  @override
  String get exportCategoryMilk => 'Milk Records';

  @override
  String get exportCategoryMilkDesc => 'Daily milk data';

  @override
  String get exportCategoryTeam => 'Team';

  @override
  String get exportCategoryTeamDesc => 'Team members list';

  @override
  String get exportRecordTypeCastration => 'Castration';

  @override
  String get exportRecordTypeMortality => 'Mortality';

  @override
  String get exportRecordTypeSell => 'Sell';

  @override
  String get exportSectionDateRange => 'Date Range';

  @override
  String get exportSectionFilters => 'Filters';

  @override
  String get exportFiltersHint =>
      '👆 Tap to select filters. Leave empty = export all';

  @override
  String get exportDateSelected => 'Date Selected';

  @override
  String get exportSelectDateRange => 'Select Date Range';

  @override
  String get exportSelectDataFirst => 'Select Data First';

  @override
  String exportDownloadButton(int count) {
    return 'Download $count item(s)';
  }

  @override
  String get animalListTitle => 'My Animals';

  @override
  String get animalListSortByTag => 'Sort by Tag';

  @override
  String get animalListSortByName => 'Sort by Name';

  @override
  String get animalListSortByAge => 'Sort by Age';

  @override
  String get animalListSortByStatus => 'Sort by Status';

  @override
  String get animalListSearchHint => 'Search by tag or breed...';

  @override
  String get animalListClearAll => 'Clear all';

  @override
  String get animalListKidBannerTitle => 'Kid Management';

  @override
  String animalListKidBannerCount(int count) {
    return '$count kid(s) registered';
  }

  @override
  String animalListKidBannerNeedMedicine(int count) {
    return '⚠️ $count need medicine';
  }

  @override
  String get animalListKidBannerViewButton => 'View';

  @override
  String animalListCount(int count) {
    return '$count animals';
  }

  @override
  String get animalListAddFab => 'Add Animal';

  @override
  String get addAnimalTitle => 'Add New Animal';

  @override
  String get addAnimalStep1Title => 'Which Animal?';

  @override
  String get addAnimalStep1Subtitle => 'Type & basic info';

  @override
  String get addAnimalStep2Title => 'How it looks?';

  @override
  String get addAnimalStep2Subtitle => 'Size & color';

  @override
  String get addAnimalStep3Title => 'Family';

  @override
  String get addAnimalStep3Subtitle => 'Parents (optional)';

  @override
  String get addAnimalStep4Title => 'Where it lives?';

  @override
  String get addAnimalStep4Subtitle => 'Shed & purpose';

  @override
  String get addAnimalStep5Title => 'Purchase';

  @override
  String get addAnimalStep5Subtitle => 'Optional';

  @override
  String get addAnimalTypeLabel => '🐄  Type of Animal';

  @override
  String get addAnimalGenderLabel => '⚥  Gender';

  @override
  String get addAnimalBreedLabel => '🌱  Breed';

  @override
  String get addAnimalDobLabel => '🎂  Date of Birth';

  @override
  String get addAnimalTagLabel => '🏷️  Tag ID';

  @override
  String get addAnimalBreedHint => 'e.g. Holstein, Gir, Murrah…';

  @override
  String get addAnimalAutoGenerateTag => 'Auto-generate Tag ID';

  @override
  String get addAnimalAutoGenerateTagSubtitle =>
      'System assigns a unique number';

  @override
  String get addAnimalCustomTagLabel => 'Custom Tag ID';

  @override
  String get addAnimalCustomTagHint => 'e.g. C-010';

  @override
  String get addAnimalStep2Header => 'How does it look?';

  @override
  String get addAnimalStep2HeaderSubtitle => 'Size, weight and appearance';

  @override
  String get addAnimalWeightLabel => '⚖️  Weight';

  @override
  String get addAnimalHeightLabel => '📏  Height';

  @override
  String get addAnimalColorLabel => '🎨  Color / Markings';

  @override
  String get addAnimalPhotoLabel => '📸  Animal Photo';

  @override
  String get addAnimalWeightUnit => 'kg';

  @override
  String get addAnimalHeightUnit => 'cm';

  @override
  String addAnimalMeasureRange(int min, int max, String unit) {
    return 'Min: $min – Max: $max $unit';
  }

  @override
  String get animalDetailNotFound => 'Animal Not Found';

  @override
  String get animalDetailTabOverview => 'Overview';

  @override
  String get animalDetailTabHealth => 'Health';

  @override
  String get animalDetailTabVaccination => 'Vaccination';

  @override
  String get animalDetailTabBreeding => 'Breeding';

  @override
  String get animalDetailTabReproduction => 'Reproduction';

  @override
  String get animalDetailTabProduction => 'Production';

  @override
  String get animalDetailTabFinance => 'Finance';

  @override
  String get animalDetailTabFamily => 'Family';

  @override
  String get animalDetailRecordDeathTitle => 'Record Death';

  @override
  String get animalDetailDeathDateLabel => '📅  When did it die?';

  @override
  String get animalDetailDeathReasonHeader => '😞  Why did it die?';

  @override
  String get animalDetailDeathReasonDisease => 'Disease';

  @override
  String get animalDetailDeathReasonPneumonia => 'Pneumonia';

  @override
  String get animalDetailDeathReasonDiarrhea => 'Diarrhea';

  @override
  String get animalDetailDeathReasonSnakeBite => 'Snake Bite';

  @override
  String get animalDetailDeathReasonPredator => 'Predator';

  @override
  String get animalDetailDeathReasonCold => 'Cold';

  @override
  String get animalDetailDeathReasonNotEating => 'Not Eating';

  @override
  String get animalDetailDeathReasonBirthComplication => 'Birth Complication';

  @override
  String get animalDetailDeathReasonSuddenDeath => 'Sudden Death';

  @override
  String get animalDetailDeathReasonUnknown => 'Unknown';

  @override
  String get animalDetailDeathReasonRequired => 'Please select a reason';

  @override
  String get animalDetailConfirmDeathButton => 'Confirm Death';

  @override
  String get animalDetailRecordCastrationTitle => 'Record Castration';

  @override
  String get animalDetailCastrationDateLabel => '✂️  Castration Date';

  @override
  String get animalDetailMarkedDeceasedSnackbar => 'marked as deceased';

  @override
  String get kidManagementTitle => 'Kid Management';

  @override
  String get kidFilterAll => 'All';

  @override
  String get kidFilterMilk => 'Milk';

  @override
  String get kidFilterWeaned => 'Weaned';

  @override
  String get kidFilterMedicine => 'Medicine';

  @override
  String get kidAddedSnackbar => '✅ Kid added!';

  @override
  String get kidUpdatedSnackbar => '✅ Updated!';

  @override
  String kidDeleteDialog(String kidId) {
    return 'Delete $kidId ?';
  }

  @override
  String get kidDeleteCancel => '✖  No';

  @override
  String get kidDeleteConfirm => '🗑️  Yes';

  @override
  String kidDeletedSnackbar(String kidId) {
    return '🗑️ $kidId deleted';
  }

  @override
  String get healthDashboardTitle => 'Health Center';

  @override
  String get healthStatusHealthy => 'Healthy';

  @override
  String get healthStatusSick => 'Sick';

  @override
  String get healthStatusFollowUp => 'Follow-up';

  @override
  String get healthDashboardNeedSectionTitle => 'What do you need?';

  @override
  String get healthDashboardAlertsSection => '🔔  Alerts';

  @override
  String get healthCardVaccinations => 'Vaccinations';

  @override
  String get healthCardVaccinationsSubtitle => 'Schedule & records';

  @override
  String get healthCardTreatments => 'Treatments';

  @override
  String get healthCardTreatmentsSubtitle => 'Medicines & diagnosis';

  @override
  String get healthCardDeworming => 'Deworming';

  @override
  String get healthCardDewormingSubtitle => 'Antiparasitic schedule';

  @override
  String get healthCardLabReports => 'Lab Reports';

  @override
  String get healthCardLabReportsSubtitle => 'Test results & history';

  @override
  String get healthCardHoofCutting => 'Hoof Cutting';

  @override
  String get healthCardHoofCuttingSubtitle => 'Trim & schedule';

  @override
  String get healthDashboardUpcomingVaccinations => '💉  Upcoming Vaccinations';

  @override
  String get healthDashboardActiveTreatments => '🩺  Active Treatments';

  @override
  String healthDashboardVaccinationsOverdue(int count) {
    return '$count Vaccination(s) Overdue!';
  }

  @override
  String get healthDashboardTapToAction => 'Tap to take action now';

  @override
  String get healthDashboardComingSoon => 'coming soon';

  @override
  String get hoofCuttingSheetTitle => 'Hoof Cutting';

  @override
  String get hoofCuttingSheetSubtitle => 'Record hoof trimming details';

  @override
  String get hoofCuttingWhichAnimal => '🐾  Which animal?';

  @override
  String get vaccinationTitle => 'Vaccinations';

  @override
  String vaccinationTabSchedule(int count) {
    return '📅 Schedule ($count)';
  }

  @override
  String vaccinationTabHistory(int count) {
    return '✅ History ($count)';
  }

  @override
  String vaccinationTabAlerts(int count) {
    return '🔔 Alerts ($count)';
  }

  @override
  String get vaccinationAddSheetTitle => 'Add Vaccination Record';

  @override
  String get vaccinationSelectVaccineLabel => 'Select Vaccine';

  @override
  String get vaccineFmd => 'FMD';

  @override
  String get vaccineFmdDesc => 'Foot & Mouth';

  @override
  String get vaccineBq => 'BQ';

  @override
  String get vaccineBqDesc => 'Black Quarter';

  @override
  String get vaccineHs => 'HS';

  @override
  String get vaccineHsDesc => 'Hemorrhagic Sep.';

  @override
  String get vaccinePpr => 'PPR';

  @override
  String get vaccinePprDesc => 'Sheep / Goat';

  @override
  String get vaccineBrucella => 'Brucella';

  @override
  String get vaccineBrucellaDesc => 'Brucellosis';

  @override
  String get vaccineDewormingName => 'Deworming';

  @override
  String get vaccineDewormingDesc => 'Parasites';

  @override
  String get vaccinationDateLabel => 'Vaccination Date';

  @override
  String get vaccinationAnimalIdRequired => 'Please enter Animal ID';

  @override
  String get vaccinationAddFab => 'Add Record';

  @override
  String vaccinationAddedSnackbar(String vaccine) {
    return '$vaccine vaccination added! 💉';
  }

  @override
  String get vaccinationNoUpcoming => '💉 No upcoming vaccinations';

  @override
  String get vaccinationNoUpcomingSubtitle => 'Tap + to schedule one';

  @override
  String get vaccinationNoHistory => '✅ No vaccination history yet';

  @override
  String get vaccinationNoHistorySubtitle =>
      'Records appear here after administration';

  @override
  String get treatmentTitle => 'Disease & Treatment';

  @override
  String treatmentFilterAll(int count) {
    return '🗂️ All ($count)';
  }

  @override
  String treatmentFilterActive(int count) {
    return '🤒 Active ($count)';
  }

  @override
  String treatmentFilterFollowUp(int count) {
    return '🔄 Follow-up ($count)';
  }

  @override
  String treatmentFilterRecovered(int count) {
    return '✅ Recovered ($count)';
  }

  @override
  String get treatmentReportSheetTitle => 'Report Sick Animal';

  @override
  String get treatmentReportFab => 'Report Sick Animal';

  @override
  String get treatmentSymptomsHeader => 'What symptoms do you see?';

  @override
  String get symptomFever => 'Fever';

  @override
  String get symptomDiarrhea => 'Diarrhea';

  @override
  String get symptomLimping => 'Limping';

  @override
  String get symptomNoAppetite => 'No appetite';

  @override
  String get symptomCoughing => 'Coughing';

  @override
  String get symptomBloating => 'Bloating';

  @override
  String get symptomEyeDischarge => 'Eye discharge';

  @override
  String get symptomNasalDischarge => 'Nasal discharge';

  @override
  String get symptomSkinLesions => 'Skin lesions';

  @override
  String get symptomLessMilk => 'Less milk';

  @override
  String get treatmentOtherSymptomsHint =>
      '✏️  Other symptoms (e.g. Swollen leg, Trembling)';

  @override
  String get treatmentDiagnosisHint => '🔍  Diagnosis (e.g. Fever & infection)';

  @override
  String get treatmentMedicineHint => '💊  Medicine / Treatment';

  @override
  String get treatmentVetNameHint => '👨‍⚕️  Vet Name';

  @override
  String get treatmentWithdrawalHint =>
      '⏳  Withdrawal period in days (optional)';

  @override
  String get treatmentAttachLabReport => 'Attach Lab Report (optional)';

  @override
  String get treatmentLabReportComingSoon => 'Lab report upload coming soon!';

  @override
  String get treatmentAnimalIdRequired => 'Please enter Animal ID';

  @override
  String get treatmentDiagnosisRequired => 'Please enter a diagnosis';

  @override
  String get treatmentSaveButton => 'Save Treatment';

  @override
  String get treatmentAddedSnackbar => 'Treatment record added!';

  @override
  String get dewormingStep1Label => 'Animal ID / Tag Number';

  @override
  String get dewormingStep2Label => 'Add Medicine Name';

  @override
  String get dewormingStep3Label => 'Dose and Body Weight';

  @override
  String get dewormingStep4Label => 'Deworming Date';

  @override
  String get dewormingAnimalIdHint => '🐄  Example: 1 or C-001';

  @override
  String get dewormingBrandNameHint => '🏷️  Medicine brand name';

  @override
  String get dewormingSaltNameHint => '🧪  Medicine salt name';

  @override
  String get dewormingDoseHint => '💧  Dose (Example: 10ml)';

  @override
  String get dewormingWeightHint => '⚖️  Body weight in KG (Example: 245)';

  @override
  String get dewormingVetNameHint => '👨‍⚕️ Vet Name (optional)';

  @override
  String get dewormingWhenLabel => 'Choose when medicine is given';

  @override
  String get dewormingAddMedicineButton => 'Add Medicine';

  @override
  String get dewormingMedicineNameRequired =>
      'Enter brand or salt name to add medicine';

  @override
  String get dewormingAnimalIdRequired => 'Please enter Animal ID';

  @override
  String get dewormingAtLeastOneMedicine => 'Add at least one medicine';

  @override
  String get dewormingValidWeightRequired =>
      'Please enter valid body weight in KG';

  @override
  String get dewormingAnimalNotFound =>
      'Animal not found. Enter valid ID or tag';

  @override
  String dewormingSavedSnackbar(double weight) {
    final intl.NumberFormat weightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String weightString = weightNumberFormat.format(weight);

    return 'Deworming saved. Weight updated to $weightString kg';
  }

  @override
  String get labReportAddSheetTitle => 'Add Lab Report';

  @override
  String get labReportSelectTest => 'Select Test';

  @override
  String get labTestCbc => 'Complete Blood Count';

  @override
  String get labTestCbcAbbr => 'CBC';

  @override
  String get labTestBrucella => 'Brucella Test';

  @override
  String get labTestBrucellaAbbr => 'Brucellosis';

  @override
  String get labTestMilkCulture => 'Milk Culture & Sensitivity';

  @override
  String get labTestMilkCultureAbbr => 'Mastitis';

  @override
  String get labTestFecalEgg => 'Fecal Egg Count';

  @override
  String get labTestFecalEggAbbr => 'Parasites';

  @override
  String get labTestLiver => 'Liver Function Test';

  @override
  String get labTestLiverAbbr => 'LFT';

  @override
  String get labTestTuberculin => 'Tuberculin Test';

  @override
  String get labTestTuberculinAbbr => 'TB test';

  @override
  String get labTestPregnancy => 'Pregnancy Confirmation';

  @override
  String get labTestPregnancyAbbr => 'Pregnancy';

  @override
  String get labTestBloodSmear => 'Blood Smear';

  @override
  String get labTestBloodSmearAbbr => 'Blood parasites';

  @override
  String get labTestUrineAnalysis => 'Urine Analysis';

  @override
  String get labTestUrineAnalysisAbbr => 'Urinalysis';

  @override
  String get labTestOther => 'Other';

  @override
  String get labTestCustomHint => '✏️  Enter test name';

  @override
  String get labReportLabNameHint => '🏥  Lab Name (optional)';

  @override
  String get labReportUploadButton => 'Upload Report (optional)';

  @override
  String get labReportUploadPlaceholder => 'Tap to upload report image';

  @override
  String get labReportUploadedLabel => 'Report Uploaded ✅';

  @override
  String get labReportAnimalIdRequired => 'Please enter Animal ID';

  @override
  String get labReportTestNameRequired => 'Please enter a test name';

  @override
  String get labReportSaveButton => 'Save Report';

  @override
  String get labReportAddedSnackbar => 'Lab report added! 🔬';

  @override
  String get financeDashboardTitle => '💰 Finance';

  @override
  String get financeMoneySpent => 'Money Spent';

  @override
  String get financeMoneyEarned => 'Money Earned';

  @override
  String get financeProfit => 'Profit';

  @override
  String get financeLoss => 'Loss';

  @override
  String get financeQuickAddExpense => 'Quick Add Expense';

  @override
  String get financeQuickFeed => 'Feed';

  @override
  String get financeQuickMedicine => 'Medicine';

  @override
  String get financeQuickDoctor => 'Doctor';

  @override
  String get financeQuickLabour => 'Labour';

  @override
  String get financeQuickEquipment => 'Equipment';

  @override
  String get financeQuickTransport => 'Transport';

  @override
  String get financeQuickOther => 'Other';

  @override
  String get financeQuickAllExpenses => 'All\nExpenses';

  @override
  String get financeQuickFeedMix => 'Feed\nMix';

  @override
  String get financeWhereMoneygoes => 'Where Money Goes';

  @override
  String get financePieFeed => '🌾 Feed';

  @override
  String get financePieLabour => '👷 Labour';

  @override
  String get financePieMedicine => '💊 Medicine';

  @override
  String get financePieDoctor => '🏥 Doctor';

  @override
  String get financePieEquipment => '🔧 Equipment';

  @override
  String get financePieOther => '📦 Other';

  @override
  String get financeMonthlySpending => 'Monthly Spending';

  @override
  String get financeRecentExpenses => 'Recent Expenses';

  @override
  String get financeAddExpenseFab => 'Add Expense';

  @override
  String get expenseListTitle => '📋 All Expenses';

  @override
  String get expenseListSearchHint => 'Search expenses...';

  @override
  String get expenseListTotalSpent => 'Total Spent';

  @override
  String expenseListItemCount(int count) {
    return '$count items';
  }

  @override
  String get expenseListFilterAll => '🔍 All';

  @override
  String get expenseListFilterFeed => '🌾 Feed';

  @override
  String get expenseListFilterMedicine => '💊 Medicine';

  @override
  String get expenseListFilterDoctor => '🏥 Doctor';

  @override
  String get expenseListFilterLabour => '👷 Labour';

  @override
  String get expenseListFilterEquip => '🔧 Equip';

  @override
  String get expenseListFilterTravel => '🚛 Travel';

  @override
  String get expenseListFilterOther => '📦 Other';

  @override
  String get expenseListEmpty => 'No expenses found';

  @override
  String get financeReportsTitle => '📊 Reports';

  @override
  String get financeReportsTotalSpent => 'Total Spent';

  @override
  String get financeReportsTotalEarned => 'Total Earned';

  @override
  String get financeReportsProfit => 'Profit';

  @override
  String get financeReportsPerMonth => 'Per Month';

  @override
  String get financeReportsWhereMoney => '🌾 Where Money Goes';

  @override
  String get financeBarFeed => 'Feed';

  @override
  String get financeBarLabour => 'Labour';

  @override
  String get financeBarMedicine => 'Medicine';

  @override
  String get financeBarVet => 'Vet';

  @override
  String get financeBarEquip => 'Equip';

  @override
  String get financeBarTransport => 'Transport';

  @override
  String get financeBarOther => 'Other';

  @override
  String get financeReportsHowYouPay => '💳 How You Pay';

  @override
  String get financePayCash => '💵 Cash';

  @override
  String get financePayUpi => '📱 UPI';

  @override
  String get financePayBank => '🏦 Bank';

  @override
  String get financePayCredit => '💳 Credit';

  @override
  String get financeDownloadSheet => 'Download\nSheet';

  @override
  String get financeDownloadPdf => 'Download\nPDF';

  @override
  String get financeCsvDownloadedSnackbar => 'CSV file downloaded! ✅';

  @override
  String get financePdfDownloadedSnackbar => 'PDF file downloaded! ✅';

  @override
  String get feedAnimalDairyCow => 'Dairy Cow';

  @override
  String get feedAnimalDairyCowSubtitle => 'Milking Cow';

  @override
  String get feedAnimalBuffalo => 'Buffalo';

  @override
  String get feedAnimalBuffaloSubtitle => 'Water Buffalo';

  @override
  String get feedAnimalGoat => 'Goat';

  @override
  String get feedAnimalGoatSubtitle => 'Farm Goat';

  @override
  String get feedAnimalSheep => 'Sheep';

  @override
  String get feedAnimalSheepSubtitle => 'Farm Sheep';

  @override
  String get feedAnimalHorse => 'Horse';

  @override
  String get feedAnimalHorseSubtitle => 'Riding Horse';

  @override
  String get feedAnimalPig => 'Pig';

  @override
  String get feedAnimalPigSubtitle => 'Farm Pig';

  @override
  String get feedItemMaize => 'Maize';

  @override
  String get feedItemSoybeanMeal => 'Soybean Meal';

  @override
  String get feedItemWheatBran => 'Wheat Bran';

  @override
  String get feedItemCottonseedCake => 'Cottonseed Cake';

  @override
  String get feedItemGreenFodder => 'Green Fodder';

  @override
  String get feedItemDryHay => 'Dry Hay';

  @override
  String get feedItemMustardCake => 'Mustard Cake';

  @override
  String get feedItemMineralMix => 'Mineral Mix';

  @override
  String get feedAlreadyAddedSnackbar =>
      'Already added! Change quantity below.';

  @override
  String get feedipediaOpenError => 'Could not open Feedipedia right now.';

  @override
  String get milkLogTitle => 'Log Milk';

  @override
  String get milkLogTodayChip => 'Today';

  @override
  String get milkLogSummaryTotal => 'Total';

  @override
  String get milkLogSummaryEntries => 'Entries';

  @override
  String get milkLogSummaryAnimals => 'Animals';

  @override
  String get milkLogStepTime => 'Time';

  @override
  String get milkLogStepAnimal => 'Animal';

  @override
  String get milkLogStepLitres => 'Litres';

  @override
  String get milkLogStepDone => 'Done';

  @override
  String get milkLogSavedTitle => 'Saved!';

  @override
  String get milkLogGoHomeButton => 'Home';

  @override
  String get milkLogAddMoreButton => 'Add More';

  @override
  String get milkLogWhenDidYouMilk => 'When did you milk?';

  @override
  String get milkLogSelectSessionHint => 'Tap to select morning or evening';

  @override
  String get milkSessionMorning => 'Morning';

  @override
  String get milkSessionMorningRange => '5 AM – 12 PM';

  @override
  String get milkSessionEvening => 'Evening';

  @override
  String get milkSessionEveningRange => '3 PM – 9 PM';

  @override
  String milkLogTodayEntriesPreview(int count) {
    return 'Today\'s Entries ($count)';
  }

  @override
  String get milkLogWhichAnimal => 'Which animal?';

  @override
  String get milkLogTapAnimalHint => 'Tap on the animal you milked';

  @override
  String get breedingTitle => 'Breeding';

  @override
  String get breedingTabDashboard => 'Dashboard';

  @override
  String get breedingTabHeatTracking => 'Heat Tracking';

  @override
  String get breedingTabPregnancy => 'Pregnancy';

  @override
  String get breedingAddRecordSheetTitle => 'Add Breeding Record';

  @override
  String get breedingMenuRecordHeat => 'Record Heat';

  @override
  String get breedingMenuRecordHeatSubtitle => 'Observe heat in an animal';

  @override
  String get breedingMenuAi => 'Artificial Insemination';

  @override
  String get breedingMenuAiSubtitle => 'Record AI procedure';

  @override
  String get breedingMenuPregnancyCheck => 'Pregnancy Check';

  @override
  String get breedingMenuPregnancyCheckSubtitle => 'Update pregnancy status';

  @override
  String get breedingHeatDialogTitle => 'Record Heat';

  @override
  String get breedingHeatAnimalIdHint => '🐄 Animal ID (e.g. 1)';

  @override
  String get breedingHeatDateLabel => 'Heat Date';

  @override
  String get breedingHeatIntensityLabel => 'Intensity';

  @override
  String get breedingHeatIntensityStrong => 'Strong';

  @override
  String get breedingHeatIntensityModerate => 'Moderate';

  @override
  String get breedingHeatIntensityMild => 'Mild';

  @override
  String get breedingHeatSaveButton => 'Save Heat Record';

  @override
  String get breedingHeatAnimalIdRequired => 'Please enter Animal ID';

  @override
  String get breedingHeatAddedSnackbar => 'Heat record added!';

  @override
  String get breedingAiDialogTitle => 'Add AI Record';

  @override
  String get breedingAiDateLabel => 'AI Date';

  @override
  String get breedingAiBullSemenIdHint => '🐂 Bull / Semen ID';

  @override
  String get breedingAiTechnicianHint => '👨‍⚕️ Technician Name';

  @override
  String get breedingAiHeatIntensityLabel => 'Heat Intensity';

  @override
  String get breedingAiValidationError =>
      'Please enter Animal ID and Bull/Semen ID';

  @override
  String get breedingAiSaveButton => 'Save AI Record';

  @override
  String get breedingAiAddedSnackbar => 'AI record added!';

  @override
  String get breedingPregnancyDialogTitle => 'Pregnancy Check';

  @override
  String get breedingPregnancyMatingDateLabel => 'Mating Date';

  @override
  String get breedingPregnancyExpectedDeliveryLabel => 'Expected Delivery';

  @override
  String get breedingPregnancySaveButton => 'Save Pregnancy Record';

  @override
  String get breedingPregnancyAddedSnackbar => 'Pregnancy record added!';

  @override
  String get breedingAddRecordFab => 'Add Record';

  @override
  String get farmProfileTitle => 'My Farm';

  @override
  String get farmProfileAddPhotoLabel => 'Tap to add farm photo';

  @override
  String get farmProfileCameraOpeningSnackbar => '📸 Camera opening...';

  @override
  String get farmProfileFieldFarmName => 'Farm Name';

  @override
  String get farmProfileFieldFarmNameHint => 'Type your farm name';

  @override
  String get farmProfileFieldOwnerName => 'Owner Name';

  @override
  String get farmProfileFieldOwnerNameHint => 'Your full name';

  @override
  String get farmProfileFieldAddress => 'Address';

  @override
  String get farmProfileFieldAddressHint => 'Village, Taluka, District';

  @override
  String get farmProfileFieldLocation => 'Geographical Location';

  @override
  String get farmProfileFieldLocationHint => 'Tap to get location';

  @override
  String get farmProfileLocationCapturedSnackbar => '📍 Location captured!';

  @override
  String get farmProfileFieldManager => 'Manager Name';

  @override
  String get farmProfileFieldManagerHint => 'Farm manager name';

  @override
  String get farmProfileFieldVet => 'Veterinarian';

  @override
  String get farmProfileFieldVetHint => 'Doctor name & phone';

  @override
  String get farmProfileFieldYoutube => 'YouTube Channel';

  @override
  String get farmProfileFieldYoutubeHint => 'Your channel URL (optional)';

  @override
  String get farmProfileSaveButton => 'Save Profile';

  @override
  String get farmProfileSavedSnackbar => '✅ Profile saved successfully!';

  @override
  String get helpTitle => 'Help & Support';

  @override
  String get helpHeaderTitle => 'How can we help?';

  @override
  String get helpHeaderSubtitle => 'Choose an option below';

  @override
  String get helpCallUs => 'Call Us';

  @override
  String get helpCallUsSubtitle => 'Talk to our team';

  @override
  String get helpWhatsApp => 'WhatsApp';

  @override
  String get helpWhatsAppSubtitle => 'Chat with us';

  @override
  String get helpEmail => 'Email';

  @override
  String get helpEmailSubtitle => 'Send us a message';

  @override
  String get helpFaqSectionTitle => 'Common Questions';

  @override
  String get helpFaq1Question => 'How to add an animal?';

  @override
  String get helpFaq1Answer =>
      'Go to Animals tab → Tap the + button → Follow the 4 steps to add your animal.';

  @override
  String get helpFaq2Question => 'How to track vaccination?';

  @override
  String get helpFaq2Answer =>
      'Go to Health tab → Tap Vaccination → Add new vaccination record for your animal.';

  @override
  String get helpFaq3Question => 'How to add expenses?';

  @override
  String get helpFaq3Answer =>
      'Go to Finance tab → Tap + button → Select category → Enter amount → Save.';

  @override
  String get helpFaq4Question => 'How to add team members?';

  @override
  String get helpFaq4Answer =>
      'Go to More → My Team → Tap Add Worker → Fill name, phone, and role.';

  @override
  String get helpFaq5Question => 'How to see reports?';

  @override
  String get helpFaq5Answer =>
      'Go to Finance tab → Tap Reports → Select date range to see your farm reports.';

  @override
  String get helpFaq6Question => 'How to change language?';

  @override
  String get helpFaq6Answer =>
      'Go to More → Language → Select your preferred language.';

  @override
  String get helpVideosSectionTitle => 'Video Tutorials';

  @override
  String get helpVideo1Title => 'Getting started with Rumeno';

  @override
  String get helpVideo1Duration => '5 min';

  @override
  String get helpVideo2Title => 'Managing your animals';

  @override
  String get helpVideo2Duration => '3 min';

  @override
  String get helpVideo3Title => 'Track health & vaccination';

  @override
  String get helpVideo3Duration => '4 min';

  @override
  String get notificationSettingsTitle => 'Alerts & Notifications';

  @override
  String get notificationSettingsHeaderTitle => 'Notifications';

  @override
  String get notificationSettingsHeaderSubtitle =>
      'Choose what alerts you want';

  @override
  String get notificationSectionAnimalAlerts => 'Animal Alerts';

  @override
  String get notificationToggleVaccination => 'Vaccination Due';

  @override
  String get notificationToggleVaccinationSubtitle => 'When vaccination is due';

  @override
  String get notificationToggleHealth => 'Health Alerts';

  @override
  String get notificationToggleHealthSubtitle => 'When animal is sick';

  @override
  String get notificationToggleBreeding => 'Breeding Alerts';

  @override
  String get notificationToggleBreedingSubtitle => 'Heat & pregnancy updates';

  @override
  String get notificationToggleMoney => 'Money Alerts';

  @override
  String get notificationToggleMoneySubtitle => 'Payment & expense reminders';

  @override
  String get notificationSectionDailyReminders => 'Daily Reminders';

  @override
  String get notificationToggleMilking => 'Milking Time';

  @override
  String get notificationToggleMilkingSubtitle => 'Morning & evening reminder';

  @override
  String get notificationToggleFeeding => 'Feeding Time';

  @override
  String get notificationToggleFeedingSubtitle => 'Feed your animals';

  @override
  String get notificationSectionHowToAlert => 'How to Alert';

  @override
  String get notificationToggleSms => 'SMS Messages';

  @override
  String get notificationToggleSmsSubtitle => 'Get alerts via SMS';

  @override
  String get notificationToggleSound => 'Sound';

  @override
  String get notificationToggleSoundSubtitle => 'Play alert sound';

  @override
  String get notificationSaveButton => 'Save Settings';

  @override
  String get notificationSavedSnackbar => '✅ Notification settings saved!';

  @override
  String get subscriptionTitle => 'My Plan';

  @override
  String get subscriptionCurrentPlanLabel => 'Your Current Plan';

  @override
  String get subscriptionAllPlansTitle => 'All Plans';

  @override
  String get subscriptionPlanFree => 'Free';

  @override
  String get subscriptionPlanFreePrice => '₹0';

  @override
  String get subscriptionPlanFreePeriod => 'Forever';

  @override
  String get subscriptionPlanStarter => 'Starter';

  @override
  String get subscriptionPlanStarterPrice => '₹499';

  @override
  String get subscriptionPlanPro => 'Pro';

  @override
  String get subscriptionPlanProPrice => '₹999';

  @override
  String get subscriptionPlanBusiness => 'Business';

  @override
  String get subscriptionPlanBusinessPrice => '₹2499';

  @override
  String get subscriptionPlanPeriodMonth => '/month';

  @override
  String get subscriptionCurrentPlanButton => 'Current Plan';

  @override
  String get subscriptionUpgradeButton => 'Upgrade';

  @override
  String get subscriptionSelectButton => 'Select';

  @override
  String subscriptionSwitchedSnackbar(String planName) {
    return '✅ Switched to $planName plan!';
  }

  @override
  String get subscriptionFeature5Animals => '5 animals';

  @override
  String get subscriptionFeatureBasicRecords => 'Basic records';

  @override
  String get subscriptionFeatureCommunityHelp => 'Community help';

  @override
  String get subscriptionFeature25Animals => '25 animals';

  @override
  String get subscriptionFeatureHealthMoney => 'Health + Money tracking';

  @override
  String get subscriptionFeatureSmsReminders => 'SMS reminders';

  @override
  String get subscriptionFeatureVetCalls3 => '3 Vet calls/month';

  @override
  String get subscriptionFeature100Animals => '100 animals';

  @override
  String get subscriptionFeatureAdvancedReports => 'Advanced reports';

  @override
  String get subscriptionFeatureBreedingRecords => 'Breeding records';

  @override
  String get subscriptionFeatureUnlimitedVetCalls => 'Unlimited vet calls';

  @override
  String get subscriptionFeatureExportData => 'Export data';

  @override
  String get subscriptionFeatureUnlimitedAnimals => 'Unlimited animals';

  @override
  String get subscriptionFeatureMultiFarm => 'Multi-farm';

  @override
  String get subscriptionFeatureTeamManagement => 'Team management';

  @override
  String get subscriptionFeaturePrioritySupport => 'Priority support';

  @override
  String get subscriptionFeatureCustomReports => 'Custom reports';

  @override
  String get teamTitle => 'My Team';

  @override
  String teamMemberCount(int count) {
    return '$count Team Members';
  }

  @override
  String get teamManageFarmWorkers => 'Manage your farm workers';

  @override
  String get teamRoleOwner => 'Owner';

  @override
  String get teamRoleManager => 'Manager';

  @override
  String get teamRoleStaffEdit => 'Staff (Edit)';

  @override
  String get teamRoleStaffView => 'Staff (View)';

  @override
  String get teamAddWorkerFab => 'Add Worker';

  @override
  String get teamAddWorkerSheetTitle => 'Add New Worker';

  @override
  String get teamWorkerNameLabel => 'Name';

  @override
  String get teamWorkerNameHint => 'Worker name';

  @override
  String get teamWorkerPhoneLabel => 'Phone Number';

  @override
  String get teamWorkerPhoneHint => '9876543210';

  @override
  String get teamWorkerRoleLabel => 'Role';

  @override
  String get teamWorkerAddButton => 'Add Worker';

  @override
  String get teamWorkerValidationError => '⚠️ Please fill name and phone';

  @override
  String get teamWorkerAddedSnackbar => '✅ Worker added!';

  @override
  String get sanitizationAddSheetTitle => 'Add Sanitization';

  @override
  String get sanitizationStep1Label => 'Sanitization Date';

  @override
  String get sanitizationStep2Label => 'Sanitizer Used';

  @override
  String get sanitizationMultiSelectHint => 'Tap to select — select multiple';

  @override
  String get sanitizerBleach => 'Bleach (Sodium Hypochlorite)';

  @override
  String get sanitizerPhenyl => 'Phenyl';

  @override
  String get sanitizerDettol => 'Dettol Antiseptic';

  @override
  String get sanitizerIodine => 'Iodine Solution';

  @override
  String get sanitizerLime => 'Quicklime (Chuna)';

  @override
  String get sanitizerFormalin => 'Formalin';

  @override
  String get sanitizerPotassium => 'Potassium Permanganate';

  @override
  String get sanitizerHydrogenPeroxide => 'Hydrogen Peroxide';

  @override
  String get sanitizerVirkonS => 'Virkon-S';

  @override
  String get sanitizationAreaFullFarm => 'Full Farm';

  @override
  String get sanitizationAreaCowShed => 'Cow Shed';

  @override
  String get sanitizationAreaGoatPen => 'Goat Pen';

  @override
  String get sanitizationAreaPigPen => 'Pig Pen';

  @override
  String get sanitizationAreaPoultry => 'Poultry Area';

  @override
  String get sanitizationAreaWaterTrough => 'Water Trough';

  @override
  String get sanitizationAreaFeedStorage => 'Feed Storage';

  @override
  String get sanitizationAreaEntryGate => 'Entry Gate';

  @override
  String get vetDashboardGreeting => 'Good morning,';

  @override
  String get vetDashboardSpecialization => 'Veterinary Specialist';

  @override
  String get vetDashboardStatReferredFarms => 'Referred Farms';

  @override
  String get vetDashboardStatTotalAnimals => 'Total Animals';

  @override
  String get vetDashboardStatActiveCases => 'Active Cases';

  @override
  String get vetDashboardStatMonthlyEarnings => 'Monthly Earnings';

  @override
  String get vetDashboardQuickActionNewVisit => 'New Visit';

  @override
  String get vetDashboardQuickActionRecordHealth => 'Record Health';

  @override
  String get vetDashboardQuickActionMyFarms => 'My Farms';

  @override
  String get vetDashboardQuickActionEarnings => 'Earnings';

  @override
  String get vetDashboardMotivationTitle => 'Great work this week!';

  @override
  String get vetDashboardMotivationBody =>
      'You completed 14 consultations — 40% more than last week.';

  @override
  String get vetDashboardRecentConsultations => 'Recent Consultations';

  @override
  String get vetDashboardUpcomingVisits => 'Upcoming Visits';

  @override
  String get vetConsultationsTitle => 'All Consultations';

  @override
  String get vetConsultationsSearchHint => 'Search diagnosis or treatment...';

  @override
  String get vetConsultationsFilterAll => 'All';

  @override
  String get vetConsultationsFilterActive => 'Active';

  @override
  String get vetConsultationsFilterFollowUp => 'Follow-up';

  @override
  String get vetConsultationsFilterCompleted => 'Completed';

  @override
  String vetConsultationsRecordCount(int count, String suffix) {
    return '$count record$suffix';
  }

  @override
  String get vetConsultationsEmpty => 'No consultations match your filter.';

  @override
  String get vetConsultationStatusActive => 'Active';

  @override
  String get vetConsultationStatusCompleted => 'Completed';

  @override
  String get vetConsultationStatusFollowUp => 'Follow-up';

  @override
  String vetConsultationFollowUpLabel(String date) {
    return 'Follow-up: $date';
  }

  @override
  String vetConsultationWithdrawalLabel(int days) {
    return 'WD: ${days}d';
  }

  @override
  String get vetFarmsTitle => 'Referred Farms';

  @override
  String get vetFarmsSearchHint => 'Search farms...';

  @override
  String vetFarmsAnimalCount(int count) {
    return '$count animals';
  }

  @override
  String get vetFarmsViewAnimalsButton => 'View Animals';

  @override
  String get vetScheduleTitle => 'Upcoming Schedule';

  @override
  String get vetScheduleSectionVisits => 'Visits & Events';

  @override
  String get vetScheduleSectionVaccinations => 'Pending Vaccinations';

  @override
  String get vetEarningsTitle => 'Earnings';

  @override
  String get vetEarningsStatThisMonth => 'This Month';

  @override
  String get vetEarningsStatTotalEarned => 'Total Earned';

  @override
  String get vetEarningsStatPending => 'Pending';

  @override
  String get vetEarningsStatCommission => 'Commission %';

  @override
  String get vetEarningsChartTitle => 'Monthly Earnings';

  @override
  String get vetEarningsCommissionBreakdown => 'Commission Breakdown';

  @override
  String get vetEarningsBarConsults => 'Consults';

  @override
  String get vetEarningsBarReferrals => 'Referrals';

  @override
  String get vetEarningsBarVaccinations => 'Vaccinations';

  @override
  String get vetEarningsBarTreatments => 'Treatments';

  @override
  String get vetEarningsBarProducts => 'Products';

  @override
  String get vetEarningsPayoutHistory => 'Payout History';

  @override
  String get vetEarningsPayoutStatusPaid => 'Paid';

  @override
  String vetEarningsPayoutPaidOn(String date) {
    return 'Paid on $date';
  }

  @override
  String get vetAnimalHealthTitle => 'Animal Health';

  @override
  String get vetAnimalHealthTabOverview => 'Overview';

  @override
  String get vetAnimalHealthTabRecords => 'Records';

  @override
  String get vetAnimalHealthTabVaccines => 'Vaccines';

  @override
  String get vetAnimalHealthTabConsult => 'Consult';

  @override
  String get vetAnimalHealthSummaryTitle => 'Health Summary';

  @override
  String get vetAnimalHealthStatTotalAnimals => 'Total Animals';

  @override
  String get vetAnimalHealthStatSickTreating => 'Sick / Treating';

  @override
  String get vetAnimalHealthStatVaccinesOverdue => 'Vaccines Overdue';

  @override
  String get vetAnimalHealthStatUrgentAlerts => 'Urgent Alerts';

  @override
  String get vetAnimalHealthStatAllClear => 'All clear';

  @override
  String get vetAnimalHealthQuickActionNewConsult => 'New Consult';

  @override
  String get vetAnimalHealthQuickActionLogVaccine => 'Log Vaccine';

  @override
  String get vetAnimalHealthQuickActionLabReport => 'Lab Report';

  @override
  String get vetFarmDetailTabAnimals => 'Animals';

  @override
  String get vetFarmDetailTabTreatments => 'Treatments';

  @override
  String get vetFarmDetailTabVaccinations => 'Vaccinations';

  @override
  String get vetFarmDetailAnimalsLabel => 'animals';

  @override
  String get vetFarmDetailNoAnimals => 'No animals recorded for this farm.';

  @override
  String get vetFarmDetailNoTreatments => 'No treatment records for this farm.';

  @override
  String get shopHomeTitle => 'Rumeno Shop';

  @override
  String get shopSearchHint => 'Search...';

  @override
  String get shopCategoriesSection => 'Categories';

  @override
  String get shopCategoryFeed => 'Feed';

  @override
  String get shopCategoryTonic => 'Tonic';

  @override
  String get shopCategoryMedicine => 'Medicine';

  @override
  String get shopCategoryTools => 'Tools';

  @override
  String get shopCategorySupplements => 'Supplements';

  @override
  String get shopCategoryAll => 'All';

  @override
  String get shopCategoryAnimalFeed => 'Animal Feed';

  @override
  String get shopBannerFreeDelivery => 'FREE Delivery';

  @override
  String get shopBannerFreeDeliveryCondition => 'On orders above ₹999';

  @override
  String get shopBannerCouponCode => 'Code: WELCOME20';

  @override
  String get shopCouponCopiedSnackbar => 'Coupon code WELCOME20 copied!';

  @override
  String get shopBestProductsSection => 'Best Products';

  @override
  String get shopAllProductsSection => 'All Products';

  @override
  String get shopSearchAnimalFilterAll => 'All Animals';

  @override
  String get shopSearchAnimalFilterCattle => 'Cattle';

  @override
  String get shopSearchAnimalFilterGoat => 'Goat';

  @override
  String get shopSearchAnimalFilterSheep => 'Sheep';

  @override
  String get shopSearchAnimalFilterPoultry => 'Poultry';

  @override
  String get shopSearchAnimalFilterPig => 'Pig';

  @override
  String get shopSearchAnimalFilterHorse => 'Horse';

  @override
  String shopSearchResultCount(int count) {
    return '$count products found';
  }

  @override
  String get shopSearchNoResults => 'No products found';

  @override
  String get shopCategoryNoProducts => 'No products in this category';

  @override
  String get shopOutOfStock => 'Out of Stock';

  @override
  String get shopInStock => 'In Stock';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get productAddedToWishlist => 'Added to wishlist!';

  @override
  String get productRemovedFromWishlist => 'Removed from wishlist';

  @override
  String get productShareCopied => 'Share link copied to clipboard!';

  @override
  String get productRumenoBadge => 'Rumeno Product';

  @override
  String productOffBadge(int percent) {
    return '$percent% OFF';
  }

  @override
  String productMrpLabel(String price) {
    return 'MRP ₹$price';
  }

  @override
  String productSaveLabel(String amount) {
    return 'Save ₹$amount';
  }

  @override
  String get productTaxIncluded => '(Inclusive of all taxes)';

  @override
  String productUnitLabel(String unit) {
    return 'Unit: $unit';
  }

  @override
  String get productTrustFreeDelivery => 'Free Delivery\n₹999+';

  @override
  String get productTrustGenuine => '100% Genuine\nOriginal Product';

  @override
  String get productTrustEasyReturn => 'Easy Return\n7 Day Policy';

  @override
  String get productDescriptionLabel => 'Description';

  @override
  String get productWatchVideo => 'Watch Video';

  @override
  String get productVideoOpenError => 'Could not open video';

  @override
  String productReviewsLabel(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get productNoReviews => 'No reviews yet';

  @override
  String get productAddToCart => 'Add to Cart';

  @override
  String get productInCart => 'In Cart ✓';

  @override
  String get productBuyNow => 'Buy Now';

  @override
  String productAddedToCartSnackbar(String productName) {
    return '$productName added to cart!';
  }

  @override
  String get cartViewCartSnackbarAction => 'View Cart';

  @override
  String cartTitle(int count) {
    return 'Cart ($count)';
  }

  @override
  String get cartEmpty => 'Cart is empty';

  @override
  String get cartEmptySubtitle => 'Add products to get started';

  @override
  String get cartStartShopping => 'Start Shopping';

  @override
  String cartItemRemovedSnackbar(String productName) {
    return '$productName removed';
  }

  @override
  String cartSavingsLabel(String amount) {
    return 'You save ₹$amount';
  }

  @override
  String get cartRemoveCoupon => 'Remove';

  @override
  String get cartApplyCoupon => 'Apply Coupon';

  @override
  String get cartCouponDialogTitle => 'Apply Coupon';

  @override
  String get cartCouponHint => 'Coupon code here...';

  @override
  String get cartCouponApplyButton => 'Apply';

  @override
  String get cartAvailableCoupons => 'Apply';

  @override
  String get cartAvailableCouponsHeader => 'Available Coupons:';

  @override
  String get cartCouponWelcome20Desc => '20% off (max ₹200)';

  @override
  String get cartCouponWelcome20Condition => 'Min order: ₹500';

  @override
  String get cartCouponFlat100Desc => '₹100 off';

  @override
  String get cartCouponFlat100Condition => 'Min order: ₹999';

  @override
  String get cartCouponFeed15Desc => '15% off on feed (max ₹500)';

  @override
  String get cartCouponFeed15Condition => 'Min order: ₹1500';

  @override
  String get cartCouponApplied => 'Coupon applied!';

  @override
  String get cartSubtotalLabel => 'Subtotal';

  @override
  String get cartDiscountLabel => 'Discount';

  @override
  String get cartDeliveryLabel => 'Delivery';

  @override
  String get cartTotalLabel => 'Total';

  @override
  String cartCheckoutButton(String amount) {
    return 'Checkout ₹$amount';
  }

  @override
  String get cartLoginToCheckout => 'Login to Checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutCartEmpty => 'Your cart is empty';

  @override
  String get checkoutStepAddress => 'Address';

  @override
  String get checkoutStepPayment => 'Payment';

  @override
  String get checkoutStepConfirm => 'Confirm';

  @override
  String get checkoutDeliveryAddressTitle => 'Delivery Address';

  @override
  String get checkoutAddDeliveryAddress => 'Add delivery address';

  @override
  String get checkoutAddNewAddress => 'Add New Address';

  @override
  String get checkoutOrderSummary => 'Order Summary';

  @override
  String get checkoutPaymentMethod => 'Payment Method';

  @override
  String get checkoutPaymentUpi => 'UPI';

  @override
  String get checkoutPaymentUpiSubtitle => 'Google Pay, PhonePe, Paytm';

  @override
  String get checkoutPaymentCard => 'Card';

  @override
  String get checkoutPaymentCardSubtitle => 'Credit / Debit Card';

  @override
  String get checkoutPaymentNetBanking => 'Net Banking';

  @override
  String get checkoutPaymentNetBankingSubtitle => 'All major banks';

  @override
  String get checkoutPaymentCod => 'Cash on Delivery';

  @override
  String get checkoutPaymentCodSubtitle => 'Pay when delivered';

  @override
  String get checkoutAddAddressFirst => 'Add Address First';

  @override
  String checkoutPayButton(String amount) {
    return 'Pay ₹$amount';
  }

  @override
  String get checkoutAddAddressDialogTitle => 'Add Address';

  @override
  String get checkoutAddressFullName => 'Full Name';

  @override
  String get checkoutAddressPhone => 'Phone';

  @override
  String get checkoutAddressLine1 => 'Address';

  @override
  String get checkoutAddressLandmark => 'Landmark (Optional)';

  @override
  String get checkoutAddressCity => 'City';

  @override
  String get checkoutAddressState => 'State';

  @override
  String get checkoutAddressPincode => 'Pincode';

  @override
  String get checkoutAddressFillAllFields => 'Please fill all required fields';

  @override
  String get checkoutSaveAddressButton => 'Save Address';

  @override
  String get ordersTitle => 'My Orders';

  @override
  String get ordersEmpty => 'No Orders Yet';

  @override
  String get ordersStartShopping => 'Start Shopping';

  @override
  String get orderProgressPlaced => 'Placed';

  @override
  String get orderProgressPacked => 'Packed';

  @override
  String get orderProgressShipped => 'Shipped';

  @override
  String get orderProgressDelivered => 'Delivered';

  @override
  String get orderStatusPending => 'PENDING';

  @override
  String get orderStatusConfirmed => 'CONFIRMED';

  @override
  String get orderStatusPacked => 'PACKED';

  @override
  String get orderStatusShipped => 'SHIPPED';

  @override
  String get orderStatusDelivered => 'DELIVERED';

  @override
  String get orderStatusCancelled => 'CANCELLED';

  @override
  String get orderStatusReturned => 'RETURNED';

  @override
  String orderMoreItems(int count) {
    return '+$count more items';
  }

  @override
  String get orderTotalLabel => 'Total:';

  @override
  String get orderViewDetailsButton => 'View Details';

  @override
  String get orderInvoiceButton => 'Invoice';

  @override
  String get orderTrackingComingSoon => 'Tracking will be updated soon';

  @override
  String orderDetailTitle(String orderId) {
    return 'Order #$orderId';
  }

  @override
  String get orderDetailNotFound => 'Order not found';

  @override
  String get orderDetailViewInvoiceTooltip => 'View Invoice';

  @override
  String get orderDetailStatusCardTitle => 'Order Status';

  @override
  String get orderDetailTimelinePlaced => 'Order Placed';

  @override
  String get orderDetailTimelineConfirmed => 'Confirmed';

  @override
  String get orderDetailTimelineConfirmedDesc => 'Order confirmed';

  @override
  String get orderDetailTimelinePacked => 'Packed';

  @override
  String get orderDetailTimelineShipped => 'Shipped';

  @override
  String orderDetailTimelineShippedTracking(String trackingId) {
    return 'Tracking: $trackingId';
  }

  @override
  String get orderDetailTimelineDelivered => 'Delivered';

  @override
  String get orderDetailTimelinePending => 'Pending';

  @override
  String orderDetailItemsLabel(int count) {
    return 'Items ($count)';
  }

  @override
  String orderDetailEachLabel(String price) {
    return '₹$price each';
  }

  @override
  String get orderDetailDeliveryAddress => 'Delivery Address';

  @override
  String get orderDetailPaymentTitle => 'Payment';

  @override
  String get orderDetailPaymentMethod => 'Payment Method';

  @override
  String get orderDetailPaymentId => 'Payment ID';

  @override
  String get orderDetailSubtotal => 'Subtotal';

  @override
  String get orderDetailDiscount => 'Discount';

  @override
  String get orderDetailDelivery => 'Delivery';

  @override
  String get orderDetailTotalPaid => 'Total Paid';

  @override
  String get orderDetailReorderButton => 'Reorder';

  @override
  String get orderDetailItemsAddedToCart => 'Items added to cart';

  @override
  String get shopAccountTitle => 'My Account';

  @override
  String get shopAccountMyOrders => 'My Orders';

  @override
  String get shopAccountSavedAddresses => 'Saved Addresses';

  @override
  String get shopAccountWishlist => 'Wishlist';

  @override
  String get shopAccountFarmManagement => 'Livestock Farm Management';

  @override
  String get shopAccountSwitchToVet => 'Switch to Vet';

  @override
  String get shopAccountBecomeVendor => 'Become a Vendor';

  @override
  String get shopAccountHelpSupport => 'Help & Support';

  @override
  String get shopAccountAbout => 'About Rumeno';

  @override
  String get shopAccountLogout => 'Logout';

  @override
  String get shopAccountLogoutDialogTitle => 'Logout?';

  @override
  String get shopAccountLogoutDialogMessage =>
      'Are you sure you want to logout?';

  @override
  String get shopAccountSavedAddressesSheetTitle => 'Saved Addresses';

  @override
  String get shopAccountNoAddresses => 'No saved addresses';

  @override
  String get shopAccountDefaultAddressBadge => 'Default';

  @override
  String get shopAccountWishlistSheetTitle => 'Wishlist';

  @override
  String get shopAccountNoWishlistItems => 'No wishlist items';

  @override
  String get shopAccountAddedToCart => 'Added to cart';

  @override
  String get orderSuccessTitle => 'Order Placed!';

  @override
  String orderSuccessOrderId(String orderId) {
    return 'Order ID: $orderId';
  }

  @override
  String get orderSuccessConfirmationPrompt =>
      'You will receive confirmation shortly';

  @override
  String get orderSuccessDeliveryUpdates => 'Delivery updates will be sent';

  @override
  String get orderSuccessTrackButton => 'Track Order';

  @override
  String get orderSuccessContinueButton => 'Continue Shopping';

  @override
  String get vendorRegisterTitle => 'Vendor Registration';

  @override
  String get vendorRegisterStep1 => 'Business Information';

  @override
  String get vendorRegisterStep2 => 'Documents';

  @override
  String get vendorRegisterStep3 => 'Bank Details';

  @override
  String get vendorRegisterStep4 => 'Address';

  @override
  String get vendorRegisterBusinessName => 'Business Name *';

  @override
  String get vendorRegisterOwnerName => 'Owner Name *';

  @override
  String get vendorRegisterPhone => 'Phone Number *';

  @override
  String get vendorRegisterEmail => 'Email *';

  @override
  String get vendorRegisterGst => 'GST Number *';

  @override
  String get vendorRegisterPan => 'PAN Number *';

  @override
  String get vendorRegisterUploadIdProof => 'Upload ID Proof';

  @override
  String get vendorRegisterBankName => 'Bank Name *';

  @override
  String get vendorRegisterAccountNumber => 'Account Number *';

  @override
  String get vendorRegisterIfsc => 'IFSC Code *';

  @override
  String get vendorRegisterBusinessAddress => 'Business Address *';

  @override
  String get vendorRegisterCity => 'City *';

  @override
  String get vendorRegisterState => 'State *';

  @override
  String get vendorRegisterPincode => 'Pincode *';

  @override
  String get vendorRegisterContinueButton => 'Continue';

  @override
  String get vendorRegisterSubmitButton => 'Submit Application';

  @override
  String get vendorRegisterSuccessTitle => 'Application Submitted';

  @override
  String get vendorRegisterSuccessMessage =>
      'Your vendor registration has been submitted for review. Our team will verify your documents and approve your account within 2-3 business days. You will be notified via email.';

  @override
  String get navHome => 'Home';

  @override
  String get navAnimals => 'Animals';

  @override
  String get navHealth => 'Health';

  @override
  String get navFinance => 'Finance';

  @override
  String get navMore => 'More';

  @override
  String get navVetDashboard => 'Dashboard';

  @override
  String get navVetFarms => 'Farms';

  @override
  String get navVetHealth => 'Health';

  @override
  String get navVetEarnings => 'Earnings';

  @override
  String get navShopHome => 'Home';

  @override
  String get navShopSearch => 'Search';

  @override
  String get navShopCart => 'Cart';

  @override
  String get navShopOrders => 'Orders';

  @override
  String get navShopAccount => 'Account';

  @override
  String get commonOverdue => 'Overdue';

  @override
  String get commonDue => 'Due';

  @override
  String get commonDone => 'Done';

  @override
  String get commonDueSoon => 'Due Soon';

  @override
  String get commonOngoing => 'Ongoing';

  @override
  String get commonResolved => 'Resolved';

  @override
  String get commonPriority => 'Priority';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonActive => 'Active';

  @override
  String get commonCompleted => 'Completed';

  @override
  String get commonFollowUp => 'Follow-up';

  @override
  String get commonQuickActions => 'Quick Actions';

  @override
  String get vetDashboardScheduleVisitTitle => 'Schedule New Visit';

  @override
  String get vetDashboardScheduleVisitSubtitle =>
      'Follow the 4 simple steps below';

  @override
  String get vetDashboardScheduleFarm => 'Choose Farm';

  @override
  String get vetDashboardScheduleWhenToVisit => 'When to Visit?';

  @override
  String get vetDashboardScheduleReason => 'Reason for Visit';

  @override
  String get vetDashboardScheduleNotes => 'Extra Notes (Optional)';

  @override
  String get vetDashboardScheduleNotesHint =>
      'Any special instructions or observations…';

  @override
  String get vetDashboardScheduleButton => 'Schedule Visit';

  @override
  String get vetDashboardScheduleSelectFarmError => 'Please select a farm';

  @override
  String get vetDashboardScheduleSelectReasonError =>
      'Please select the reason for visit';

  @override
  String get vetDashboardScheduleSuccess => 'Visit scheduled successfully!';

  @override
  String get vetDashboardTapToChangeDate => 'Tap to change date';

  @override
  String get vetDashboardVisitPurposeCheckup => 'Checkup';

  @override
  String get vetDashboardVisitPurposeVaccination => 'Vaccination';

  @override
  String get vetDashboardVisitPurposeTreatment => 'Treatment';

  @override
  String get vetDashboardVisitPurposeEmergency => 'Emergency';

  @override
  String get vetDashboardVisitPurposePregnancy => 'Pregnancy';

  @override
  String get vetDashboardVisitPurposeOther => 'Other';

  @override
  String get vetAnimalHealthNoRecords => 'No records for this filter';

  @override
  String get vetAnimalHealthHideDetails => 'Hide Details';

  @override
  String get vetAnimalHealthViewDetails => 'View Details';

  @override
  String get vetAnimalHealthDetailTreatmentLabel => 'Treatment';

  @override
  String get vetAnimalHealthDetailVetLabel => 'Vet';

  @override
  String get vetAnimalHealthDetailWithdrawalLabel => 'Withdrawal';

  @override
  String get vetAnimalHealthDetailEndedLabel => 'Ended';

  @override
  String get vetAnimalHealthWithdrawalDays => ' days (no milk/meat)';

  @override
  String get vetAnimalHealthConsultTitle => 'New Consultation';

  @override
  String get vetAnimalHealthConsultSubtitle =>
      'Fill in the animal health details below';

  @override
  String get vetAnimalHealthConsultStepSelectAnimal => 'Select Animal';

  @override
  String get vetAnimalHealthConsultStepSymptoms => 'Symptoms  (tap to select)';

  @override
  String get vetAnimalHealthConsultStepDiagnosis => 'Diagnosis & Treatment';

  @override
  String get vetAnimalHealthConsultDiagnosisLabel => 'Diagnosis *';

  @override
  String get vetAnimalHealthConsultDiagnosisHint => 'e.g. Foot Rot, Mastitis';

  @override
  String get vetAnimalHealthConsultTreatmentLabel => 'Treatment Prescribed';

  @override
  String get vetAnimalHealthConsultTreatmentHint =>
      'e.g. Oxytetracycline 5mg/kg IM';

  @override
  String get vetAnimalHealthConsultMedicinesLabel => 'Medicines / Injections';

  @override
  String get vetAnimalHealthConsultMedicinesHint =>
      'e.g. Penicilin, Ivermectin';

  @override
  String get vetAnimalHealthConsultNotesHint =>
      'Any additional observations...';

  @override
  String get vetAnimalHealthConsultStepFollowUp => 'Follow-up Schedule';

  @override
  String get vetAnimalHealthConsultFollowUpNone => 'No follow-up';

  @override
  String get vetAnimalHealthConsultFollowUp3Days => 'After 3 days';

  @override
  String get vetAnimalHealthConsultFollowUp1Week => 'After 1 week';

  @override
  String get vetAnimalHealthConsultFollowUp2Weeks => 'After 2 weeks';

  @override
  String get vetAnimalHealthConsultFollowUp1Month => 'After 1 month';

  @override
  String get vetAnimalHealthConsultSaveButton => 'Save Consultation';

  @override
  String get vetAnimalHealthConsultErrorDiagnosis => 'Please enter a diagnosis';

  @override
  String get vetAnimalHealthConsultSaveSuccess =>
      'Consultation saved successfully!';

  @override
  String get vetAnimalHealthNoVaccinations => 'No vaccinations here';

  @override
  String get vetAnimalHealthSymptomFever => 'Fever';

  @override
  String get vetAnimalHealthSymptomLossOfAppetite => 'Loss of appetite';

  @override
  String get vetAnimalHealthSymptomLethargy => 'Lethargy';

  @override
  String get vetAnimalHealthSymptomLameness => 'Lameness';

  @override
  String get vetAnimalHealthSymptomSwelling => 'Swelling';

  @override
  String get vetAnimalHealthSymptomDiarrhea => 'Diarrhea';

  @override
  String get vetAnimalHealthSymptomCough => 'Cough';

  @override
  String get vetAnimalHealthSymptomNasalDischarge => 'Nasal discharge';

  @override
  String get vetAnimalHealthSymptomReducedMilk => 'Reduced milk';

  @override
  String get vetFarmDetailNoVaccinations =>
      'No vaccination records for this farm.';

  @override
  String get vetFarmDetailShed => 'Shed';

  @override
  String vetFarmDetailFollowUpDate(String date) {
    return 'Follow-up: $date';
  }

  @override
  String vetFarmDetailGivenDate(String date) {
    return 'Given: $date';
  }

  @override
  String vetFarmDetailDueDate(String date) {
    return 'Due: $date';
  }

  @override
  String vetFarmDetailNextDate(String date) {
    return 'Next: $date';
  }

  @override
  String get vetAnimalHealthAlertsSection => 'Alerts';

  @override
  String get vetAnimalHealthUpcomingEventsSection => 'Upcoming Events';

  @override
  String vetAnimalHealthTreatmentStarted(String date) {
    return 'Started: $date';
  }

  @override
  String vetAnimalHealthWithdrawalValue(Object days) {
    return '$days days (no milk/meat)';
  }

  @override
  String get appName => 'Rumeno';

  @override
  String get appTitle => 'Rumeno - Farm Management';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get gotIt => 'Got it';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search here...';

  @override
  String get back => 'Back';

  @override
  String get continueText => 'Continue';

  @override
  String get submit => 'Submit';

  @override
  String get close => 'Close';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Done';

  @override
  String get viewAll => 'View All';

  @override
  String get loading => 'Loading...';

  @override
  String get noResults => 'No results found';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get language => 'Language';

  @override
  String languageSetTo(String language) {
    return 'Language set to $language';
  }

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get overdue => 'Overdue';

  @override
  String get due => 'Due';

  @override
  String get paid => 'Paid';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get status => 'Status';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get total => 'Total';

  @override
  String get details => 'Details';

  @override
  String get hide => 'Hide';

  @override
  String get items => 'items';

  @override
  String get records => 'Records';

  @override
  String get noData => 'No data available';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get addedToCart => 'Added to cart!';

  @override
  String get rupeeSymbol => '₹';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get totalAnimals => 'Total Animals';

  @override
  String get totalAnimalsDesc =>
      'Total number of animals currently registered in your farm including all species and statuses.';

  @override
  String get milkToday => 'Milk Today';

  @override
  String get milkTodayDesc =>
      'Total milk collected today from morning and evening sessions across all milking animals.';

  @override
  String get tasksDue => 'Tasks Due';

  @override
  String get tasksDueDesc =>
      'Number of pending tasks including upcoming vaccinations, treatments, breeding checks, and follow-ups.';

  @override
  String get healthAlerts => 'Health Alerts';

  @override
  String get healthAlertsDesc =>
      'Active health alerts requiring attention — sick animals, overdue treatments, or abnormal observations.';

  @override
  String get milkingCows => 'Milking Cows';

  @override
  String get milkingCowsDesc =>
      'Number of cows currently in lactation and actively being milked.';

  @override
  String get pregnant => 'Pregnant';

  @override
  String get pregnantDesc =>
      'Number of animals confirmed pregnant through examination or AI records.';

  @override
  String get underTreatment => 'Under Treatment';

  @override
  String get underTreatmentDesc =>
      'Animals currently receiving medical treatment or on medication.';

  @override
  String get vaccinatedThirtyDays => 'Vaccinated (30d)';

  @override
  String get vaccinatedThirtyDaysDesc =>
      'Animals that have been vaccinated within the last 30 days.';

  @override
  String get farmOverview => 'Farm Overview';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get activeAlerts => 'Active Alerts';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get addAnimal => 'Add Animal';

  @override
  String get logMilk => 'Log Milk';

  @override
  String get feedMix => 'Feed Mix';

  @override
  String get reportSickAnimal => 'Report Sick Animal';

  @override
  String get setFarmLogo => 'Set Farm Logo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get selectExistingPhoto => 'Select an existing photo';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get useYourCamera => 'Use your camera';

  @override
  String get addFarmLogo => 'Add Farm Logo';

  @override
  String get pro => 'Pro';

  @override
  String get addNewAnimal => 'Add New Animal';

  @override
  String get whichAnimal => 'Which Animal?';

  @override
  String get typeBasicInfo => 'Type & basic info';

  @override
  String get howItLooks => 'How it looks?';

  @override
  String get sizeAndColor => 'Size & color';

  @override
  String get family => 'Family';

  @override
  String get parentsOptional => 'Parents (optional)';

  @override
  String get whereItLives => 'Where it lives?';

  @override
  String get shedAndPurpose => 'Shed & purpose';

  @override
  String get purchase => 'Purchase';

  @override
  String get optional => 'Optional';

  @override
  String get animalNotFound => 'Animal Not Found';

  @override
  String get animalId => 'Animal ID';

  @override
  String get tagNumber => 'Tag Number';

  @override
  String get species => 'Species';

  @override
  String get breed => 'Breed';

  @override
  String get gender => 'Gender';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get weight => 'Weight';

  @override
  String get color => 'Color';

  @override
  String get purpose => 'Purpose';

  @override
  String get shed => 'Shed';

  @override
  String get underOneMonth => 'Under 1 month';

  @override
  String get oneToThreeMonths => '1 – 3 months';

  @override
  String get threeToSixMonths => '3 – 6 months';

  @override
  String get sixToNineMonths => '6 – 9 months';

  @override
  String get nineToTwelveMonths => '9 – 12 months';

  @override
  String get twelveToEighteenMonths => '12 – 18 months';

  @override
  String get eighteenToTwentyFourMonths => '18 – 24 months';

  @override
  String get overTwentyFourMonths => '24+ months';

  @override
  String get cow => 'Cow';

  @override
  String get buffalo => 'Buffalo';

  @override
  String get goat => 'Goat';

  @override
  String get sheep => 'Sheep';

  @override
  String get pig => 'Pig';

  @override
  String get horse => 'Horse';

  @override
  String get statusActive => 'Active';

  @override
  String get statusPregnant => 'Pregnant';

  @override
  String get statusDry => 'Dry';

  @override
  String get statusSick => 'Sick';

  @override
  String get statusUnderTreatment => 'Under Treatment';

  @override
  String get statusQuarantine => 'Quarantine';

  @override
  String get statusDeceased => 'Deceased';

  @override
  String get statusDead => 'Dead';

  @override
  String get purposeDairy => 'Dairy';

  @override
  String get purposeMeat => 'Meat';

  @override
  String get purposeBreeding => 'Breeding';

  @override
  String get purposeMixed => 'Mixed';

  @override
  String get diseaseAndTreatment => 'Disease & Treatment';

  @override
  String get vaccinations => 'Vaccinations';

  @override
  String get deworming => 'Deworming';

  @override
  String get labReports => 'Lab Reports';

  @override
  String get reportSick => 'Report Sick Animal';

  @override
  String get saveTreatment => 'Save Treatment';

  @override
  String get treatmentRecordAdded => 'Treatment record added!';

  @override
  String get labReportUploadComingSoon => 'Lab report upload coming soon!';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get diagnosisHint => 'e.g. Fever & infection';

  @override
  String get medicine => 'Medicine / Treatment';

  @override
  String get vetName => 'Vet Name';

  @override
  String get withdrawalPeriod => 'Withdrawal period in days (optional)';

  @override
  String get attachLabReport => 'Attach Lab Report (optional)';

  @override
  String get pleaseEnterAnimalId => 'Please enter Animal ID';

  @override
  String get pleaseEnterDiagnosis => 'Please enter a diagnosis';

  @override
  String get animalIdHint => 'Animal ID (e.g. C-001)';

  @override
  String get noTreatmentsFound => 'No treatments found';

  @override
  String get allAnimalsHealthy => 'All animals look healthy!';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterFollowUp => 'Follow-up';

  @override
  String get filterRecovered => 'Recovered';

  @override
  String get addVaccinationRecord => 'Add Vaccination Record';

  @override
  String get selectVaccine => 'Select Vaccine';

  @override
  String get vaccinationDate => 'Vaccination Date';

  @override
  String get givenToday => 'Given Today';

  @override
  String get scheduleLater => 'Schedule Later';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get addRecord => 'Add Record';

  @override
  String vaccinationAdded(String vaccine) {
    return '$vaccine vaccination added!';
  }

  @override
  String get noUpcomingVaccinations => 'No upcoming vaccinations';

  @override
  String get tapToSchedule => 'Tap + to schedule one';

  @override
  String get noVaccinationHistory => 'No vaccination history yet';

  @override
  String get recordsAppearHere => 'Records appear here after administration';

  @override
  String get allVaccinationsUpToDate => 'All vaccinations up to date!';

  @override
  String get greatJobHealthy => 'Great job keeping your animals healthy';

  @override
  String get schedule => 'Schedule';

  @override
  String get history => 'History';

  @override
  String get alerts => 'Alerts';

  @override
  String get vaccineFMD => 'FMD';

  @override
  String get vaccineFMDFull => 'Foot & Mouth';

  @override
  String get vaccineBQ => 'BQ';

  @override
  String get vaccineBQFull => 'Black Quarter';

  @override
  String get vaccineHS => 'HS';

  @override
  String get vaccineHSFull => 'Hemorrhagic Sep.';

  @override
  String get vaccinePPR => 'PPR';

  @override
  String get vaccinePPRFull => 'Sheep / Goat';

  @override
  String get vaccineBrucellaFull => 'Brucellosis';

  @override
  String get vaccineDeworming => 'Deworming';

  @override
  String get vaccineDewormingFull => 'Parasites';

  @override
  String get statusDone => 'Done';

  @override
  String get statusDueSoon => 'Due Soon';

  @override
  String get statusOverdue => 'Overdue!';

  @override
  String get givenLabel => 'Given:';

  @override
  String get dueLabel => 'Due:';

  @override
  String get nextLabel => 'Next:';

  @override
  String get finance => 'Finance';

  @override
  String get allExpenses => 'All Expenses';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get searchExpenses => 'Search expenses...';

  @override
  String get moneySpent => 'Money Spent';

  @override
  String get moneyEarned => 'Money Earned';

  @override
  String get profit => 'Profit';

  @override
  String get loss => 'Loss';

  @override
  String get reports => 'Reports';

  @override
  String get totalEarned => 'Total Earned';

  @override
  String get perMonth => 'Per Month';

  @override
  String get whereMoneyGoes => 'Where Money Goes';

  @override
  String get howYouPay => 'How You Pay';

  @override
  String get downloadSheet => 'Download\nSheet';

  @override
  String get downloadPDF => 'Download\nPDF';

  @override
  String get csvDownloaded => 'CSV file downloaded!';

  @override
  String get pdfDownloaded => 'PDF file downloaded!';

  @override
  String get noExpensesFound => 'No expenses found';

  @override
  String get expFeed => 'Feed';

  @override
  String get expMedicine => 'Medicine';

  @override
  String get expDoctor => 'Doctor';

  @override
  String get expLabour => 'Labour';

  @override
  String get expEquipment => 'Equip';

  @override
  String get expTravel => 'Travel';

  @override
  String get expOther => 'Other';

  @override
  String get payCash => 'Cash';

  @override
  String get payUPI => 'UPI';

  @override
  String get payBank => 'Bank';

  @override
  String get payCredit => 'Credit';

  @override
  String get feedCalculator => 'Feed Calculator';

  @override
  String get dairyCow => 'Dairy Cow';

  @override
  String get milkingCow => 'Milking Cow';

  @override
  String get waterBuffalo => 'Water Buffalo';

  @override
  String get farmGoat => 'Farm Goat';

  @override
  String get farmSheep => 'Farm Sheep';

  @override
  String get farmPig => 'Farm Pig';

  @override
  String get farmHorse => 'Farm Horse';

  @override
  String get breeding => 'Breeding';

  @override
  String get breedingDashboard => 'Breeding Dashboard';

  @override
  String get heatDetection => 'Heat Detection';

  @override
  String get pregnancyTracking => 'Pregnancy Tracking';

  @override
  String get milkLog => 'Milk Log';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get liters => 'Liters';

  @override
  String get myFarm => 'My Farm';

  @override
  String get farmDetails => 'Farm Details';

  @override
  String get myTeam => 'My Team';

  @override
  String get workers => 'Workers';

  @override
  String get myPlan => 'My Plan';

  @override
  String get subscription => 'Subscription';

  @override
  String get notifications => 'Notifications';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get export => 'Export';

  @override
  String get saveData => 'Save Data';

  @override
  String get sanitization => 'Sanitization';

  @override
  String get farmCleaning => 'Farm Cleaning';

  @override
  String get help => 'Help';

  @override
  String get support => 'Support';

  @override
  String get logout => 'Logout';

  @override
  String get signOut => 'Sign Out';

  @override
  String get logoutQuestion => 'Logout?';

  @override
  String get logoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get noStay => 'No, Stay';

  @override
  String get yesLogout => 'Yes, Logout';

  @override
  String get farmName => 'Farm Name';

  @override
  String get typeYourFarmName => 'Type your farm name';

  @override
  String get ownerName => 'Owner Name';

  @override
  String get yourFullName => 'Your full name';

  @override
  String get address => 'Address';

  @override
  String get villageTalukaDistrict => 'Village, Taluka, District';

  @override
  String get geographicalLocation => 'Geographical Location';

  @override
  String get tapToGetLocation => 'Tap to get location';

  @override
  String get managerName => 'Manager Name';

  @override
  String get farmManagerName => 'Farm manager name';

  @override
  String get veterinarian => 'Veterinarian';

  @override
  String get doctorNamePhone => 'Doctor name & phone';

  @override
  String get youtubeChannel => 'YouTube Channel';

  @override
  String get channelUrlOptional => 'Your channel URL (optional)';

  @override
  String get tapToAddFarmPhoto => 'Tap to add farm photo';

  @override
  String get cameraOpening => 'Camera opening...';

  @override
  String get locationCaptured => 'Location captured!';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileSaved => 'Profile saved successfully!';

  @override
  String get teamMembers => 'Team Members';

  @override
  String get manageWorkers => 'Manage your farm workers';

  @override
  String get owner => 'Owner';

  @override
  String get manager => 'Manager';

  @override
  String get staffEdit => 'Staff (Edit)';

  @override
  String get staffView => 'Staff (View)';

  @override
  String get addNewWorker => 'Add New Worker';

  @override
  String get workerName => 'Worker name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get role => 'Role';

  @override
  String get addWorker => 'Add Worker';

  @override
  String get pleaseFillNameAndPhone => 'Please fill name and phone';

  @override
  String get workerAdded => 'Worker added!';

  @override
  String get alertsAndNotifications => 'Alerts & Notifications';

  @override
  String get chooseAlerts => 'Choose what alerts you want';

  @override
  String get animalAlerts => 'Animal Alerts';

  @override
  String get dailyReminders => 'Daily Reminders';

  @override
  String get howToAlert => 'How to Alert';

  @override
  String get vaccinationDue => 'Vaccination Due';

  @override
  String get whenVaccinationDue => 'When vaccination is due';

  @override
  String get healthAlertsTitle => 'Health Alerts';

  @override
  String get whenAnimalSick => 'When animal is sick';

  @override
  String get breedingAlerts => 'Breeding Alerts';

  @override
  String get heatPregnancyUpdates => 'Heat & pregnancy updates';

  @override
  String get moneyAlerts => 'Money Alerts';

  @override
  String get paymentExpenseReminders => 'Payment & expense reminders';

  @override
  String get milkingTime => 'Milking Time';

  @override
  String get morningEveningReminder => 'Morning & evening reminder';

  @override
  String get feedingTime => 'Feeding Time';

  @override
  String get feedYourAnimals => 'Feed your animals';

  @override
  String get smsMessages => 'SMS Messages';

  @override
  String get getAlertsViaSms => 'Get alerts via SMS';

  @override
  String get sound => 'Sound';

  @override
  String get playAlertSound => 'Play alert sound';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get notificationSettingsSaved => 'Notification settings saved!';

  @override
  String get yourCurrentPlan => 'Your Current Plan';

  @override
  String get allPlans => 'All Plans';

  @override
  String get planFree => 'Free';

  @override
  String get planStarter => 'Starter';

  @override
  String get planPro => 'Pro';

  @override
  String get planBusiness => 'Business';

  @override
  String get forever => 'Forever';

  @override
  String get perMonthLabel => '/month';

  @override
  String get animals => 'animals';

  @override
  String upToAnimals(int count) {
    return 'Up to $count animals';
  }

  @override
  String get unlimitedAnimals => 'Unlimited animals';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get selectPlan => 'Select Plan';

  @override
  String switchedToPlan(String plan) {
    return 'Switched to $plan plan!';
  }

  @override
  String get basicRecords => 'Basic records';

  @override
  String get communityHelp => 'Community help';

  @override
  String get healthMoneyTracking => 'Health + Money tracking';

  @override
  String get smsReminders => 'SMS reminders';

  @override
  String vetCallsPerMonth(int count) {
    return '$count Vet calls/month';
  }

  @override
  String get advancedReports => 'Advanced reports';

  @override
  String get breedingRecords => 'Breeding records';

  @override
  String get unlimitedVetCalls => 'Unlimited vet calls';

  @override
  String get exportData => 'Export data';

  @override
  String get multiFarm => 'Multi-farm';

  @override
  String get teamManagement => 'Team management';

  @override
  String get prioritySupport => 'Priority support';

  @override
  String get customReports => 'Custom reports';

  @override
  String renewsOn(String date) {
    return 'Renews on $date';
  }

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get chooseOptionBelow => 'Choose an option below';

  @override
  String get callUs => 'Call Us';

  @override
  String get talkToTeam => 'Talk to our team';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get chatWithUs => 'Chat with us';

  @override
  String get email => 'Email';

  @override
  String get sendUsMessage => 'Send us a message';

  @override
  String get callingSupport => 'Calling support';

  @override
  String get openingWhatsApp => 'Opening WhatsApp...';

  @override
  String get openingEmail => 'Opening email...';

  @override
  String get commonQuestions => 'Common Questions';

  @override
  String get faqAddAnimal => 'How to add an animal?';

  @override
  String get faqAddAnimalAnswer =>
      'Go to Animals tab → Tap the + button → Follow the 4 steps to add your animal.';

  @override
  String get faqTrackVaccination => 'How to track vaccination?';

  @override
  String get faqTrackVaccinationAnswer =>
      'Go to Health tab → Tap Vaccination → Add new vaccination record for your animal.';

  @override
  String get faqAddExpenses => 'How to add expenses?';

  @override
  String get faqAddExpensesAnswer =>
      'Go to Finance tab → Tap + button → Select category → Enter amount → Save.';

  @override
  String get faqAddTeamMembers => 'How to add team members?';

  @override
  String get faqAddTeamMembersAnswer =>
      'Go to More → My Team → Tap Add Worker → Fill name, phone, and role.';

  @override
  String get faqSeeReports => 'How to see reports?';

  @override
  String get faqSeeReportsAnswer =>
      'Go to Finance tab → Tap Reports → Select date range to see your farm reports.';

  @override
  String get faqChangeLanguage => 'How to change language?';

  @override
  String get faqChangeLanguageAnswer =>
      'Go to More → Language → Select your preferred language.';

  @override
  String get videoTutorials => 'Video Tutorials';

  @override
  String get gettingStarted => 'Getting started with Rumeno';

  @override
  String get managingAnimals => 'Managing your animals';

  @override
  String get trackHealthVaccination => 'Track health & vaccination';

  @override
  String get openingVideoTutorial => 'Opening video tutorial...';

  @override
  String get minutes => 'min';

  @override
  String get dataExport => 'Data Export';

  @override
  String get farmSanitization => 'Farm Sanitization';

  @override
  String get shopTitle => 'Rumeno Shop';

  @override
  String get cart => 'Cart';

  @override
  String cartCount(int count) {
    return 'Cart ($count)';
  }

  @override
  String get orders => 'Orders';

  @override
  String get myOrders => 'My Orders';

  @override
  String get startShopping => 'Start Shopping';

  @override
  String get addProductsToStart => 'Add products to get started';

  @override
  String get checkout => 'Checkout';

  @override
  String get orderPlaced => 'Order Placed!';

  @override
  String orderIdLabel(String orderId) {
    return 'Order ID: $orderId';
  }

  @override
  String get receiveConfirmation => 'You will receive confirmation shortly';

  @override
  String get deliveryUpdates => 'Delivery updates will be sent';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get noOrdersYet => 'No Orders Yet';

  @override
  String get viewDetails => 'View Details';

  @override
  String get invoice => 'Invoice';

  @override
  String get tracking => 'Tracking';

  @override
  String get trackingUpdatedSoon => 'Tracking will be updated soon';

  @override
  String get orderProgress => 'Order Progress';

  @override
  String get placed => 'Placed';

  @override
  String get packed => 'Packed';

  @override
  String get shipped => 'Shipped';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get returned => 'Returned';

  @override
  String get addToCart => 'Add to cart';

  @override
  String productsFound(int count) {
    return '$count products found';
  }

  @override
  String get noProductsFound => 'No products found';

  @override
  String get noProductsInCategory => 'No products in this category';

  @override
  String get categoryAnimalFeed => 'Animal Feed';

  @override
  String get categorySupplements => 'Supplements';

  @override
  String get categoryMedicine => 'Medicine';

  @override
  String get categoryTools => 'Tools';

  @override
  String get categoryTonic => 'Tonic';

  @override
  String get categoryVetMedicines => 'Veterinary Medicines';

  @override
  String get categoryFarmEquipment => 'Farm Equipment';

  @override
  String get animalCattle => 'Cattle';

  @override
  String get animalGoat => 'Goat';

  @override
  String get animalSheep => 'Sheep';

  @override
  String get animalPoultry => 'Poultry';

  @override
  String get animalPig => 'Pig';

  @override
  String get animalHorse => 'Horse';

  @override
  String get allAnimals => 'All Animals';

  @override
  String get vendorRegistration => 'Vendor Registration';

  @override
  String get businessInformation => 'Business Information';

  @override
  String get documents => 'Documents';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get businessName => 'Business Name';

  @override
  String get phoneNumberRequired => 'Phone Number *';

  @override
  String get emailRequired => 'Email *';

  @override
  String get gstNumber => 'GST Number *';

  @override
  String get panNumber => 'PAN Number *';

  @override
  String get uploadIdProof => 'Upload ID Proof';

  @override
  String get bankName => 'Bank Name *';

  @override
  String get accountNumber => 'Account Number *';

  @override
  String get ifscCode => 'IFSC Code *';

  @override
  String get businessAddress => 'Business Address *';

  @override
  String get city => 'City *';

  @override
  String get state => 'State *';

  @override
  String get pincode => 'Pincode *';

  @override
  String get submitApplication => 'Submit Application';

  @override
  String get applicationSubmitted => 'Application Submitted';

  @override
  String get applicationSubmittedMsg =>
      'Your vendor registration has been submitted for review. Our team will verify your documents and approve your account within 2-3 business days. You will be notified via email.';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get tax => 'Tax';

  @override
  String get discount => 'Discount';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get applyCoupon => 'Apply Coupon';

  @override
  String get couponCode => 'Coupon Code';

  @override
  String get apply => 'Apply';

  @override
  String get removeCoupon => 'Remove';

  @override
  String get vetDashboard => 'Dashboard';

  @override
  String get vetFarms => 'Farms';

  @override
  String get vetHealth => 'Health';

  @override
  String get vetEarnings => 'Earnings';

  @override
  String get totalFarms => 'Total Farms';

  @override
  String get totalAnimalsVet => 'Total Animals';

  @override
  String get activeTreatments => 'Active Treatments';

  @override
  String get todaySchedule => 'Today\'s Schedule';

  @override
  String get allConsultations => 'All Consultations';

  @override
  String get searchDiagnosisTreatment => 'Search diagnosis or treatment...';

  @override
  String get noConsultationsMatch => 'No consultations match your filter.';

  @override
  String recordCount(int count) {
    return '$count records';
  }

  @override
  String get referredFarms => 'Referred Farms';

  @override
  String get searchFarms => 'Search farms...';

  @override
  String get viewAnimals => 'View Animals';

  @override
  String animalCount(int count) {
    return '$count animals';
  }

  @override
  String get tabAnimals => 'Animals';

  @override
  String get tabTreatments => 'Treatments';

  @override
  String get tabVaccinations => 'Vaccinations';

  @override
  String get noAnimalsRecorded => 'No animals recorded for this farm.';

  @override
  String get noTreatmentRecords => 'No treatment records for this farm.';

  @override
  String get noVaccinationRecords => 'No vaccination records for this farm.';

  @override
  String get upcomingSchedule => 'Upcoming Schedule';

  @override
  String get visitsAndEvents => 'Visits & Events';

  @override
  String get pendingVaccinations => 'Pending Vaccinations';

  @override
  String get eventVaccination => 'Vaccination';

  @override
  String get eventBreeding => 'Breeding';

  @override
  String get eventTreatment => 'Treatment';

  @override
  String get eventHealth => 'Health';

  @override
  String get earnings => 'Earnings';

  @override
  String get thisMonth => 'This Month';

  @override
  String get totalEarnedVet => 'Total Earned';

  @override
  String get pendingAmount => 'Pending';

  @override
  String get commissionPercent => 'Commission %';

  @override
  String get monthlyEarnings => 'Monthly Earnings';

  @override
  String get commissionBreakdown => 'Commission Breakdown';

  @override
  String get payoutHistory => 'Payout History';

  @override
  String paidOnDate(String date) {
    return 'Paid on $date';
  }

  @override
  String get marketplaceTooltip => 'Marketplace';

  @override
  String get veterinarianTooltip => 'Veterinarian';

  @override
  String get farmTooltip => 'Farm';

  @override
  String get marketplaceDialogTitle => 'Marketplace';

  @override
  String get veterinarianDialogTitle => 'Veterinarian';

  @override
  String get farmDialogTitle => 'Farm Dashboard';

  @override
  String get veterinarianDialogDesc =>
      'Tap the icon to connect with licensed veterinarians to book appointments, request farm visits, and get expert advice on your animals\' health and treatments.';

  @override
  String get marketplaceDialogDesc =>
      'Tap the icon to browse and purchase farm supplies, animal feed, medicines, and equipment. Sell your farm produce directly to buyers through the Rumeno marketplace.';

  @override
  String get farmDialogDesc =>
      'Tap the icon to access your Farm Management Dashboard — the central hub for all your farming activities.';

  @override
  String get treatment => 'Treatment:';

  @override
  String get withdrawal => 'Withdrawal:';

  @override
  String get ended => 'Ended:';

  @override
  String get notes => 'Notes:';

  @override
  String get account => 'Account';

  @override
  String get farmShopTitle => 'My Shop';

  @override
  String get farmShopEarningsBannerLabel => 'This Month Earnings';

  @override
  String get farmShopAnimalsSold => 'Animals\nSold';

  @override
  String get farmShopMilkSales => 'Milk\nSales';

  @override
  String get farmShopTotalRecords => 'Total\nRecords';

  @override
  String get farmShopWhatToSell => 'What to Sell?';

  @override
  String get farmShopSellAnimal => 'Sell Animal';

  @override
  String get farmShopSellMilk => 'Sell Milk';

  @override
  String get farmShopSellProduce => 'Sell Produce';

  @override
  String get farmShopSaleHistory => 'Sale History';

  @override
  String get farmShopRecentSales => 'Recent Sales';

  @override
  String get farmShopViewAll => 'All';

  @override
  String get farmShopQuickSell => 'Sell';

  @override
  String get farmShopAnimal => 'Animal';

  @override
  String get farmShopMilk => 'Milk';

  @override
  String get farmShopProduce => 'Produce';

  @override
  String get saleGoBack => 'Go Back';

  @override
  String get saleBuyerNameLabel => 'Buyer Name';

  @override
  String get salePhoneLabel => 'Phone (optional)';

  @override
  String get saleNotesLabel => 'Notes (optional)';

  @override
  String get salePriceLabel => 'Enter Price (₹)';

  @override
  String get saleNextButton => 'Next ➜';

  @override
  String get salePaymentMethodTitle => 'Payment Method';

  @override
  String get salePaymentCash => 'Cash';

  @override
  String get salePaymentBank => 'Bank';

  @override
  String get salePaymentCredit => 'Credit';

  @override
  String get saleErrorInvalidPrice => 'Please enter a valid price';

  @override
  String get saleErrorBuyerName => 'Please enter buyer\'s name';

  @override
  String get sellAnimalTitle => 'Sell Animal';

  @override
  String get sellAnimalStepPick => 'Pick Animal';

  @override
  String get sellAnimalStepPrice => 'Price';

  @override
  String get sellAnimalStepConfirm => 'Confirm';

  @override
  String get sellAnimalPickHeading => 'Which animal to sell?';

  @override
  String get sellAnimalErrorSelectFirst => 'Please select an animal first';

  @override
  String get sellAnimalNotesHint => 'Write any special notes...';

  @override
  String get sellAnimalSummaryTitle => 'Sale Summary';

  @override
  String get sellAnimalSummaryAnimal => 'Animal';

  @override
  String get sellAnimalSummaryPrice => 'Price';

  @override
  String get sellAnimalSummaryBuyer => 'Buyer';

  @override
  String get sellAnimalSummaryPhone => 'Phone';

  @override
  String get sellAnimalSummaryPayment => 'Payment';

  @override
  String get sellAnimalSummaryNotes => 'Notes';

  @override
  String get sellAnimalConfirmButton => 'Confirm Sale';

  @override
  String get sellAnimalSuccessTitle => 'Sale Recorded!';

  @override
  String get sellMilkTitle => 'Sell Milk';

  @override
  String get sellProduceTitle => 'Sell Produce';

  @override
  String get sellProduceWhatToSell => 'What to Sell?';

  @override
  String sellProduceHowMuch(String unit) {
    return 'How Much? ($unit)';
  }

  @override
  String get sellProduceTotalPrice => 'Total Price (₹)';

  @override
  String get sellProduceNotesHint => 'Any special note...';

  @override
  String get sellProduceRecordMilkSale => 'Record Milk Sale';

  @override
  String get sellProduceRecordSale => 'Record Sale';

  @override
  String get sellProduceSuccessTitle => 'Sale Recorded!';

  @override
  String get produceItemMilk => 'Milk';

  @override
  String get produceItemCurd => 'Curd';

  @override
  String get produceItemButter => 'Butter';

  @override
  String get produceItemGhee => 'Ghee';

  @override
  String get produceItemPaneer => 'Paneer';

  @override
  String get produceItemLassi => 'Lassi';

  @override
  String get produceItemFodder => 'Fodder';

  @override
  String get produceItemEggs => 'Eggs';

  @override
  String get produceItemManure => 'Manure';

  @override
  String get produceItemWool => 'Wool';

  @override
  String get produceItemVegetables => 'Vegetables';

  @override
  String get produceItemHerbs => 'Herbs';

  @override
  String get saleHistoryTitle => 'Sale History';

  @override
  String get saleHistorySearchHint => 'Search buyer or animal...';

  @override
  String get saleHistoryFilterAll => 'All';

  @override
  String get saleHistoryFilterAnimal => 'Animal';

  @override
  String get saleHistoryFilterMilk => 'Milk';

  @override
  String get saleHistoryFilterProduce => 'Produce';

  @override
  String get saleHistorySalesLabel => 'Sales';

  @override
  String get saleHistoryTotalLabel => 'Total';

  @override
  String get saleHistoryNoSales => 'No sales found';

  @override
  String get saleHistoryDeleteTitle => 'Delete?';

  @override
  String get saleHistoryDeleteConfirm => 'Delete';

  @override
  String get saleHistoryDeleteCancel => 'Cancel';

  @override
  String get saleHistorySwipeDeleteNo => 'No';

  @override
  String get saleHistorySwipeDeleteYes => 'Yes';
}
