import 'package:flutter/material.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

import 'widgets/widgets.dart';

class CountryPhoneDetectTab extends StatefulWidget {
  const CountryPhoneDetectTab({super.key});

  @override
  State<CountryPhoneDetectTab> createState() => _CountryPhoneDetectTabState();
}

class _CountryPhoneDetectTabState extends State<CountryPhoneDetectTab> {
  final TextEditingController _phoneController = TextEditingController();

  CountryCode? _detectedCountry;
  String? _localNumber;

  void _detectCountry() {
    String phoneNumber;
    phoneNumber = _phoneController.text.trim();
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+$phoneNumber';
    }

    setState(() {
      _detectedCountry = PhoneCountries.detectFromPhoneNumber(phoneNumber);
      _localNumber = PhoneCountries.extractLocalNumber(phoneNumber);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          Text('Detect Country from Phone Number', style: Theme.of(context).textTheme.titleLarge),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Enter phone number (e.g., +6281234567890)',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (_) => _detectCountry(),
          ),
          if (_detectedCountry != null) ...{
            _DetectedCountryCard(country: _detectedCountry!, localNumber: _localNumber),
          } else if (_phoneController.text.isNotEmpty) ...{
            const _NoDetectionCard(),
          },
        ],
      ),
    );
  }
}

class _DetectedCountryCard extends StatelessWidget {
  final CountryCode country;
  final String? localNumber;

  const _DetectedCountryCard({required this.country, required this.localNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text('Detected Country:', style: Theme.of(context).textTheme.titleMedium),
            Row(
              spacing: 16,
              children: [
                CountryFlag(country: country, width: 48, height: 36),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(country.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${country.code} • ${country.dialCode}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (localNumber != null) ...[
              Text('Local Number: $localNumber', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoDetectionCard extends StatelessWidget {
  const _NoDetectionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 12,
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            const Expanded(
              child: Text('Could not detect country. Make sure the number not start with 0'),
            ),
          ],
        ),
      ),
    );
  }
}
