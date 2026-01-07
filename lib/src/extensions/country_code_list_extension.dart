import 'package:simple_phone_countries/src/enums/country_code.dart';

/// Options for filtering countries in search operations.
class CountryFilterOptions {
  /// Whether to filter by country name.
  final bool byName;

  /// Whether to filter by country code (ISO 3166-1 alpha-2).
  final bool byCode;

  /// Whether to filter by dial code.
  final bool byDialCode;

  /// Creates a new [CountryFilterOptions] instance.
  ///
  /// By default, only [byName] is enabled.
  const CountryFilterOptions({
    this.byName = true,
    this.byCode = false,
    this.byDialCode = false,
  });

  /// Filter by all available fields.
  static const all = CountryFilterOptions(
    byName: true,
    byCode: true,
    byDialCode: true,
  );

  /// Filter only by name (default).
  static const nameOnly = CountryFilterOptions(
    byName: true,
    byCode: false,
    byDialCode: false,
  );

  /// Filter only by code.
  static const codeOnly = CountryFilterOptions(
    byName: false,
    byCode: true,
    byDialCode: false,
  );

  /// Filter only by dial code.
  static const dialCodeOnly = CountryFilterOptions(
    byName: false,
    byCode: false,
    byDialCode: true,
  );
}

/// Extension on [List<CountryCode>] providing sorting, grouping, and filtering.
extension CountryCodeListExtension on List<CountryCode> {
  /// Returns a new list sorted alphabetically by country name.
  ///
  /// Example:
  /// ```dart
  /// final sorted = PhoneCountries.all.sortedByName();
  /// ```
  List<CountryCode> sortedByName() {
    final list = List<CountryCode>.from(this);
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  /// Returns a new list sorted numerically by dial code.
  ///
  /// Example:
  /// ```dart
  /// final sorted = PhoneCountries.all.sortedByDialCode();
  /// ```
  List<CountryCode> sortedByDialCode() {
    final list = List<CountryCode>.from(this);
    list.sort((a, b) {
      final aCode = int.tryParse(a.dialCodeWithoutPlus) ?? 0;
      final bCode = int.tryParse(b.dialCodeWithoutPlus) ?? 0;
      return aCode.compareTo(bCode);
    });
    return list;
  }

  /// Returns a new list sorted by country code (ISO 3166-1 alpha-2).
  ///
  /// Example:
  /// ```dart
  /// final sorted = PhoneCountries.all.sortedByCode();
  /// ```
  List<CountryCode> sortedByCode() {
    final list = List<CountryCode>.from(this);
    list.sort((a, b) => a.code.compareTo(b.code));
    return list;
  }

  /// Returns countries grouped by the first letter of their name.
  ///
  /// Optionally filter and sort by [query] text.
  /// Use [filterOptions] to specify which fields to search in.
  ///
  /// Example:
  /// ```dart
  /// // Group all countries
  /// final grouped = PhoneCountries.all.groupedByAlphabet();
  /// print(grouped['I']); // [Indonesia, India, Ireland, ...]
  ///
  /// // Group and filter by query
  /// final filtered = PhoneCountries.all.groupedByAlphabet(
  ///   query: 'united',
  ///   filterOptions: CountryFilterOptions.nameOnly,
  /// );
  ///
  /// // Filter by name, code, or dial code
  /// final searchAll = PhoneCountries.all.groupedByAlphabet(
  ///   query: '+6',
  ///   filterOptions: CountryFilterOptions.all,
  /// );
  /// ```
  Map<String, List<CountryCode>> groupedByAlphabet({
    String? query,
    CountryFilterOptions filterOptions = const CountryFilterOptions(),
  }) {
    List<CountryCode> filtered = this;

    // Apply filtering if query is provided
    if (query != null && query.isNotEmpty) {
      filtered = filter(query: query, filterOptions: filterOptions);
    }

    // Sort by name before grouping
    final sorted = filtered.sortedByName();

    final map = <String, List<CountryCode>>{};
    for (final country in sorted) {
      final letter = country.name[0].toUpperCase();
      map.putIfAbsent(letter, () => []).add(country);
    }
    return map;
  }

  /// Filters countries by the given [query] text.
  ///
  /// Use [filterOptions] to specify which fields to search in:
  /// - [CountryFilterOptions.byName] - Filter by country name (default: true)
  /// - [CountryFilterOptions.byCode] - Filter by country code (default: false)
  /// - [CountryFilterOptions.byDialCode] - Filter by dial code (default: false)
  ///
  /// The search is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// // Filter by name only (default)
  /// final result = PhoneCountries.all.filter(query: 'indo');
  /// // Returns [Indonesia]
  ///
  /// // Filter by name and code
  /// final result = PhoneCountries.all.filter(
  ///   query: 'ID',
  ///   filterOptions: CountryFilterOptions(byName: true, byCode: true),
  /// );
  ///
  /// // Filter by all fields
  /// final result = PhoneCountries.all.filter(
  ///   query: '+62',
  ///   filterOptions: CountryFilterOptions.all,
  /// );
  /// ```
  List<CountryCode> filter({
    required String query,
    CountryFilterOptions filterOptions = const CountryFilterOptions(),
  }) {
    if (query.isEmpty) return List<CountryCode>.from(this);

    final lowerQuery = query.toLowerCase();
    final cleanQuery = query.replaceAll('+', '').toLowerCase();

    return where((country) {
      if (filterOptions.byName) {
        if (country.name.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }

      if (filterOptions.byCode) {
        if (country.code.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }

      if (filterOptions.byDialCode) {
        if (country.dialCodeWithoutPlus.contains(cleanQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }
}
