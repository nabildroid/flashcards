import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const StatisticCard({
    Key? key,
    required this.children,
    required this.title,
  }) : super(key: key);

  static const padding = 12.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          ...children,
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
