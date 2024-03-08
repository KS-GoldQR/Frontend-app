import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils.dart';

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
  if (value.isEmpty) return null;
  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.chargeCannotBeNegative;
  }

  return null;
}

validateRate(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.rateCannotBeEmpty;
  }
  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.rateCannotBeNegative;
  }

  return null;
}

validateLoss(String weight, String value, String weightType, String lossType,
    BuildContext context) {
  if (value.isEmpty) return null;
  if (weight.isEmpty) {
    return AppLocalizations.of(context)!.weightEmpty;
  }
  if (double.tryParse(weight) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(weight)! <= 0) {
    return AppLocalizations.of(context)!.weightNonNegativeZero;
  }

  if (double.tryParse(value) == null) {
    return AppLocalizations.of(context)!.enterValidNumber;
  }

  if (double.tryParse(value)! < 0) {
    return AppLocalizations.of(context)!.lossCannotBeNegative;
  }

  debugPrint(
      "${translatedTypes(context: context, selectedWeightType: weightType, selectedProductType: "").$1!} $lossType");

  double weightValue = getWeightInGram(
      double.tryParse(weight)!,
      translatedTypes(
              context: context,
              selectedWeightType: weightType,
              selectedProductType: "")
          .$1!);
  double lossValue = getWeightInGram(
      double.tryParse(value)!,
      translatedTypes(
              context: context,
              selectedWeightType: lossType,
              selectedProductType: "")
          .$1!);

  debugPrint("$weightValue $lossValue");

  if (weightValue - lossValue < 0) {
    return AppLocalizations.of(context)!.lossCannotBeMoreThanWeight;
  }

  return null;
}
