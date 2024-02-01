import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

validateName(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.nameEmpty;
  }
  return null;
}

validateWeight(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.weightEmpty;
  }

  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! <= 0) {
    return AppLocalizations.of(context)!.weightNonNegativeZero;
  }

  return null;
}

validateJyala(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.jyalaEmpty;
  }

  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.jyalaNonNegativeZero;
  }

  return null;
}

validateJarti(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.jartiEmpty;
  }

  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.jartiNonNegativeZero;
  }

  return null;
}

validateStonePrice(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.stonePriceEmpty;
  }
  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }
  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.stonePriceNonNegativeZero;
  }

  return null;
}

validateContactNumber(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.phoneNumberEmpty;
  }

  if (value.length != 10) {
    return AppLocalizations.of(context)!.invalidPhoneNumber;
  }
  return null;
}

validateAddress(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.addressEmpty;
  }
  return null;
}

validateAdvancePayment(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.advancePaymentEmpty;
  }

  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.advancePaymentNonNegative;
  }
  return null;
}

validateCharge(String value, BuildContext context) {
  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.chargeCannotBeNegative;
  }

  return null;
}
