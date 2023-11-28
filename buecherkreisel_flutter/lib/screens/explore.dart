import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/insertion_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InsertionState>(
      builder: (c, insertionState, w) {
        insertionState.getAllInsertionsRemote();
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: insertionState.insertions.length,
          itemBuilder: (c, index) =>
              InsertionPreview(insertion: insertionState.insertions[index]),
        );
      },
    );
  }
}
