import 'package:buecherkreisel_flutter/components/insertation_preview.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: sampleDataInseration.length,
      itemBuilder: (c, index) =>
          InserationPreview(inseration: sampleDataInseration[index]),
    );
  }
}
