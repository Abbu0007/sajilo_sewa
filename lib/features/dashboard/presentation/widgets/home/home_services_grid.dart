import 'package:flutter/material.dart';

class HomeServicesGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const HomeServicesGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    double childAspectRatio = 2.2;

    if (width >= 900) {
      crossAxisCount = 4;
      childAspectRatio = 2.4;
    } else if (width >= 600) {
      crossAxisCount = 3;
      childAspectRatio = 2.3;
    }

    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => itemBuilder(i),
    );
  }
}