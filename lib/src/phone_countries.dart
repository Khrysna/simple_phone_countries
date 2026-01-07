import 'package:simple_phone_countries/src/enums/country_code.dart';

/// A utility class for working with phone countries.
///
/// This class provides static methods to search, filter, and retrieve
/// country information without requiring async operations.
class PhoneCountries {
  PhoneCountries._();

  /// Cache for quick lookups by country code.
  static final Map<String, CountryCode> _codeCache = {
    for (final code in CountryCode.values) code.code: code,
  };

  /// Cache for quick lookups by dial code.
  static final Map<String, List<CountryCode>> _dialCodeCache = () {
    final map = <String, List<CountryCode>>{};
    for (final code in CountryCode.values) {
      final dialCode = code.dialCode.replaceAll('+', '').trim();
      map.putIfAbsent(dialCode, () => []).add(code);
    }
    return map;
  }();

  /// Returns all available countries.
  static List<CountryCode> get all => CountryCode.values.toList();

  /// Returns the total number of countries.
  static int get count => CountryCode.values.length;

  /// Finds a country by its ISO 3166-1 alpha-2 code.
  ///
  /// Returns `null` if not found.
  ///
  /// Example:
  /// ```dart
  /// final country = PhoneCountries.findByCode('ID');
  /// print(country?.name); // Indonesia
  /// ```
  static CountryCode? findByCode(String code) {
    final upperCode = code.toUpperCase();
    return _codeCache[upperCode];
  }

  /// Finds a country by its ISO 3166-1 alpha-2 code.
  ///
  /// Throws [ArgumentError] if not found.
  ///
  /// Example:
  /// ```dart
  /// final country = PhoneCountries.getByCode('ID');
  /// print(country.name); // Indonesia
  /// ```
  static CountryCode getByCode(String code) {
    final country = findByCode(code);
    if (country == null) {
      throw ArgumentError('Country code not found: $code');
    }
    return country;
  }

  /// Finds countries by dial code.
  ///
  /// Multiple countries can share the same dial code (e.g., +1 for US and Canada).
  ///
  /// The [dialCode] can be with or without the "+" prefix.
  ///
  /// Example:
  /// ```dart
  /// final countries = PhoneCountries.findByDialCode('+1');
  /// // Returns US, Canada, etc.
  /// ```
  static List<CountryCode> findByDialCode(String dialCode) {
    final cleanDialCode = dialCode.replaceAll('+', '').trim();
    return _dialCodeCache[cleanDialCode]?.toList() ?? [];
  }

  /// Finds a single country by dial code.
  ///
  /// Returns the first matching country or `null` if not found.
  ///
  /// The [dialCode] can be:
  /// - With "+" prefix: "+62"
  /// - Without "+" prefix: "62"
  /// - With leading zero (local format): "08" or "0" (will be stripped)
  ///
  /// Example:
  /// ```dart
  /// final country = PhoneCountries.findOneByDialCode('+62');
  /// print(country?.name); // Indonesia
  ///
  /// final country2 = PhoneCountries.findOneByDialCode('62');
  /// print(country2?.name); // Indonesia
  /// ```
  static CountryCode? findOneByDialCode(String dialCode) {
    String cleanDialCode = dialCode.replaceAll('+', '').trim();

    // Remove leading zeros (for local format like "08" -> "8" won't match, so we keep "0" removal minimal)
    while (cleanDialCode.startsWith('0') && cleanDialCode.length > 1) {
      cleanDialCode = cleanDialCode.substring(1);
    }

    final countries = _dialCodeCache[cleanDialCode];
    if (countries == null || countries.isEmpty) {
      return null;
    }

    return countries.first;
  }

  /// Searches countries by name (case-insensitive).
  ///
  /// Example:
  /// ```dart
  /// final countries = PhoneCountries.searchByName('united');
  /// // Returns United States, United Kingdom, United Arab Emirates
  /// ```
  static List<CountryCode> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return CountryCode.values
        .where((code) => code.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filters countries using a custom predicate.
  ///
  /// Example:
  /// ```dart
  /// final countries = PhoneCountries.where(
  ///   (country) => country.dialCode.startsWith('+6'),
  /// );
  /// ```
  static List<CountryCode> where(bool Function(CountryCode) predicate) {
    return all.where(predicate).toList();
  }

  /// Checks if a country code exists.
  static bool exists(String code) => _codeCache.containsKey(code.toUpperCase());

  /// Detects country from a phone number string.
  ///
  /// This method attempts to find the matching country by dial code
  /// at the beginning of the phone number.
  ///
  /// Returns the first matching country or `null` if no match found.
  ///
  /// Example:
  /// ```dart
  /// final country = PhoneCountries.detectFromPhoneNumber('+6281234567890');
  /// print(country?.name); // Indonesia
  /// ```
  static CountryCode? detectFromPhoneNumber(String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');

    if (!cleanNumber.startsWith('+')) {
      return null;
    }

    cleanNumber = cleanNumber.substring(1); // Remove '+'

    // Try matching from longest dial code to shortest
    // Maximum dial code length is 5 (e.g., +1684)
    for (int len = 5; len >= 1; len--) {
      if (cleanNumber.length >= len) {
        final potentialDialCode = cleanNumber.substring(0, len);
        final countries = _dialCodeCache[potentialDialCode];
        if (countries != null && countries.isNotEmpty) {
          return countries.first;
        }
      }
    }

    return null;
  }

  /// Formats a phone number with its country dial code.
  ///
  /// Example:
  /// ```dart
  /// final formatted = PhoneCountries.formatPhoneNumber(
  ///   CountryCode.ID,
  ///   '81234567890',
  /// );
  /// print(formatted); // +6281234567890
  /// ```
  static String formatPhoneNumber(CountryCode country, String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-()+]'), '');

    // Remove leading zeros
    while (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    return '${country.dialCode}$cleanNumber';
  }

  /// Extracts the local phone number from a full international number.
  ///
  /// Example:
  /// ```dart
  /// final local = PhoneCountries.extractLocalNumber('+6281234567890');
  /// print(local); // 81234567890
  /// ```
  static String? extractLocalNumber(String phoneNumber) {
    final country = detectFromPhoneNumber(phoneNumber);
    if (country == null) return null;

    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');
    final dialCode = country.dialCode.replaceAll('+', '');

    if (cleanNumber.startsWith('+$dialCode')) {
      return cleanNumber.substring(dialCode.length + 1);
    } else if (cleanNumber.startsWith(dialCode)) {
      return cleanNumber.substring(dialCode.length);
    }

    return cleanNumber;
  }
}
