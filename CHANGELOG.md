# Changelog

All notable changes to this project will be documented in this file.

## 1.0.1

### Added
- Enhanced documentation with more examples
- Add documentation for CountryFilterOptions constructor
- Reorganize documentation structure

## 1.0.0

### Added
- Initial release
- `CountryCode` enum with 240+ countries (pre-loaded, no async needed)
  - `name` - Country name
  - `dialCode` - International dial code
  - `code` - ISO 3166-1 alpha-2 code
  - `dialCodeWithoutPlus` - Dial code without '+' prefix
  - `lowercaseCode` - Lowercase country code
  - `flagAssetPath` - Path to SVG flag asset
- `PhoneCountries` utility class with:
  - `all` - Get all countries
  - `count` - Get total country count
  - `findByCode()` - Find country by ISO code
  - `getByCode()` - Get country by ISO code (throws if not found)
  - `findByDialCode()` - Find countries by dial code
  - `searchByName()` - Search countries by name
  - `where()` - Filter countries with custom predicate
  - `sortedByName` / `sortedByDialCode` - Sorted country lists
  - `groupedByAlphabet` - Countries grouped by first letter (A-Z)
  - `exists()` - Check if country code exists
  - `detectFromPhoneNumber()` - Detect country from phone number
  - `formatPhoneNumber()` - Format phone number with dial code
  - `extractLocalNumber()` - Extract local number from international number
- SVG country flags for all countries
