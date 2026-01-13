import 'package:flutter/material.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

import 'widgets/widgets.dart';

class CountrySearchTab extends StatefulWidget {
  const CountrySearchTab({super.key});

  @override
  State<CountrySearchTab> createState() => _CountrySearchTabState();
}

class _CountrySearchTabState extends State<CountrySearchTab> {
  final TextEditingController _searchController = TextEditingController();

  List<CountryCode> _results = [];

  @override
  void initState() {
    super.initState();

    _results = PhoneCountries.all.sortedByName();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _results = PhoneCountries.all.sortedByName();
      } else {
        _results = PhoneCountries.all.filter(
          query: query,
          filterOptions: CountryFilterOptions.all,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name, code, or dial code...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _onSearch,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '${_results.length} countries found',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) => CountryListTile(_results[index]),
          ),
        ),
      ],
    );
  }
}
