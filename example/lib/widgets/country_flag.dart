import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_phone_countries/simple_phone_countries.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.country, this.width = 32, this.height = 24});

  final CountryCode country;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      country.flagAssetPath,
      width: width,
      height: height,
      placeholderBuilder: (context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}
