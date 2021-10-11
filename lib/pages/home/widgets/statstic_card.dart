import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final List<Widget> children;
  const StatisticCard({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: this.children,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
