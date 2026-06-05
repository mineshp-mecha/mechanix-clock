import 'package:flutter/material.dart';
import 'package:mechanix_clock/l10n/app_localizations.dart';

extension LocalizedDays on BuildContext {
  List<String> get dayAbbrs {
    final l10n = AppLocalizations.of(this)!;
    return [
      l10n.monday_abbr,
      l10n.tuesday_abbr,
      l10n.wednesday_abbr,
      l10n.thursday_abbr,
      l10n.friday_abbr,
      l10n.saturday_abbr,
      l10n.sunday_abbr,
    ];
  }
}
