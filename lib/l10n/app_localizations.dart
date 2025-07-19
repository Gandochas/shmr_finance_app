import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
    Locale('ru'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @put_finger_for_auth.
  ///
  /// In en, this message translates to:
  /// **'Put your finger on it for authentication'**
  String get put_finger_for_auth;

  /// No description provided for @biometric_authentication_error.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication error'**
  String get biometric_authentication_error;

  /// No description provided for @insert_pincode.
  ///
  /// In en, this message translates to:
  /// **'Insert pincode'**
  String get insert_pincode;

  /// No description provided for @insert_new_pincode.
  ///
  /// In en, this message translates to:
  /// **'Insert new pincode'**
  String get insert_new_pincode;

  /// No description provided for @change_pincode.
  ///
  /// In en, this message translates to:
  /// **'Change pincode'**
  String get change_pincode;

  /// No description provided for @confirm_pincode.
  ///
  /// In en, this message translates to:
  /// **'Confirm pincode'**
  String get confirm_pincode;

  /// No description provided for @set_pincode.
  ///
  /// In en, this message translates to:
  /// **'Set pincode'**
  String get set_pincode;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @pincode_should_contain_4_digits.
  ///
  /// In en, this message translates to:
  /// **'Pincode should contain 4 digits'**
  String get pincode_should_contain_4_digits;

  /// No description provided for @pincodes_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Pincodes do not match'**
  String get pincodes_do_not_match;

  /// No description provided for @incorrect_pincode_attempts_left.
  ///
  /// In en, this message translates to:
  /// **'Incorrect pincode. Attempts left'**
  String get incorrect_pincode_attempts_left;

  /// No description provided for @attempts_are_over_try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Attempts are over. Try again later'**
  String get attempts_are_over_try_again_later;

  /// No description provided for @authorize_with_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Authorize with your fingerprint'**
  String get authorize_with_fingerprint;

  /// No description provided for @my_history.
  ///
  /// In en, this message translates to:
  /// **'My History'**
  String get my_history;

  /// No description provided for @beginning.
  ///
  /// In en, this message translates to:
  /// **'Beginning'**
  String get beginning;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @today_incomes.
  ///
  /// In en, this message translates to:
  /// **'Today incomes'**
  String get today_incomes;

  /// No description provided for @today_expenses.
  ///
  /// In en, this message translates to:
  /// **'Today expenses'**
  String get today_expenses;

  /// No description provided for @my_balance.
  ///
  /// In en, this message translates to:
  /// **'My balance'**
  String get my_balance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @for_the_month.
  ///
  /// In en, this message translates to:
  /// **'For the month'**
  String get for_the_month;

  /// No description provided for @for_the_year.
  ///
  /// In en, this message translates to:
  /// **'For the year'**
  String get for_the_year;

  /// No description provided for @my_articles.
  ///
  /// In en, this message translates to:
  /// **'My articles'**
  String get my_articles;

  /// No description provided for @offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offline_mode;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomes;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @no_transactions_today.
  ///
  /// In en, this message translates to:
  /// **'There was no transactions today'**
  String get no_transactions_today;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @by_date.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get by_date;

  /// No description provided for @by_amount.
  ///
  /// In en, this message translates to:
  /// **'By amount'**
  String get by_amount;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @add_transaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get add_transaction;

  /// No description provided for @edit_transaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get edit_transaction;

  /// No description provided for @enable_system_theme.
  ///
  /// In en, this message translates to:
  /// **'Enable system theme'**
  String get enable_system_theme;

  /// No description provided for @to_change_pincode.
  ///
  /// In en, this message translates to:
  /// **'Change pincode'**
  String get to_change_pincode;

  /// No description provided for @main_color.
  ///
  /// In en, this message translates to:
  /// **'Main color'**
  String get main_color;

  /// No description provided for @choose_main_color.
  ///
  /// In en, this message translates to:
  /// **'Choose main color'**
  String get choose_main_color;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @haptic_touch.
  ///
  /// In en, this message translates to:
  /// **'Haptic touch'**
  String get haptic_touch;

  /// No description provided for @enable_auth_by_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Enable authentication by fingerprint'**
  String get enable_auth_by_fingerprint;

  /// No description provided for @change_balance_name.
  ///
  /// In en, this message translates to:
  /// **'Change balance name'**
  String get change_balance_name;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @russian_ruble.
  ///
  /// In en, this message translates to:
  /// **'Russian ruble'**
  String get russian_ruble;

  /// No description provided for @russian_ruble_sign.
  ///
  /// In en, this message translates to:
  /// **'₽'**
  String get russian_ruble_sign;

  /// No description provided for @american_dollar.
  ///
  /// In en, this message translates to:
  /// **'American dollar'**
  String get american_dollar;

  /// No description provided for @american_dollar_sign.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get american_dollar_sign;

  /// No description provided for @euro.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get euro;

  /// No description provided for @euro_sign.
  ///
  /// In en, this message translates to:
  /// **'€'**
  String get euro_sign;

  /// No description provided for @find_article.
  ///
  /// In en, this message translates to:
  /// **'Find the article'**
  String get find_article;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @please_fill_in_all_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get please_fill_in_all_required_fields;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @add_income.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get add_income;

  /// No description provided for @add_expense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get add_expense;

  /// No description provided for @edit_income.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get edit_income;

  /// No description provided for @edit_expense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get edit_expense;

  /// No description provided for @article.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get article;

  /// No description provided for @choose_category.
  ///
  /// In en, this message translates to:
  /// **'Choose the category'**
  String get choose_category;

  /// No description provided for @total_sum.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total_sum;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @delete_expense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get delete_expense;

  /// No description provided for @delete_income.
  ///
  /// In en, this message translates to:
  /// **'Delete income'**
  String get delete_income;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
