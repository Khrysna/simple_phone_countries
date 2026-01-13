import 'package:flutter/material.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

import 'widgets/widgets.dart';

class CountryListTab extends StatelessWidget {
  const CountryListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = PhoneCountries.all.groupedByAlphabet();

    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final letter = grouped.keys.elementAt(index);
        final countries = grouped[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(letter: letter),
            ...countries.map((country) => CountryListTile(country)),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String letter;

  const _SectionHeader({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Text(
        letter,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
