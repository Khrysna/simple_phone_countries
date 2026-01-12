import 'package:flutter/material.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

import 'country_flag.dart';

class CountryListTile extends StatelessWidget {
  const CountryListTile(this.country, {super.key});

  final CountryCode country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CountryFlag(country: country),
      title: Text(country.name),
      subtitle: Text('${country.code} • ${country.dialCode}'),
      onTap: () {},
    );
  }
}
