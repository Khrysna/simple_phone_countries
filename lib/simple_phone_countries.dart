/// A simple, synchronous Flutter package for phone country codes, dial codes,
/// and country flags.
///
/// This package provides:
/// - Pre-loaded country data (no async loading required)
/// - ISO 3166-1 alpha-2 country codes
/// - International dial codes
/// - SVG country flags (path only, use your preferred SVG library)
/// - Utility functions for phone number handling
///
/// ## Usage
///
/// ```dart
/// import 'package:simple_phone_countries/simple_phone_countries.dart';
///
/// // Access country directly via enum (no await needed)
/// final indonesia = CountryCode.ID;
/// print(indonesia.dialCode); // +62
/// print(indonesia.name); // Indonesia
///
/// // Search and filter
/// final countries = PhoneCountries.searchByName('united');
///
/// // Detect country from phone number
/// final country = PhoneCountries.detectFromPhoneNumber('+6281234567890');
///
/// // Group by alphabet
/// final grouped = PhoneCountries.groupedByAlphabet;
/// print(grouped['I']); // [Indonesia, India, ...]
/// ```
library;

export 'src/enums/country_code.dart';
export 'src/extensions/country_code_list_extension.dart';
export 'src/phone_countries.dart';
