import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

/// `context.l10n.save` instead of
/// `AppLocalizations.of(context)!.save` at every call site.
extension LocaleExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
