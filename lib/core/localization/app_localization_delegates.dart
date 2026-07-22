import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/generated/app_localizations.dart';

/// Flutter ships no Kinyarwanda data for the Material, Cupertino or Widgets
/// localizations, so selecting RW in the language switcher would otherwise
/// leave the framework strings (date pickers, "Back" tooltips, text-selection
/// menus) unresolved.
///
/// Our own [AppLocalizations] does have full `rw` copy — only the framework
/// side is missing — so these delegates step in for `rw` and serve the
/// English framework strings underneath our translated UI.
class _RwMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _RwMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(_RwMaterialLocalizationsDelegate old) => false;
}

class _RwCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _RwCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(_RwCupertinoLocalizationsDelegate old) => false;
}

class _RwWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _RwWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(_RwWidgetsLocalizationsDelegate old) => false;
}

/// The delegate list every entry point should use — the generated app
/// delegates plus the Kinyarwanda fallbacks. Order matters: the fallbacks
/// come last so `en` and `fr` still get the real global localizations.
const List<LocalizationsDelegate<Object?>> appLocalizationsDelegates = [
  ...AppLocalizations.localizationsDelegates,
  _RwMaterialLocalizationsDelegate(),
  _RwCupertinoLocalizationsDelegate(),
  _RwWidgetsLocalizationsDelegate(),
];
