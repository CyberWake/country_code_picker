import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';

import 'country_codes.dart';
import 'country_localizations.dart';

mixin ToAlias {}

/// Country element. This is the element that contains all the information
class CountryCode {
  /// the name of the country
  String? name;

  /// the flag of the country
  final String? flagUri;

  /// the country code (IT,AF..)
  final String? code;

  /// the dial code (+39,+93..)
  final String? dialCode;

  /// the name of the country in english
  final String? label;

  final int? phoneNumberLength;

  final String? numberFormat;

  CountryCode({
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
    this.label,
    this.phoneNumberLength,
    this.numberFormat,
  });

  @Deprecated('Use `fromCountryCode` instead.')
  factory CountryCode.fromCode(String isoCode) {
    return CountryCode.fromCountryCode(isoCode);
  }

  factory CountryCode.fromCountryCode(String countryCode) {
    final Map<String, String>? jsonCode = codes.firstWhereOrNull(
      (code) => code['code'] == countryCode,
    );
    return CountryCode.fromJson(jsonCode!);
  }

  factory CountryCode.fromDialCode(String dialCode) {
    final Map<String, String>? jsonCode = codes.firstWhereOrNull(
      (code) => code['dial_code'] == dialCode,
    );
    return CountryCode.fromJson(jsonCode!);
  }

  CountryCode localize(BuildContext context) {
    return this
      ..name = CountryLocalizations.of(context)?.translate(code) ?? name;
  }

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
        name: json['name'],
        code: json['code'],
        dialCode: json['phone_code'],
        flagUri: 'flags/${json['code'].toLowerCase()}.png',
        label: json['label'],
        phoneNumberLength: json.containsKey('phone_length')
            ? int.parse(json['phone_length'].toString())
            : json.containsKey('max')
                ? int.parse(json['max'].toString())
                : 13,
        numberFormat: json.containsKey('phone_mask')
            ? json['phone_mask'].toString()
            : '000 00000 00000');
  }

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toReverseLongString() => "${toCountryStringOnly()} $dialCode";

  String toCountryStringOnly() {
    return '$_cleanName';
  }

  String? get _cleanName {
    return name?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }
}
