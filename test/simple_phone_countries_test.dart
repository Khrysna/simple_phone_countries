import 'package:flutter_test/flutter_test.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

void main() {
  group('CountryCode', () {
    test('contains all expected countries', () {
      expect(CountryCode.values.length, greaterThan(200));
    });

    test('ID returns Indonesia', () {
      expect(CountryCode.ID.name, 'Indonesia');
      expect(CountryCode.ID.dialCode, '+62');
      expect(CountryCode.ID.code, 'ID');
    });

    test('US returns United States', () {
      expect(CountryCode.US.name, 'United States');
      expect(CountryCode.US.dialCode, '+1');
      expect(CountryCode.US.code, 'US');
    });

    test('dialCodeWithoutPlus removes plus sign', () {
      expect(CountryCode.ID.dialCodeWithoutPlus, '62');
    });

    test('lowercaseCode returns lowercase', () {
      expect(CountryCode.ID.lowercaseCode, 'id');
    });

    test('flagAssetPath returns correct path', () {
      expect(CountryCode.ID.flagAssetPath,
          'packages/simple_phone_countries/assets/flags/id.svg');
    });
  });

  group('PhoneCountries', () {
    test('all returns all countries', () {
      final all = PhoneCountries.all;
      expect(all.length, CountryCode.values.length);
    });

    test('count returns correct number', () {
      expect(PhoneCountries.count, CountryCode.values.length);
    });

    test('findByCode finds country correctly', () {
      final country = PhoneCountries.findByCode('ID');
      expect(country?.name, 'Indonesia');
    });

    test('findByCode is case insensitive', () {
      final country1 = PhoneCountries.findByCode('id');
      final country2 = PhoneCountries.findByCode('ID');
      expect(country1, country2);
    });

    test('findByCode returns null for invalid code', () {
      final country = PhoneCountries.findByCode('XX');
      expect(country, isNull);
    });

    test('getByCode throws for invalid code', () {
      expect(
          () => PhoneCountries.getByCode('XX'), throwsA(isA<ArgumentError>()));
    });

    test('findByDialCode finds countries correctly', () {
      final countries = PhoneCountries.findByDialCode('+62');
      expect(countries.any((c) => c.code == 'ID'), true);
    });

    test('findByDialCode handles code without plus', () {
      final countries = PhoneCountries.findByDialCode('62');
      expect(countries.any((c) => c.code == 'ID'), true);
    });

    test('findByDialCode returns multiple countries for shared codes', () {
      final countries = PhoneCountries.findByDialCode('+1');
      expect(countries.length, greaterThan(1));
    });

    test('searchByName finds matching countries', () {
      final results = PhoneCountries.searchByName('united');
      expect(results.length, greaterThanOrEqualTo(3));
      expect(results.any((c) => c.name.contains('United States')), true);
      expect(results.any((c) => c.name.contains('United Kingdom')), true);
    });

    test('searchByName is case insensitive', () {
      final results1 = PhoneCountries.searchByName('indonesia');
      final results2 = PhoneCountries.searchByName('INDONESIA');
      expect(results1.length, results2.length);
    });

    test('where filters correctly', () {
      final filtered = PhoneCountries.where((c) => c.dialCode.startsWith('+6'));
      expect(filtered.every((c) => c.dialCode.startsWith('+6')), true);
    });

    test('exists returns true for valid code', () {
      expect(PhoneCountries.exists('ID'), true);
      expect(PhoneCountries.exists('id'), true);
    });

    test('exists returns false for invalid code', () {
      expect(PhoneCountries.exists('XX'), false);
    });

    test('detectFromPhoneNumber detects Indonesian number', () {
      final country = PhoneCountries.detectFromPhoneNumber('+6281234567890');
      expect(country?.code, 'ID');
    });

    test('detectFromPhoneNumber detects US number', () {
      final country = PhoneCountries.detectFromPhoneNumber('+12025551234');
      expect(country, isNotNull);
    });

    test('detectFromPhoneNumber returns null for invalid number', () {
      final country = PhoneCountries.detectFromPhoneNumber('81234567890');
      expect(country, isNull);
    });

    test('formatPhoneNumber formats correctly', () {
      final formatted =
          PhoneCountries.formatPhoneNumber(CountryCode.ID, '81234567890');
      expect(formatted, '+6281234567890');
    });

    test('formatPhoneNumber removes leading zeros', () {
      final formatted =
          PhoneCountries.formatPhoneNumber(CountryCode.ID, '081234567890');
      expect(formatted, '+6281234567890');
    });

    test('extractLocalNumber extracts correctly', () {
      final local = PhoneCountries.extractLocalNumber('+6281234567890');
      expect(local, '81234567890');
    });
  });

  group('CountryCodeListExtension', () {
    test('sortedByName() returns alphabetically sorted list', () {
      final sorted = PhoneCountries.all.sortedByName();
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(
            sorted[i].name.compareTo(sorted[i + 1].name), lessThanOrEqualTo(0));
      }
    });

    test('sortedByDialCode() returns numerically sorted list', () {
      final sorted = PhoneCountries.all.sortedByDialCode();
      for (int i = 0; i < sorted.length - 1; i++) {
        final a = int.tryParse(sorted[i].dialCodeWithoutPlus) ?? 0;
        final b = int.tryParse(sorted[i + 1].dialCodeWithoutPlus) ?? 0;
        expect(a, lessThanOrEqualTo(b));
      }
    });

    test('sortedByCode() returns alphabetically sorted by ISO code', () {
      final sorted = PhoneCountries.all.sortedByCode();
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(
            sorted[i].code.compareTo(sorted[i + 1].code), lessThanOrEqualTo(0));
      }
    });

    test('groupedByAlphabet() groups countries correctly', () {
      final grouped = PhoneCountries.all.groupedByAlphabet();

      // Check alphabetical keys
      expect(grouped.containsKey('A'), true);
      expect(grouped.containsKey('I'), true);
      expect(grouped.containsKey('U'), true);

      // Check Indonesia is in 'I' group
      expect(grouped['I']!.any((c) => c.code == 'ID'), true);

      // Check all countries are included
      final totalCount =
          grouped.values.fold<int>(0, (sum, list) => sum + list.length);
      expect(totalCount, CountryCode.values.length);
    });

    test('groupedByAlphabet() with query filters by name', () {
      final grouped = PhoneCountries.all.groupedByAlphabet(
        query: 'Indo',
        filterOptions: CountryFilterOptions.nameOnly,
      );

      // Should only have 'I' key (Indonesia)
      expect(grouped.containsKey('I'), true);
      expect(grouped['I']!.any((c) => c.code == 'ID'), true);
      expect(grouped['I']!.length, 1);
    });

    test('groupedByAlphabet() with query filters by code', () {
      final grouped = PhoneCountries.all.groupedByAlphabet(
        query: 'ID',
        filterOptions: CountryFilterOptions.codeOnly,
      );

      // Should contain Indonesia (ID)
      expect(grouped.containsKey('I'), true);
      expect(grouped['I']!.any((c) => c.code == 'ID'), true);
    });

    test('groupedByAlphabet() with query filters by dial code', () {
      final grouped = PhoneCountries.all.groupedByAlphabet(
        query: '+62',
        filterOptions: CountryFilterOptions.dialCodeOnly,
      );

      // Should only have Indonesia (+62)
      expect(grouped.containsKey('I'), true);
      expect(grouped['I']!.any((c) => c.code == 'ID'), true);
    });

    test('groupedByAlphabet() with all filter options', () {
      final grouped = PhoneCountries.all.groupedByAlphabet(
        query: 'united',
        filterOptions: CountryFilterOptions.all,
      );

      // Should have United States, United Kingdom, United Arab Emirates
      expect(grouped.containsKey('U'), true);
      expect(grouped['U']!.any((c) => c.name.contains('United')), true);
    });

    test('filter() returns countries matching name query', () {
      final result = PhoneCountries.all.filter(
        query: 'indo',
        filterOptions: CountryFilterOptions.nameOnly,
      );

      expect(result.any((c) => c.code == 'ID'), true);
    });

    test('filter() returns countries matching code query', () {
      final result = PhoneCountries.all.filter(
        query: 'US',
        filterOptions: CountryFilterOptions.codeOnly,
      );

      expect(result.any((c) => c.code == 'US'), true);
    });

    test('filter() returns countries matching dial code query', () {
      final result = PhoneCountries.all.filter(
        query: '62',
        filterOptions: CountryFilterOptions.dialCodeOnly,
      );

      expect(result.any((c) => c.code == 'ID'), true);
    });

    test('filter() with all options searches all fields', () {
      final result = PhoneCountries.all.filter(
        query: '+1',
        filterOptions: CountryFilterOptions.all,
      );

      // Should find US, Canada, and other +1 countries
      expect(result.isNotEmpty, true);
      expect(result.any((c) => c.code == 'US'), true);
    });

    test('filter() returns empty list for no match', () {
      final result = PhoneCountries.all.filter(
        query: 'xyznonexistent',
        filterOptions: CountryFilterOptions.all,
      );

      expect(result.isEmpty, true);
    });

    test('filter() returns full list for empty query', () {
      final result = PhoneCountries.all.filter(
        query: '',
        filterOptions: CountryFilterOptions.all,
      );

      expect(result.length, CountryCode.values.length);
    });
  });
}
