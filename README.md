# Simple Phone Countries

A simple, synchronous Flutter package for phone country codes, dial codes, and SVG country flags. **No async loading required** - all data is pre-loaded and instantly accessible.

[![pub package](https://img.shields.io/pub/v/simple_phone_countries.svg)](https://pub.dev/packages/simple_phone_countries)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- ✅ **No async loading** - Access country data instantly via enum
- 🏳️ **SVG Country Flags** - High-quality, scalable flags for all countries
- 📞 **Dial Codes** - Complete international dial codes
- 🔍 **Search & Filter** - Search countries by name, code, or dial code
- 📱 **Phone Number Detection** - Detect country from phone number
- 🌏 **240+ Countries** - Comprehensive country data
- 🔤 **Alphabetical Grouping** - Countries grouped by first letter

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  simple_phone_countries: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:simple_phone_countries/simple_phone_countries.dart';
```

### Access Country Data (No async needed!)

```dart
// Access directly via CountryCode enum
final indonesia = CountryCode.ID;
print(indonesia.name);     // Indonesia
print(indonesia.dialCode); // +62
print(indonesia.code);     // ID
```

### Search Countries

```dart
// Search by name
final results = PhoneCountries.searchByName('united');
// Returns: United States, United Kingdom, United Arab Emirates

// Find by ISO code
final country = PhoneCountries.findByCode('ID');
print(country?.name); // Indonesia

// Find by dial code (multiple countries may share a dial code)
final countries = PhoneCountries.findByDialCode('+1');
// Returns: United States, Canada, etc.
```

### Group Countries by Alphabet

```dart
// Basic grouping
final grouped = PhoneCountries.all.groupedByAlphabet();
// Returns Map<String, List<CountryCode>>

print(grouped['A']); // [Afghanistan, Albania, Algeria, ...]
print(grouped['I']); // [Iceland, India, Indonesia, ...]
print(grouped['U']); // [Uganda, Ukraine, United Arab Emirates, ...]

// With search/filter
final filtered = PhoneCountries.all.groupedByAlphabet(
  query: 'united',
  filterOptions: CountryFilterOptions.nameOnly,
);

// Filter by name, code, or dial code
final searchAll = PhoneCountries.all.groupedByAlphabet(
  query: '+62',
  filterOptions: CountryFilterOptions.all,
);

// Perfect for building alphabetical country lists
for (final entry in grouped.entries) {
  print('${entry.key}: ${entry.value.length} countries');
}
```

### Sorting Countries

```dart
// Sort by name
final sortedByName = PhoneCountries.all.sortedByName();

// Sort by dial code (numerically)
final sortedByDialCode = PhoneCountries.all.sortedByDialCode();

// Sort by ISO code
final sortedByCode = PhoneCountries.all.sortedByCode();
```

### Filter Countries

```dart
// Filter by name only (default)
final result = PhoneCountries.all.filter(query: 'indo');
// Returns [Indonesia]

// Filter by country code
final byCode = PhoneCountries.all.filter(
  query: 'ID',
  filterOptions: CountryFilterOptions.codeOnly,
);

// Filter by dial code
final byDialCode = PhoneCountries.all.filter(
  query: '+62',
  filterOptions: CountryFilterOptions.dialCodeOnly,
);

// Filter by all fields (name, code, dial code)
final byAll = PhoneCountries.all.filter(
  query: 'united',
  filterOptions: CountryFilterOptions.all,
);

// Custom filter with where()
final filtered = PhoneCountries.where(
  (country) => country.dialCode.startsWith('+6'),
);
```

### Detect Country from Phone Number

```dart
final country = PhoneCountries.detectFromPhoneNumber('+6281234567890');
print(country?.name); // Indonesia
print(country?.code); // ID
```

### Display Country Flags

Use `flagAssetPath` with your preferred SVG library:

```dart
// With flutter_svg (in Flutter projects)
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  CountryCode.ID.flagAssetPath,
  width: 32,
  height: 24,
)
```

### Get All Countries

```dart
// Get all countries
final allCountries = PhoneCountries.all;

// Get total count
final count = PhoneCountries.count;
```

## CountryCode Enum

The `CountryCode` enum provides instant access to all country data:

```dart
CountryCode.ID  // Indonesia
CountryCode.US  // United States
CountryCode.GB  // United Kingdom
CountryCode.JP  // Japan
CountryCode.CN  // China
// ... 240+ countries
```

### CountryCode Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | String | Country name |
| `dialCode` | String | Dial code with '+' |
| `code` | String | ISO 3166-1 alpha-2 code |
| `dialCodeWithoutPlus` | String | Dial code without '+' |
| `lowercaseCode` | String | Lowercase country code |
| `flagAssetPath` | String | SVG flag asset path |

## PhoneCountries API Reference

| Method | Description |
|--------|-------------|
| `all` | Returns all countries |
| `count` | Returns total number of countries |
| `findByCode(String)` | Find country by ISO code |
| `getByCode(String)` | Get country by ISO code (throws if not found) |
| `findByDialCode(String)` | Find countries by dial code |
| `searchByName(String)` | Search countries by name |
| `where(predicate)` | Filter countries with custom logic |
| `exists(String)` | Check if country code exists |
| `detectFromPhoneNumber(String)` | Detect country from phone number |
| `formatPhoneNumber(CountryCode, String)` | Format phone number with dial code |
| `extractLocalNumber(String)` | Extract local number from international |

## List Extension Methods

Use these extension methods on any `List<CountryCode>`:

| Method | Description |
|--------|-------------|
| `sortedByName()` | Returns new list sorted alphabetically by name |
| `sortedByDialCode()` | Returns new list sorted numerically by dial code |
| `sortedByCode()` | Returns new list sorted by ISO country code |
| `groupedByAlphabet({query, filterOptions})` | Group by first letter with optional filtering |
| `filter({query, filterOptions})` | Filter by name, code, and/or dial code |

## CountryFilterOptions

| Option | Description |
|--------|-------------|
| `CountryFilterOptions.all` | Filter by all fields (name, code, dial code) |
| `CountryFilterOptions.nameOnly` | Filter by name only (default) |
| `CountryFilterOptions.codeOnly` | Filter by country code only |
| `CountryFilterOptions.dialCodeOnly` | Filter by dial code only |
| `CountryFilterOptions({byName, byCode, byDialCode})` | Custom filter options |

## Why Simple Phone Countries?

Most country picker packages require async loading of JSON data. This package:

1. **Pre-compiles all data** into Dart enums
2. **Loads instantly** with no Future/await needed
3. **Type-safe** with compile-time checks
4**Better performance** for country pickers and phone inputs

## Credits

This package uses assets and data from the following sources:

- **SVG Flag Icons**: [lipis/flag-icons](https://github.com/lipis/flag-icons) - A curated collection of all country flags in SVG format.
- **Country Dial Codes Data**: [anubhavshrimal/CountryCodes](https://gist.github.com/anubhavshrimal/75f6183458db8c453306f93521e93d37) - Country codes with dial codes JSON data.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
